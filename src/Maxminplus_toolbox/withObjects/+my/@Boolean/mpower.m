function [Y]=mpower(X,n)
% mpower  algebraic power of logical matrix or scalar   
%
% mpower(X,n) = X^n.
%
%     Z = X^y is X to the y power if y is a scalar and X is square:
%       - if y == 0, this is the identity matrix with the same dim as X.
%       - if y == 1, then X is copied onto Y.
%       - If y is an integer greater than one, the power is computed by
%       repeated squaring.
%       - For other values of y the calculation involves residuation
%  
%     Z = X^Y, where both X and Y are matrices, is an error.
%
% Author: fva, 04/09

Y = my.Boolean(logical.mpower(logical(X),n));
return%Y
% %%Parameter validation
% %error(nargchk(2,2,nargin));
% [mX, nX] = size(X);
% if (mX ~= nX) || (mX==0)%neither square nor scalar or zero-dimensional
%     error('logical:mpower','Non-square input matrix');
% end
% [mn nn]=size(n);
% if (mn ~= nn)
%     error('logical:mpower','Non-square exponent');
% elseif (nn ~=1)
%     error('logical:mpower','n must be an integer scalar');
% end
% 
% %Case dispatching on the dimension of the base
% switch n
%     case 0
%         Y = rclosure(false(mX,mX));
%     case 1%base is a number
%         Y = X;
%     otherwise%base is a square proper matrix, exponent a scalar
%         if n < 0
%             error('logical:mpower','undefined matrix power on negative exponent');
%         else
%             %use n for i, Y to accumulate result, X to accumulate
%             %factor
%             if issparse(X)
%                 Y = logical(speye(mX));
%             else
%                 Y = logical(eye(mX));
%             end
%             while n > 0
%                 if bitget(n,1)%first bit to 1 => odd
%                     Y = mtimes_raw(Y,X);%use a raw primitive!
%                 end
%                 %X = mmp_l_square_raw(X);%use a squaring primitive!
%                 X = mtimes_raw(X,X);
%                 n = bitshift(n,-1);%divide by two
%             end
%         end
% end
% return% Y
