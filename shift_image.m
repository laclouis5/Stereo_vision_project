function Is = shift_image(Ie, shift)

    dimx = size(Ie, 2);
    
    if (shift > 0)
        Is(:, shift + 1:dimx, :) = Ie(:, 1:dimx - shift, :);
        Is(:, 1:shift, :) = NaN;
        
    elseif (shift < 0)
        Is(:, 1:dimx + shift, :) = Ie(:, -shift + 1:dimx, :);
        Is(:, dimx + shift + 1:dimx, :) = NaN;
    
    else
        Is = Ie;
    end
end
