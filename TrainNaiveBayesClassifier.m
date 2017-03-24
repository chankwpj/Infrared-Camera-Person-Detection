function [Mdl] = TrainNaiveBayesClassifier(positiveImagePaths, negativeImagePaths)
%Getting positive and negative data set to train NaiveBasesClassifier by
%DCT
%Detailed explanation goes here

index = 1;
labels = [];
numberOfData = length(positiveImagePaths) + length(negativeImagePaths);

%% Generating Negative DCT Descriptor %%
numberOfImages = length(negativeImagePaths);
for i_file = 1:numberOfImages
    % Read image
    im = imread(char(negativeImagePaths(i_file))); 
    descriptor = GenerateDCTDiscriptor(im);
    table(index, 1:441) = descriptor;
    labels = [labels, 0];
    index = index +1 ;
end
%% Generating Positive DCT Descriptor %%
numberOfImages = length(positiveImagePaths);
for i_file = 1:numberOfImages
    % Read image
    im = imread(char(positiveImagePaths(i_file)));    
    descriptor = GenerateDCTDiscriptor(im);
    table(index, 1:441) = descriptor;
    labels = [labels, 1];
    index = index +1 ;
end

%% training
Mdl = fitcnb(table,labels');
return

end

