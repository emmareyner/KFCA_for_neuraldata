function Z = eye(M,N)
% OO sparse lower eye matrix
switch nargin
    case 1
        Z = mmp.x.Sparse(mmp_l_speye(M));
    case 2
        Z = mmp.x.Sparse(mmp_l_speye(M,N));
    otherwise
        error(nargchk(1,2,nargin))
end
return
