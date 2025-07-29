function Z=mtimes(X,Y)
% function Z=mtimes(X,Y), works out the logical matrix product of X
% and Y, where numbers are multiplied with & and added  with |
%
% FVA: 12/03/09
error(nargchk(2,2,nargin));

[mX,nX]=size(X);
[mY,nY]=size(Y);
if nX ~= mY
    error('my:logical:mtimes','non-conformant matrices');
elseif mX * nX * nY == 0%some of the dimensions are zero, just return
    Z= sparse(mX,nY);
else%matrices are stored in column-principal order
    Z = my.logical.mtimes_raw(X,Y);
end
return%Z
