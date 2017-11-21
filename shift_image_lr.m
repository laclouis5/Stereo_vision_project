function Is = shift_image_lr(Ie, shift)

    dimx = size(Ie, 2);
    
    if (shift > 0)
        Is(:, shift + 1:dimx, :) = Ie(:, 1:dimx - shift, :);
        Is(:, 1:shift, :) = 0;
        
    elseif (shift < 0)
        Is(:, 1:dimx + shift, :) = Ie(:, -shift + 1:dimx, :);
        Is(:, dimx + shift:dimx, :) = 0;
    
    else
        Is = Ie;
    end
end
