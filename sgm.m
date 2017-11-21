function [L] = sgm(unaryTerms, alpha)

[height, width, nbUnary] = size(unaryTerms);

L  = zeros(size(unaryTerms));
L1 = zeros(size(unaryTerms));
L2 = zeros(size(unaryTerms));
L3 = zeros(size(unaryTerms));
L4 = zeros(size(unaryTerms));

L1(:, 1, :) = unaryTerms(:, 1, :);

for line = 1:height
    
    pairWiseTerms = computePairwiseTerms(unaryTerms, alpha, line, 'LR');
    
    for col = 2:width
        for d = 1:nbUnary

            tmp = min(L(line, col - 1, :) + pairWiseTerms(col, d, :));
            L1(line, col, d) = unaryTerms(line, col, d) + tmp;
        end
    end
end

% L2(:, width, :) = unaryTerms(:, width, :);
% 
% for line = 1:height
%     
%     pairWiseTerms = computePairwiseTerms(unaryTerms, alpha, line, 'RL');
%     
%     for col = 2:width
%         for d = 1:nbUnary
%             
%             tmp = min(L(line, width - col + 2, :) + pairWiseTerms(width - col + 1, d, :));
%             L2(line, width - col + 1, d) = unaryTerms(line, width - col + 1, d) + tmp;
%         end
%     end
% end
% 
% L3(1, :, :) = unaryTerms(1, :, :);
% 
% for col = 1:width
%     
%     pairWiseTerms = computePairwiseTerms(unaryTerms, alpha, col, 'UD');
%     
%     for line = 2:height
%         for d = 1:nbUnary
% 
%             tmp = min(L(line - 1, col, :) + pairWiseTerms(line, d, :));
%             L1(line, col, d) = unaryTerms(line, col, d) + tmp;
%         end
%     end
% end
% 
% L4(height, :, :) = unaryTerms(height, :, :);
% 
% for col = 1:width
%     
%     pairWiseTerms = computePairwiseTerms(unaryTerms, alpha, col, 'UD');
%     
%     for line = 2:height
%         for d = 1:nbUnary
% 
%             tmp = min(L(height - line + 2, col, :) + pairWiseTerms(height - line + 1, d, :));
%             L1(height - line + 1, col, d) = unaryTerms(height - line + 1, col, d) + tmp;
%         end
%     end
% end

L = L1 + L2 + L3 + L4;

end
