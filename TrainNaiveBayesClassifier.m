function [Mdl] = TrainNaiveBayesClassifier(positiveImagePaths, negativeImagePaths)
%Getting positive and negative data set to train NaiveBasesClassifier by
%Generate DCT discriptor of each data and feed it to Bayes Classifier


index = 1;
labels = [];
numberOfData = length(positiveImagePaths) + length(negativeImagePaths);

%% Generating Negative DCT Descriptor %%
t1 = datetime('now');
numberOfImages = length(negativeImagePaths);
for i_file = 1:numberOfImages
    i_file
    % Read image
    im = imread(char(negativeImagePaths(i_file))); 
    if (length(size(im)) >= 3)
        im = rgb2gray(im);
    end
    
    %extract MSER features and group it
    [regions,cc] = detectMSERFeatures(im);
    if regions.Count == 0    
        descriptor = GenerateDCTDiscriptor(im);
        table(index, 1:441) = descriptor;
        labels = [labels, 0];
        index = index +1 ;
    else
        group = MergeMSERRegions(regions);
        [my mx] = size(im);
        storage = FindBoundingBox(regions, group, mx, my);
        for i = 1:2:length(storage)
            minx = storage(i,1);
            miny = storage(i+1,1);
            maxx = storage(i,2);
            maxy = storage(i+1,2);
            mser = im(miny:maxy, minx:maxx);
            if (FilterNonHumanMSER(minx,miny,maxx,maxy)) % check mser ratio
                descriptor = GenerateDCTDiscriptor(mser); %get dct resize in method
                table(index, 1:441) = descriptor;
                labels = [labels, 0];
                index = index +1 ;
            end
        end
    end
    
    
end
t2 = datetime('now');
t2 - t1
%% Generating Positive DCT Descriptor %%
numberOfImages = length(positiveImagePaths);
for i_file = 1:numberOfImages
    % Read image
    im = imread(char(positiveImagePaths(i_file)));    
    descriptor = GenerateDCTDiscriptor(im);
    table(index, 1:441) = descriptor;
    labels = [labels, 1];
    index = index +1;
end

%% training
Mdl = fitcnb(table,labels);
return

end

