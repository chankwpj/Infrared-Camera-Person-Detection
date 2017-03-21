%% Paper %%
%https://pdfs.semanticscholar.org/f376/711bbe5cc71089e0c74982cafed5f6bdae79.pdf?_ga=1.49846566.1631971690.1490113648

%% Read Trainning Data %%
close all; clear all; clc;
path_root = 'C:/Users';
addpath(genpath(path_root));

path_training_images1 = fullfile(path_root,'/THERMAL/train/positives');
path_training_images2 = fullfile(path_root,'/THERMAL/train/negatives');
path_testing_images = fullfile(path_root,'/THERMAL/test');

index = 1;
labels = [];
%% Generating Positive DCT Descriptor %%
files = dir(fullfile(path_training_images1,'*.png'));
numberOfImages = length(files);
for i_file = 1:numberOfImages
    % Read image
    image_file = fullfile(path_training_images1, files(i_file).name);
    im = imread(image_file);    
    im = imresize(im, [32 ,16]);
    descriptor = [];
    %Sliding Window
    for r = 1:4:25
        for c = 1:4:9
            data = im(r:r+7, c:c+7);
            dct = dct2(data);
            dct = reshape(dct, [1, 64]);
            dct = dct(1:21);
            descriptor = [descriptor, dct];
        end
    end
    table(index, 1:441) = descriptor;
    labels = [labels, 1];
    index = index +1 ;
end

%% Generating Negative DCT Descriptor %%
files = dir(fullfile(path_training_images2,'*.png'));
numberOfImages = length(files);
for i_file = 1:numberOfImages
    % Read image
    image_file = fullfile(path_training_images2, files(i_file).name);
    im = imread(image_file);    
    im = imresize(im, [32 ,16]);
    descriptor = [];
    %Sliding Window
    for r = 1:4:25
        for c = 1:4:9
            data = im(r:r+7, c:c+7);
            dct = dct2(data);
            dct = reshape(dct, [1, 64]);
            dct = dct(1:21);
            descriptor = [descriptor, dct];
        end
    end
    table(index, 1:441) = descriptor;
    labels = [labels, 0];
    index = index +1 ;
end
%% Train Classifier %%
Mdl = fitcnb(table,labels');
