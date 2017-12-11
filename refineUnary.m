function [unaryTerms] = refineUnary(img1, img2, mins, maxs, disp1, disp2, sizeWin, sigma)

    [h, w, ~] = size(img1);
    nbDisparity = abs(maxs - mins) + 1;
    
    unaryTerms = zeros(h, w, nbDisparity);
    len = floor(sizeWin/2);
    
    step = sign(maxs - mins);
    
    for j = 1 + len:w - len
        for i = 1 + len:h - len
            
            d = disp1(i, j);
            s = img1(i - len:i + len, j - len:j + len, :);
            
            for k = mins:step:maxs
                
                if (j - len - k > 0 && j + len - k <= w)
                    s2 = img2(i - len:i + len, j - len - k:j + len - k, :);

                    win = disp1(i - len:i + len, j - len - k:j + len - k) - d;
                    % win = exp((-win.*win)/(2*sigma*sigma));
                    win = 2./(1 + exp(sigma*win));
                    diff = s - s2.*win;
                    
                    unaryTerms(i, j, abs(k - mins) + 1) = sum(sum(sum(abs(diff))));
                    
                else
                    unaryTerms(i, j, abs(k - mins) + 1) = NaN;
                end
            end
        end
    end
end

