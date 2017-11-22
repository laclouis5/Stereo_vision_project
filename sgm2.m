function [L] = sgm2(unaryTerms, alpha)

[height, width, nbUnary] = size(unaryTerms);
D = zeros(nbUnary, 1);

L    = unaryTerms;
% nbIt = width*height*nbUnary*nbUnary;

% left-right direction

for i = 1:height
    for j = 2:width
        for d1 = 1:nbUnary
            
            for d2 = 1:nbUnary  
                
                D(d2) = L(i, j - 1, d2) + alpha * abs(d2 - d1);
            end
            
            L(i, j, d1) = unaryTerms(i, j, d1) + min(D);
        end
    end
end