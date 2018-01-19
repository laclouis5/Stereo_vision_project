    function [imgOut] = censusTransform(imgIn, winSize)

    imgOut = imgIn;
    [h, w, ~] = size(imgIn);
    
    S = floor(winSize/2);
    
    for i = S + 1:h - S
        for j = S + 1:w - S
            
            m = 0;
            temp = "";
            
            for k = -S:S
                for l = -S:S
                    
                    m = m + imgIn(i + k, j + l);
                    
                end
            end
            
            m = m/winSize^2;
            
            for k = -S:S
                for l = -S:S    
                    if (k ~= 0 || l ~= 0)
                        
                        val = imgIn(i + k, j + l);
                        
                        if val >= m   
                            
                            temp = temp + "1";
                        else
                            
                            temp = temp + "0";

                        end

                    end
                end
            end
            
            num = bin2dec(temp);
            
            imgOut(i, j) = num;
        end
    end
end

