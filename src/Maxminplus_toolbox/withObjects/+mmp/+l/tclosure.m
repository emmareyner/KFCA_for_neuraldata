function Rplus = tclosure(R)
% function Rplus = mmp.l.tclosure(R)
%
% Returns the max-plus transitive (aka metric matrix, A+) closure of a
% non-null square matrix.
%
% For strictly positive elements, it uses an iterative algorithm
% and it may take forever! (A warning is issued.)  
%
% See also, mp_Rplus for the original version in the toolbox.
error(nargchk(1,1,nargin));

% TODO: Two considerations pulling in different directions:
% - Stars with positive elements will almost always end up with a
%number of Infs. Sometimes it will be better to represent them in
%minplus encoding
% - Since Rpluss are almost always almost full, we transform as soon
% as possible into full doubles
% This analysis should rely in the eigenvalues of the matrix to distinguish
% when the matrix will become full of Infs or full of numbers.
switch class(R)
    case 'double'
        Rplus = mmp_l_tclosure(R);
    case 'mmp.x.Sparse'
        Rplus = tclosure(R);
    otherwise
        error('mmp:l:tclosure','wrong input data type')
end
return
