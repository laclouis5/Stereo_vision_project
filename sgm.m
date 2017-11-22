function [L] = sgm(unaryTerms, alpha)

[height, width, nbUnary] = size(unaryTerms);

L1 = unaryTerms;
L2 = unaryTerms;
L3 = unaryTerms;
L4 = unaryTerms;

T = alpha * toeplitz(0:nbUnary - 1);

% left-right direction
for i = 1:height
    for j = 2:width
        
        temp(:) = L1(i, j - 1, :);
        
        M(1, 1, :) = min(T + temp, [], 2);      
        L1(i, j, :) = unaryTerms(i, j, :) + M;
    end
end

% right-left direction
for i = height:-1:1
    for j = width - 1:-1:1
        
        temp(:) = L2(i, j + 1, :);
      
        M(1, 1, :) = min(T + temp, [], 2);   
        L2(i, j, :) = unaryTerms(i, j, :) + M;
    end
end

% up-down direction
for i = 2:height
    for j = 1:width
        
        temp(:) = L3(i - 1, j, :);
        
        M(1, 1, :) = min(T + temp, [], 2);      
        L3(i, j, :) = unaryTerms(i, j, :) + M;
    end
end

% right-left direction
for i = height - 1:-1:1
    for j = width:-1:1
        
        temp(:) = L4(i + 1, j, :);
      
        M(1, 1, :) = min(T + temp, [], 2);   
        L4(i, j, :) = unaryTerms(i, j, :) + M;
    end
end

L = L1 + L2 + L3 + L4;

end