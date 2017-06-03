function [ isHumanBoundingBox ] = FilterNonHumanMSER( leftTopx, leftTopy, rightDownx, rightDowny )
% Filter the Bounding box by its ratio
    % human contained bounding box should be height >= width

    isHumanBoundingBox = true;
    width = rightDownx - leftTopx;
    height = rightDowny - leftTopy;
    if (width *height > 5000) 
        isHumanBoundingBox = false;
    end
    

%     %reject result width > height
%     if width > height 
%        isHumanBoundingBox = false;
%     else
%         %height >= width
%         %idea ration is w/h ~0.5
%         ratio = width/height;
%         if ratio > 0.5 && ratio < 1
%             isHumanBoundingBox = true;
%         else 
%             isHumanBoundingBox = false;
%         end
%     end
end

