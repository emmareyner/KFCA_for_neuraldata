function [Y]=mpower(X,n);
% mmp.l.mpower max-plus algebraic power of matrix or scalar   
%
% mmp.l.mpower(X,n) = X^n.
%
%     Z = X^y is X to the y maxplus power if y is a scalar and X is square:
%       - if y == 0, this is the identity matrix with the same dim as X.
%       - if y == 1, then X is copied onto Y.
%       - If y is an integer greater than one, the power is computed by
%       repeated squaring.
%       - if y == -1 this is essentially the ctranspose of X in maxplus.
%       - For other values of y the calculation involves residuation
%  
%     Z = X^Y, where both X and Y are matrices, is an error.
%  
%     C = MPOWER(A,B) is called for the syntax 'A ^ B' when A or B is a
%     sparse maxminplus object
%
%   See also: mmp.u.mpower, mmp.x.mpower, mmp.l.power
%
%     Z = x^Y is x to the Y power if Y is a square matrix and x is a scalar.
%     Computed using eigenvalues and eigenvectors.
%  

%   If X is a scalar then function calls MP_POWERS(X,n).
%   If X is a square matrix, n must be non-negative integers or (-1).
%   If n is 0 then result is an identity matrix this same size as X,  i.e. function calls MP_EYE(size(X))
%   If n is equal to (-1) then the function calls MP_INV(X).
%   If X is not a square matrix operation is not defined.
%   If X is a square matrix, but n is not  non-negative integers or (-1) operation is not defined.
%
%   MP_POWERS, MP_MULTI, MP_INV, MP_DIV, MP_DIVS.
%
% Author: fva, 11/29/07
error(nargchk(2,2,nargin));
[mX, nX] = size(X);
if (mX ~= nX)||(mX==0)%neither square nor scalar or zero-dimensional
    error('mmp:l:mpower','Non-square parameter X');
end

%Case dispatching on the dimension of the matrix.
switch mX
    case 1%base is a number
        Y = mmp.l.powers(X,n);
    otherwise%base is a square matrix.
        [Mn Nn]=size(n);
        if (Mn ~= Nn)
            error('mmp:l:mpower','Non-square parameter n');
        end
        switch Mn
            case 1%scalar exponent
                if ~isinteger(n)
                    error('mmp:l:mpower','Scalar exponent needs to be integer!')
                end
                %Case dispatching on the exponent
                sig = sign(n);
                %Obtain the sign and save for later
                n = abs(n);
                switch sig
                    case 0
                        Y=mmp.l.eye(m);
                    case 1
                        Y=piprod(X,n);
                    case -1
                        Y=mmp.l.ctranspose(piprod(X,n));%mmp.l.ctranspose(piprod(X,n))
                end
            otherwise%matrix exponent
                error('mmp.l.mpower: n must be a scalar (non-negative integer or (-1))!');
        end
end
return% Y
end

%n is guaranteed to be positive
function [P]=piprod(X,n)
switch n
    case 1
        P=X;
    case 2
        P=mmp.l.mtimes(X,X);
    otherwise
        P=mmp.l.mtimes(X,X);
        if (mod(n,2) ==0)%n is even
            %n = n/2;
            P=piprod(P,n/2);
        else%n is odd
            %n = (n-1)/2;
            P=mmp.l.mtimes(X,piprod(P,(n-1)/2));
        end
end
return
end
