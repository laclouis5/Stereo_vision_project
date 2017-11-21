function Is = shift_image_ud(Ie, shift)

    dimy = size(Ie, 1);
    
    if (shift > 0)
        Is(shift + 1:dimy, :, :) = Ie(1:dimy - shift, :, :);
        Is(1:shift, :, :) = 0;
        
    elseif (shift < 0)
        Is(1:dimy + shift, :, :) = Ie(-shift + 1:dimy, :, :);
        Is(dimy + shift:dimy, :, :) = 0;
    
    else
        Is = Ie;
    end
end
