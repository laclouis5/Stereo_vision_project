function [R] = crossCor(img1, img2, winSize)

    xlim = floor(winSize/2);
    ylim = floor(winSize/2);
    
    [h, w, ~] = size(img1);
    
    R = zeros(h, w);
    
    I1 = double(rgb2gray(img1))/255;
    I2 = double(rgb2gray(img2))/255;
    
    H = hamming(winSize);
    
    for i = 1 + xlim:h - xlim
        for j = 1 + ylim:w - ylim
            
            i1 = I1(i - xlim:i + xlim, j - ylim:j + ylim).*H;
            i2 = I2(i - xlim:i + xlim, j - ylim:j + ylim).*H;
            
            f1 = fft2(i1);
            f2 = fft2(i2);
            
            f  = f1.*conj(f2);
            
            r = abs(ifft2(f./abs(f)));
            r = r(1, :);
            
            M = find(r == max(r));
            R(i, j) = M;   
        end
    end
end
