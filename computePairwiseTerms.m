function pairwiseTerms = computePairwiseTerms(unaryTerms, alpha, idx, dir)
% input 'dir' must be a string listed here {'LR', 'RL', 'UD', 'DU'}

[height, width, nbUnary] = size(unaryTerms);
    
    if (dir == 'LR')

        pairwiseTerms = zeros(width, nbUnary, nbUnary);
        
        for pix = 2:width
            for i = 1:nbUnary
                for j = 1:nbUnary

                    pairwiseTerms(pix, i, j) = unaryTerms(idx, pix, i) - unaryTerms(idx, pix - 1,j);
                end
            end
        end

        pairwiseTerms = alpha*abs(pairwiseTerms);
        
    elseif (dir == 'RL')

        pairwiseTerms = zeros(width, nbUnary, nbUnary);
        
        for pix = 2:width
            for i = 1:nbUnary
                for j = 1:nbUnary

                    pairwiseTerms(width - pix + 1, i, j) = unaryTerms(idx, width - pix + 1, i) - unaryTerms(idx, width - pix  + 2,j);
                end
            end
        end
        
        pairwiseTerms = alpha*abs(pairwiseTerms);


    elseif (dir == 'UD')

        pairwiseTerms = zeros(height, nbUnary, nbUnary);
        
        for pix = 2:height
            for i = 1:nbUnary
                for j = 1:nbUnary

                    pairwiseTerms(pix, i, j) = unaryTerms(pix, idx, i) - unaryTerms(pix - 1,  idx, j);
                end
            end
        end

        pairwiseTerms = alpha*abs(pairwiseTerms);

    elseif (dir == 'DU')

        pairwiseTerms = zeros(height, nbUnary, nbUnary);
        
        for pix = 2:height
            for i = 1:nbUnary
                for j = 1:nbUnary

                    pairwiseTerms(height - pix + 1, i, j) = unaryTerms(height - pix + 1, idx, i) - unaryTerms(height - pix + 2,  idx, j);
                end
            end
        end
        
        pairwiseTerms = alpha*abs(pairwiseTerms);
    end
end