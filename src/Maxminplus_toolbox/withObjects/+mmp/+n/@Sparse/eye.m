function Z = eye(M,N)
% OO sparse lower eye matrix
switch nargin
    case 1
        Z = mmp.n.Sparse(mmp_u_speye(M));
    case 2
        Z = mmp.n.Sparse(mmp_u_speye(M,N));
    otherwise
        error(nargchk(1,2,nargin))
end
return
