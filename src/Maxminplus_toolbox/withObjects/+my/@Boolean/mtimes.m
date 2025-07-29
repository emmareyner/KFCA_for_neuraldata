function Z=mtimes(X,Y)
% function Z=mtimes(X,Y), works out the boolean matrix product of X
% and Y, where numbers are multiplied with & and added  with |
%
% FVA: 12/03/09
error(nargchk(2,2,nargin));
Z = my.Boolean(my.logical.mtimes(logical(X),logical(Y)));
return%Z
