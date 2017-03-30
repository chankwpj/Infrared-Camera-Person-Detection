function [ isHumanBoundingBox ] = FilterNonHumanMSER( leftTopx, leftTopy, rightDownx, rightDowny )
% Filter the Bounding box by its ratio
    % human contained bounding box should be height >= width
    
    isHumanBoundingBox = false;
    width = rightDownx - leftTopx;
    height = rightDowny - leftTopy;
    %reject result width > height
    if width > height 
       isHumanBoundingBox = false;
    else
        %height >= width
        %idea ration is w/h ~0.5
        ratio = width/height;
        if ratio > 0.15 && ratio < 0.85
            isHumanBoundingBox = true;
        else 
            isHumanBoundingBox = false;
        end
    end
end

