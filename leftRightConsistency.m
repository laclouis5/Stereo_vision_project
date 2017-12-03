function [rectifiedDispMap1, rectifiedDispMap2] = leftRightConsistency(dispMap1, dispMap2, thresh)
   
    rectifiedDispMap1 = dispMap1;
    rectifiedDispMap2 = dispMap2;

    [h, w, ~] = size(dispMap1);
    
    for i = 1:h
        for j = 1:w
            pos1  = j - dispMap1(i, j);
            pos2  = j - dispMap2(i, j);
            
            diff1 = dispMap1(i, j) + dispMap2(i, pos1);
            diff2 = dispMap2(i, j) + dispMap1(i, pos2);
            
            if diff1 > thresh
                rectifiedDispMap1(i, j) = NaN;
                
            end
            
            if diff2 > thresh
                rectifiedDispMap2(i, j) = NaN;  
                
            end
        end
    end
end
