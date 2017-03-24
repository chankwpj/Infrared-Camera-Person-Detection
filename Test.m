close all; clear; clc;

% path_root = '/media/c1531993/C058-0E28/';
path_root = 'F:/';
addpath(genpath(path_root));

path_training_positives = fullfile(path_root,'/train/positives');
path_training_negatives = fullfile(path_root,'/train/negatives');
path_testing = fullfile(path_root,'/Test');

%% Training Data Paths
files = dir(fullfile(path_training_positives,'*.png'));
numberOfImages = length(files);
positiveFullPath = {};
for i_file = 1:numberOfImages
    positiveFullPath{i_file} = fullfile(path_training_positives,files(i_file).name);
end

files = dir(fullfile(path_training_negatives,'*.png'));
numberOfImages = length(files);
negativeFullPath = {};
for i_file = 1:numberOfImages
    negativeFullPath{i_file} = fullfile(path_training_negatives,files(i_file).name);
end
%% Train Naive Bayes
Mdl = TrainNaiveBayesClassifier(positiveFullPath, negativeFullPath)

%% test real data
clear im
im = rgb2gray(imread('F:/Test/p6.jpg'));
% im = imread('F:/Test/f1.png');
[regions,cc] = detectMSERFeatures(im);

%result of MSER
figure();
imshow(im);hold on;
plot(regions); hold off;

%check the center of MSER regions are neighbours by assigning group number 
%eg. regions(1) group id is output of group(1) 
numCenters = regions.Count;
group = zeros(1, numCenters);
group(1) = 1;
currentGroupID = 2;
for i = 1:numCenters
    if (group(i) == 0)
        group(i) = currentGroupID;
        currentGroupID = currentGroupID + 1;
    end
    iID = group(i);
    pt1 = regions(i).Location;
    for j = (i+1):numCenters
        pt2 = regions(j).Location;
        %check the are neighbour
        if (CheckIsNeighbour(pt1, pt2))
           group(j) = group(i);
        end
    end
end

% group;
%%

% check the extream coordinate value of groups
% each group find xmin max ymin ymax
% use matrix as storage like below
% gp1 xmin xmax
% gp1 ymin ymax
% gp2 xmin xmax
% gp2 ymin ymax ..etc
% figure();
% imshow(im);hold on;
storage = zeros((currentGroupID-1)*2, 2);
storage(:,1) = 10000;
for i = 1:length(group)
    xy = regions(i).Location;
    axy = regions(i).Axes;
    [ex ey] = Ellipse(xy(1),xy(2),axy(1), axy(2), regions(i).Orientation+189.9);
%     plot(ex, ey)
    minx = min(ex);
    maxx = max(ex);
    miny = min(ey);
    maxy = max(ey);
    ind = group(i)*2 - 1;
    if (minx < storage(ind,1) )
        storage(ind,1) = minx;
    end
    if (maxx > storage(ind,2) )
        storage(ind,2) = maxx;
    end
    if (miny < storage(ind+1,1))
        storage(ind+1,1) = miny;
    end
    if (maxy > storage(ind+1,2) )
        storage(ind+1,2) = maxy;
    end
end


storage = round(storage);
storage(storage < 1 ) = 1;
[my mx] = size(im); 
% shapeInserter = vision.ShapeInserter;
shapeInserterP = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom',...
'CustomBorderColor', uint8([0,255,0]));

shapeInserterN = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom',...
'CustomBorderColor', uint8([255,0,0]));

RGB = cat(3, im, im, im);

for i = 1:2:length(storage)
    minx = storage(i,1);
    miny = storage(i+1,1);
    maxx = storage(i,2);
    if maxx > mx
        maxx = mx;
    end
    maxy = storage(i+1,2);
    if maxy > my
        maxy = my;
    end
    %crop the "box" from the image
    mser = im(miny:maxy, minx:maxx);
    mser = imresize(mser,[32,16]); %resize
    dct = GenerateDCTDiscriptor(mser); %get dct
    label = predict(Mdl,dct) %classifier
    
    rec = int32([minx, miny, maxx-minx, maxy-miny]);
    if label == 1
        RGB = shapeInserterP(RGB, rec); % if is positive draw the green "box" 
    else
        RGB = shapeInserterN(RGB, rec); % else red box
    end
end


imshow(RGB)
