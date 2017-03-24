function [ descriptor ] = GenerateDCTDiscriptor( im )
%GENERATEDCTDISCRIPTOR Summary of this function goes here
%   Detailed explanation goes here
    if size(im) ~= [32 16]
        im = imresize(im, [32 ,16]);
    end
    descriptor = zeros(1,441);
    index = 1;
    %Sliding Window
    for r = 1:4:25
        for c = 1:4:9
            data = im(r:r+7, c:c+7);
            dct = dct2(data);
            dct = reshape(dct, [1, 64]);
            dct = dct(1:21);
            descriptor(index:index+20) = dct;
            index = index + 20 + 1;
        end
    end
    return 
end

