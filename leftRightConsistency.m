function [rectifiedDispMap1, rectifiedDispMap2] = leftRightConsistency(dispMap1, dispMap2, thresh)
    
    rectifiedDispMap1 = dispMap1;

    [h, w, ~] = size(dispMap1);
    
    for i = 1:h
        for j = 1:w
            
            pos  = j - dispMap1(i, j) + 1;
            diff = dispMap1(i, j) + dispMap2(i, pos);
            
            if diff > thresh
                rectifiedDispMap1(i, j) = NaN;
            end
        end
    end
end

