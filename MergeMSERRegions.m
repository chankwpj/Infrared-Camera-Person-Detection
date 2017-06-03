function [ group ] = MergeMSERRegions( regions )
    %check the center of MSER regions are neighbours by assigning group number 
    %eg. regions(1) group id is output of group(1) 
    numCenters = regions.Count;
    group = zeros(1, numCenters);
    group(1) = 1;
    currentGroupID = 2;
    for i = 1:numCenters
        if (group(i) == 0)
            group(i) = currentGroupID;
            currentGroupID = currentGroupID + 1;
        end
        iID = group(i);
        pt1 = regions(i).Location;
        for j = (i+1):numCenters
            pt2 = regions(j).Location;
            %check the are neighbour
            if (CheckIsNeighbour(pt1, pt2))
               group(j) = group(i);
            end
        end
    end
end

