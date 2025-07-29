function [Y]=mmp_u_mpower(X,n)
% mmp_u_mpower maxminplus lower algebraic power of matrix or scalar   
%
% mmp_u_mpower(X,n) = X^n.
%
%     Z = X^y is X to the y min-plus power if y is a scalar and X is square:
%       - if y == 0, this is the identity matrix with the same dim as X.
%       - if y == 1, then X is copied onto Y.
%       - If y is an integer greater than one, the power is computed by
%       repeated squaring.
%       - if y == -1 this is essentially the ctranspose of X in maxplus.
%       - For other values of y the calculation involves residuation
%  
%     Z = X^Y, where both X and Y are matrices, is an error.
%
% Author: fva, 04/09

%%Parameter validation
error(nargchk(2,2,nargin));
[mn nn]=size(n);
n32=uint32(n);%Guarantee positive exponent... Maybe should be moved to mpower_raw
if (mn == nn) && (nn == 1) && (n==n32)%Check for positive scalar exponent
    [mX, nX] = size(X);
    if (mX == nX) && (mX~=0)%check for non-zero dimensional square matrix
        %Case dispatching on the dimension of the base
        Y = mmp_u_mpower_raw(X,n);
    else %neither square nor scalar or zero-dimensional
        error('Double:mmp_u_mpower','Non-square input matrix');
    end
elseif (mn ~= nn)
    error('Double:mmp_u_mpower','Non-square exponent');
elseif (n32 ~= n) 
    if n == -1
        Y = mmp_u_mpower(X,-1);
    else
        error('Double:mmp_u_mpower','exponent must be a positive integer scalar');
    end
end
return% Y
%% Parameter validation
% %error(nargchk(2,2,nargin));
% [mX, nX] = size(X);
% if (mX ~= nX) || (mX==0)%neither square nor scalar or zero-dimensional
%     error('Double:mmp_u_mpower','Non-square input matrix');
% end
% [mn nn]=size(n);
% if (mn ~= nn)
%     error('Double:mmp_u_mpower','Non-square exponent');
% end
% if (nn ~=1)
% %     error('Double:mmp:l:mpower','matrix exponent');
%     error('Double:mmp_u_mpower','n must be an integer scalar');
% end
% 
% %Case dispatching on the dimension of the base
% switch mX
%     case 1%base is a number
%         if X == 0
%             if n == -Inf,
%                 Y = -Inf;%to cater for 0 *(l) log0 == -Inf
%             else
%                 Y = 0;
%             end
%         elseif n == 0
%             Y = 0;%whatever X
%         else
%             Y = n*X;%considers both n > 0 and n < 0
%         end
%     otherwise%base is a square proper matrix, exponent a scalar
%         if ~isinteger(n)
%             error('mmp:l:mpower','Scalar exponent needs to be integer!')
% %         elseif n == 0
% %             Y = mmp_u_eye(mX);
%         else%repeated squaring, after the wikipedia
%             if n < 0
%                 X = -X.';%mmp_u_inv(X)
%                 n = -n;
%             end
%             %use n for i, Y to accumulate result, X to accumulate
%             %factor
%             if issparse(X)
%                 Y = mmp_u_speye(mX);
%             else
%                 Y = mmp_u_eye(mX);
%             end
%             while n > 0
%                 if bitget(n,1)%first bit to 1 => odd
%                     Y = mmp_u_mtimes(Y,X);%use a raw primitive!
%                 end
%                 %X = mmp_u_square_raw(X);%use a squaring primitive!
%                 X = mmp_u_mtimes_raw(X,X);
%                 n = bitshift(n,-1);%divide by two
%             end
%         end
% end
% return% Y
