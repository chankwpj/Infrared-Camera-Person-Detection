workingDir = 'C:\Users\Kai\Desktop\Infrared-Camera-Person-Detection\video';
imageNames = dir(fullfile(workingDir,'images','*.jpg'));
imageNames = {imageNames.name}';
shuttleVideo = VideoReader('shuttle.avi');

outputVideo = VideoWriter(fullfile(workingDir,'seq2video.avi'));
outputVideo.FrameRate = shuttleVideo.FrameRate;
open(outputVideo)

for ii = 1:length(imageNames)
   img = imread(fullfile(workingDir,'images',imageNames{ii}));
   writeVideo(outputVideo,img)
end

close(outputVideo)