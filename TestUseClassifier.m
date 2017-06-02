close all; clear; clc;

% path_root = '/media/c1531993/C058-0E28/flir_17_Sept_2013/';
path_root = 'F:\flir_17_Sept_2013';
addpath(genpath(path_root));

%%
% Mdl = load('classifier.mat')
% Mdl = Mdl.Mdl

%% test real data
clear im
% im = rgb2gray(imread('/media/c1531993/C058-0E28/Test/p1.jpg'));
im = rgb2gray(imread('F:/StableSet/HumanBg/t.jpg'));
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
shapeInserterB = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom',...
'CustomBorderColor', uint8([0 0 255]));


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
            RGB = shapeInserterB(RGB, rec); % else red box
        end
    else
        RGB = shapeInserterN(RGB, rec); % blue box
    end
end

imshow(RGB)
