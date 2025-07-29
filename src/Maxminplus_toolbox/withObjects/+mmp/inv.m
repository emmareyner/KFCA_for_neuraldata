function X=inv(S)
% Sconj = inv(S) Return the Cuninghame-Green conjugate [Sconj] for a
% matrix [S]. Works for any type of convention for [S].
%
% inv(S) == opposite(transpose(S)) == transpose(opposite(S))
%
% See also: xnp_inv, xnp_transpose.

% original coding: FVA 24/02/2009
switch class(S)
    case 'double'
        X = -S.';
    case {'mmp.x.Sparse','mmp.n.Sparse'}
        X = inv(S);
    otherwise
        error('mmp:inv','Unknown input parameter type');
end
% if isa(S,'p.sparse')
% %if isfield(S,'xpsp')%if sparse...
%     X.Xpsp=~S.Xpsp;%Flip convention
%     X.Reg = -S.Reg';%conjugate finite non-tops
%     X.Unitp = S.Unitp';%transpose (and invert) units
%     X.Topp  = S.Topp';%transpose (and change encoding) for tops
% else%full
%     X=-S';%Simply conjugate matrix.
% end
return
