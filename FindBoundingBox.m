function [ storage ] = FindBoundingBox( regions, group, imgmaxx, imgmaxy )
    % find the extream coordinate values of groups
    % each group find xmin max ymin ymax
    % use matrix as storage like below
    % gp1 xmin xmax
    % gp1 ymin ymax
    % gp2 xmin xmax
    % gp2 ymin ymax ..etc
    maxGroupID = max(group);
    storage = zeros((maxGroupID)*2, 2);
    storage(:,1) = 10000;
    %based on the group, generate thoes ellipses, and find the extream
    %coordinates 
    for i = 1:length(group)
        xy = regions(i).Location;
        axy = regions(i).Axes;
        [ex ey] = Ellipse(xy(1),xy(2),axy(1), axy(2), regions(i).Orientation+189.9);
    %     plot(ex, ey)
        minx = min(ex);
        maxx = max(ex);
        miny = min(ey);
        maxy = max(ey);
        ind = group(i)*2 - 1;
        if (minx < storage(ind,1) )
            storage(ind,1) = minx;
        end
        if (maxx > storage(ind,2) )
            storage(ind,2) = maxx;
        end
        if (miny < storage(ind+1,1))
            storage(ind+1,1) = miny;
        end
        if (maxy > storage(ind+1,2) )
            storage(ind+1,2) = maxy;
        end
    end
    storage = round(storage);
    %delete points where outside the box
    storage(storage < 1 ) = 1;
    
    for i = 1:size(storage,1)
       if mod(i,2) == 1 %X
           %delete points where outside the box
            if storage(i,2) > imgmaxx
                storage(i,2) = imgmaxx;
            end
       else
           %delete points where outside the box
            if storage(i,2) > imgmaxy
                storage(i,2) = imgmaxy;
            end
       end
    end
end

