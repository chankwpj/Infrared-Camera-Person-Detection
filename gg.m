path_training_negatives = fullfile(path_root,'flir_17_Sept_2013/train/negatives1');

files = dir(fullfile(path_training_negatives,'*.png'));
numberOfImages = length(files);
negativeFullPath = {};
for i_file = 1:numberOfImages
    
    negativeFullPath{i_file} = fullfile(path_training_negatives,files(i_file).name);
    im = imread(char(negativeFullPath{i_file})); 
    if (length(size(im)) >= 3)
        im = rgb2gray(im);
    end
    [regions,cc] = detectMSERFeatures(im);
    figure();
    imshow(im); hold on;
    plot(regions)
end