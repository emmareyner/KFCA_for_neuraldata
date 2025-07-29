function star = tclosure(R)
% function star = mmp.u.tclosure(R)
%
% Returns the min-plus transitive (aka quasi-metria, A_+) closure of a
% non-null square matrix.
%
% For strictly negative elements, it uses an iterative algorithm
% and it may take forever! (A warning is issued.)  
%
% See also, mp_star for the original version in the toolbox.
error(nargchk(1,1,nargin));

% TODO: Two considerations pulling in different directions:
% - Stars with negative elements will almost always end up with a
%number of Infs. Sometimes it will be better to represent them in
%maxplus encoding
% - Since stars are almost always almost full, we transform as soon
% as possible into full doubles
%
% This analysis should rely in the eigenvalues of the matrix to distinguish
% when the matrix will become full of -Infs or full of numbers.
switch class(R)
    case 'double'
        star = mmp_u_tclosure(R);
    case 'mmp.n.Sparse'
        star = mmp.n.Sparse(mmp_l_nXnZ_tclosure(R));
    otherwise
        error('mmp:u:tclosure','wrong input data type')
end
return
