close all; clear; clc;

path_root = '/media/c1531993/C058-0E28/flir_17_Sept_2013/';
% path_root = 'F:/';
addpath(genpath(path_root));

path_training_positives = fullfile(path_root,'train/positives');
% path_training_negatives = fullfile(path_root,'flir_17_Sept_2013/train/negatives1');
path_testing = fullfile(path_root,'/Test');

%% Training Data Paths

files = dir(fullfile(path_training_positives,'*.png'));
numberOfImages = length(files);
positiveFullPath = {};
fileIndex = 1;
for i_file = 1:numberOfImages
    positiveFullPath{fileIndex} = fullfile(path_training_positives,files(i_file).name);
    fileIndex = fileIndex + 1; 
end


negativeFullPath = {};
fileIndex = 1;
for nFolder = 5:12
    path_training_negatives = fullfile(path_root,['Sempach-', num2str(nFolder)] , '8bit');
    files = dir(fullfile(path_training_negatives,'*.png'));
    numberOfImages = length(files);
    for i_file = 1:numberOfImages
        negativeFullPath{fileIndex} = fullfile(path_training_negatives,files(i_file).name);
        fileIndex = fileIndex + 1;
    end
end


%{
files = dir(fullfile(path_training_positives,'*.png'));
numberOfImages = length(files);
positiveFullPath = {};
fileIndex = 1;
for i_file = 1:5:numberOfImages
    positiveFullPath{fileIndex} = fullfile(path_training_positives,files(i_file).name);
    fileIndex = fileIndex + 1; 
end

files = dir(fullfile(path_training_negatives,'*.png'));
numberOfImages = length(files);
negativeFullPath = {};
for i_file = 1:numberOfImages
    negativeFullPath{i_file} = fullfile(path_training_negatives,files(i_file).name);
end
%}
%% Train Naive Bayes
Mdl = TrainNaiveBayesClassifier(positiveFullPath, negativeFullPath)

%% test real data
clear im
% im = rgb2gray(imread('/media/c1531993/C058-0E28/Test/p1.jpg'));
im = rgb2gray(imread('/media/c1531993/C058-0E28/StableSet/HumanBg/t.jpg'));
% im = imread('F:/Test/f1.png');
[regions,cc] = detectMSERFeatures(im);

%result of MSER
figure();
imshow(im);hold on;
plot(regions); hold off;

if regions.Count == 0
   return % stop  
end

group = MergeMSERRegions(regions);

% figure();
% imshow(im);hold on;

%%
[my mx] = size(im); 
%storage
% gp1 xmin xmax
% gp1 ymin ymax
% gp2 xmin xmax
% gp2 ymin ymax ..etc
storage = FindBoundingBox(regions, group, mx, my);

% shapeInserter = vision.ShapeInserter;
shapeInserterP = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom',...
'CustomBorderColor', uint8([0 255 0]));
shapeInserterN = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom',...
'CustomBorderColor', uint8([255 0 0]));


RGB = cat(3, im, im, im);
% each group of MSER
for i = 1:2:length(storage)
    minx = storage(i,1);
    miny = storage(i+1,1);
    maxx = storage(i,2);
    maxy = storage(i+1,2);
    %crop the "box" from the image
    mser = im(miny:maxy, minx:maxx);
    
    %check if the bounding box size ratio is human like
    if (FilterNonHumanMSER(minx,miny,maxx,maxy))
        dct = GenerateDCTDiscriptor(mser); %get dct resize in method
        label = predict(Mdl,dct) %classifier
        rec = int32([minx, miny, maxx-minx, maxy-miny]);
        if label == 1
            RGB = shapeInserterP(RGB, rec); % if is positive draw the green "box" 
        else
            RGB = shapeInserterN(RGB, rec); % else red box
        end
    else
        RGB = shapeInserterN(RGB, rec); % else red box
    end
end

imshow(RGB)
