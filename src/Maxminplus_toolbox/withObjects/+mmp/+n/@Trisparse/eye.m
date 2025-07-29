function [Z]=eye(X,Y)
% mmp.n.eye - min-plus algebraic identity matrix in minplus sparse format.
%
%   mmp.n.eye(N) returns the N x N minplus identity matrix.
%   mmp.n.eye returns the min-plus unit (0).
%   mmp.n.eye(X) or mmp.n.eye([X]) is an X-by-X min-plus identity matrix 
%       with min-plus ones (0's) on the main diagonal 
%       and min-plus zeros (Inf's) elsewhere,
%   mmp.n.eye(X,Y) or mmp.n.eye([X,Y]) is an X-by-Y matrix 
%       of min-plus ones on the main diagonal.
%   mmp.n.eye(SIZE(A)) is the same size as A.
%
%   See also mmp.n.one, mmp.n.ones, mmp.n.zero, mmp.n.zeros, mmp.n.diag

% FVA 25/02/09
error(nargchk(0,2,nargin));
if nargin == 1, Y=X; end
if isscalar(X) && isscalar(Y)
    Z = mmp.n.sparse(X,Y);
    co=1:min(X,Y);
    idx=sub2ind([X Y],co,co);
    Z.Unitp(idx)=true;
else
    error('mmp:n:sparse:eye','wrong input arguments')
end
return%Z

