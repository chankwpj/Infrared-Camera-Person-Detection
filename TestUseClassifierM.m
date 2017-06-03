close all; clear; clc;

path_root = 'C:\Users\Kai\Desktop\Infrared-Camera-Person-Detection\Testing\T1';
files = dir(fullfile(path_root,'*.jpg'));
numberOfImages = length(files);
TestFullPath = {numberOfImages,1};
for i_file = 1:numberOfImages
    TestFullPath {i_file} = fullfile(path_root,files(i_file).name);
end
%%
Mdl = load('classifier.mat');
Mdl = Mdl.Mdl;

%%
% shapeInserter = vision.ShapeInserter;
shapeInserterP = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom',...
'CustomBorderColor', uint8([0 255 0]));
shapeInserterN = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom',...
'CustomBorderColor', uint8([255 255 255]));
shapeInserterB = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom',...
'CustomBorderColor', uint8([0 0 255]));
t1= datetime('now');

count = zeros(i_file,1);
parfor (i_file = 1:numberOfImages, 2)
% for i_file = 1:numberOfImages
    im = imread(TestFullPath{i_file});
    if size(im,3) > 1
        im = rgb2gray(im);
    end
        
    [regions,cc] = detectMSERFeatures(im);
    if regions.Count == 0
        imwrite(im, strcat('./Result/', num2str(i_file),'.jpg'));
        continue;
    end
    group = MergeMSERRegions(regions);
    [my mx] = size(im); 
    storage = FindBoundingBoxWithMargin(regions, group, mx, my, 7, 7);
    RGB = cat(3, im, im, im);
    % each group of MSER
    for i = 1:2:length(storage)
        minx = storage(i,1);
        miny = storage(i+1,1);
        maxx = storage(i,2);
        maxy = storage(i+1,2);
        %crop the "box" from the image
        mser = im(miny:maxy, minx:maxx);
        rec = int32([minx, miny, maxx-minx, maxy-miny]);
        %check if the bounding box size ratio is human like
        if (FilterNonHumanMSER(minx,miny,maxx,maxy))
            dct = GenerateDCTDiscriptor(mser); %get dct resize in method
            label = predict(Mdl,dct); %classifier;
            
            if label == 1
                RGB = shapeInserterP(RGB, rec); % if is positive draw the green "box" 
                count(i_file,1) = count(i_file,1)+1 ;
            else
                %RGB = shapeInserterB(RGB, rec); % else blue box
            end
        else
            %RGB = shapeInserterN(RGB, rec); % white box
        end
        imwrite(RGB, strcat('./Result/', num2str(i_file),'.jpg'));
    end
end
