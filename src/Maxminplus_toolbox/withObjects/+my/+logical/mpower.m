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

%%Parameter validation
error(nargchk(2,2,nargin));
[mn nn]=size(n);
n32=uint32(n);%Guarantee positive exponent... Maybe should be moved to mpower_raw
if (mn == nn) && (nn == 1) && (n==n32)%Check for positive scalar exponent
    [mX, nX] = size(X);
    if (mX == nX) && (mX~=0)%check for non-zero dimensional square matrix
        %Case dispatching on the dimension of the base
        Y = logical.mpower_raw(X,n32);
    elseif (mn ~= nn)
        error('logical:mpower','Non-square exponent');
    elseif (nn ~=1)
        error('logical:mpower','n must be an integer scalar');
    end
else %neither square nor scalar or zero-dimensional
    error('logical:mpower','Non-square input matrix');
end
return% Y
