function [Z]=eye(X,Y)
% mmp.u.eye - min-plus algebraic identity matrix
%
%   mmp.u.eye(N) returns the N x N minplus identity matrix.
%   mmp.u.eye returns the min-plus unit (0).
%   mmp.u.eye(X) or mmp.u.eye([X]) is an X-by-X min-plus identity matrix 
%       with min-plus ones (0's) on the main diagonal 
%       and min-plus zeros (Inf's) elsewhere,
%   mmp.u.eye(X,Y) or mmp.u.eye([X,Y]) is an X-by-Y matrix 
%       of min-plus ones on the main diagonal.
%   mmp.u.eye(SIZE(A)) is the same size as A.
%
%   See also mmp.u.one, mmp.u.ones, mmp.u.zero, mmp.u.zeros, mmp.u.diag

% FVA 25/02/09
switch nargin
    case 1
        Z=mmp.n.Sparse.eye(X);
    case 2
        Z=mmp.n.Sparse.eye(X,Y);
    otherwise
        error(nargchk(1,2,nargin))
end
return

