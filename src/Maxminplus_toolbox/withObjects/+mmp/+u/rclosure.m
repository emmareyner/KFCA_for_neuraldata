function rclos = rclosure(r)
% function rclos = mmp.u.rclosure(r)
%
% For square matrices, it returns the upper reflexive closure of the
% matrix, i.e. mmp.u.plus(mmp.u.eye(n),r). For non-square, it tries to
% upper-add a zero to the diagonal of the matrix; this can't be a closure.
%
% Tries to avoid carrying out a lot of maxplus additions. 
%
% fva, Apr-Jul 2008
    
error(nargchk(1,1,nargin));

if isa(r,'mmp.sparse')
    rclos=urclosure(r);
elseif isa(r,'mmp.double')
    rclos=urclosure(r);
else
    error('mmp:u:rclosure','Wrong input type')
end
return%rclos

