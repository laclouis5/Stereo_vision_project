function [unaryTerms] = computeUnaryTerms(i1, i2, mins, maxs, win_size)
% Compute Unary terms between i1 and i2
% unaryTerms(i,j,d) is the disparity cost for pixel (i,j) in image I1:
% Disparity values are tested within [mins..maxs]
% A square window of size (win_size,win_size) is used

    [dimy,dimx,~] = size(i1);
    nbDisparity   = abs(maxs - mins) + 1;
    unaryTerms    = zeros(dimy,dimx,nbDisparity); %-- init outputs

    h = ones(win_size)/win_size.^2;  %-- averaging filter

    step = sign(maxs-mins);          %-- adjusts to reverse slide

    for i=mins:step:maxs
        
        s = shift_image_lr(i2, i);  %-- shift image and derivs

        %--CSAD  is Cost from Sum of Absolute Differences
        diffs = sum(abs(i1 - s), 3); %-- get CSAD

        unaryTerms(:,:,abs(i-mins)+1) = imfilter(diffs,h);

    end

end
