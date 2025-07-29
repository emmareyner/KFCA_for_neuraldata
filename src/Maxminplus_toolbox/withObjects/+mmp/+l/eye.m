function [Z]=eye(X,Y)
% eye - max-plus algebraic identity matrix in maxplus encoding format.
%
%   eye(N) returns the N x N maxplus identity matrix.
%   eye returns the max-plus unit (0).
%   eye(X) or eye([X]) is an X-by-X max-plus identity matrix 
%       with max-plus ones (0's) on the main diagonal 
%       and max-plus zeros (Inf's) elsewhere,
%   eye(X,Y) or eye([X,Y]) is an X-by-Y matrix 
%       of max-plus ones on the main diagonal.
%   eye(SIZE(A)) is the same size as A.
%
%   See also one, ones, zero, zeros, diag

% FVA 25/02/09
switch nargin
    case 1
        %Z=mmp_l_speye(X);
        Z = mmp.x.Sparse.eye(X);
    case 2
        %Z=mmp_l_speye(X,Y);
         Z = mmp.x.Sparse.eye(X,Y);
    otherwise
        error(nargchk(1,2,nargin))
end
return

