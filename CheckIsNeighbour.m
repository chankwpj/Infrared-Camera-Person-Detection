function bool = CheckIsNeighbour(pt1, pt2)
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