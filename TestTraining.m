clear; 
path_root = 'C:\Users\Kai\Desktop\Infrared-Camera-Person-Detection\Training';
path_training_positives = fullfile(path_root,'\positives');
path_training_negatives = fullfile(path_root,'\negatives');



%% Positive Training Data Paths

files = dir(fullfile(path_training_positives,'*.jpg'));
numberOfImages = length(files);
positiveFullPath = {numberOfImages,1};
fileIndex = 1;
for i_file = 1:numberOfImages
    positiveFullPath{fileIndex} = fullfile(path_training_positives,files(i_file).name);
    fileIndex = fileIndex + 1; 
end
%% Negative Training Data Paths
files = dir(fullfile(path_training_negatives,'*.jpg'));
numberOfImages = length(files);
negativeFullPath = {numberOfImages,1};
fileIndex = 1;
for i_file = 1:numberOfImages
    negativeFullPath{fileIndex} = fullfile(path_training_negatives,files(i_file).name);
    fileIndex = fileIndex + 1; 
end

%% Train Naive Bayes
Mdl = TrainNaiveBayesClassifierP(positiveFullPath, negativeFullPath)
save classifier Mdl
Mdl