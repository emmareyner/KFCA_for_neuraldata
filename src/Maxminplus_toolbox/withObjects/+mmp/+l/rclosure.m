function rclos = rclosure(r)
% function rclos = mmp.l.rclosure(r)
%
% For square matrices, it returns the reflexive closure of the matrix,
% i.e. mmp.l.plus(mmp.l.eye(n),r). For non-square, it tries to add a zero to the
% diagonal of the matrix; this can't be a closure.
%
% Tries to avoid carrying out a lot of maxplus additions. 
%
% fva, Apr-Jul 2008
    
error(nargchk(1,1,nargin));

switch class(r)
    case 'double'
        rclos=mmp_l_rclosure(r);
    case 'mmp.x.Sparse'
        rclos=rclosure(r);
    case 'mmp.n.Sparse'
        rclos=rclosure(r);
    otherwise
        error('mmp:l:rclosure','Wrong input type')
end
return%rclos

