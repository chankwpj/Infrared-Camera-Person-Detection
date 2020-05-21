Introduction:
Project aims to recognize person with low-resolution camera
1. MRSE as key point detection
2. Discrete cosine transform as descriptor
3. Naive Bayes classifier as recognition

The steps are based on the following paper
https://pdfs.semanticscholar.org/f376/711bbe5cc71089e0c74982cafed5f6bdae79.pdf?_ga=1.49846566.1631971690.1490113648

Data Source:
http://projects.asl.ethz.ch/datasets/doku.php?id=ir%3Airicra2014
http://www.polymtl.ca/litiv/en/vid/
http://vcipl-okstate.org/pbvs/bench/

The used training data and testing data are zipped as Training.zip and Testing.zip

Usage:
Change paths in these two files
```
TestTraining.m
path_root = 'C:\Users\Kai\Desktop\Infrared-Camera-Person-Detection\Training';
path_training_positives = fullfile(path_root,'\positives');
path_training_negatives = fullfile(path_root,'\negatives');
```
```
TestUseClassifier.m
path_root = 'C:\Users\Kai\Desktop\Infrared-Camera-Person-Detection\Testing';
files = dir(fullfile(path_root,'*.jpg'));
```

Methods
TestUseClassifier TrainNaiveBayesClassifier are general version which not require Parallel Computing Toolbox 
TestUseClassifierM, TrainNaiveBayesClassifierP are parallelize version which require Parallel Computing Toolbox, it is still in develope prcoess and not ready to use due to race condition is not well tested.
