function bool = CheckIsNeighbour(pt1, pt2)
% check the MSER regions are close enought to be merged
% if distance between to regions are shorter than 80, horiztially distance is checked.
% if the horiztial distance is too far. Reject the reuslt
    d = pdist([pt1;pt2],'euclidean');
    if d <= 80 %40
        bool = 1;
        %if horizitally apart (x range). they should be different objects
        xRange = abs(pt1(1) - pt2(1));
        if (xRange > 20)
            bool = 0;
            return
        end
    else
        bool = 0;
    end
end