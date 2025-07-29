function Z = stimes(s,X)
% OO lower maxplus scalar multiplication
%
% function Z = mmp_l_stimes_raw(s,X)
%
% -s is double[1x1]
% -X is full or sparse double[m x n]
% - Z is double full, essentially.
%
% CAVEAT: this is a RAW primitive: no dimension or type checking is done. 
% author: fva 09/09
error(nargchk(2,2,nargin));
[ms ns] = size(s);

if ms == 1 && ms == ns && is
    Z = stimes_raw(s,X);
else
    error('mmp:x:Sparse:stimes','incorrect input parameters')
end
return%Z
