function X=ctranspose(S)
% Sconj = ctranspose(S) Return the Cuninghame-Green conjugate [Sconj] for a
% matrix [S]. Works for any type of convention for [S].
%
% ctranpose(S) == opposite(transpose(S)) == xnp_transpose(xnp_inv(S))
%
% See also: xnp_inv, xnp_transpose.

% original coding: FVA 24/02/2009

error(nargchk(1,1,nargin));

if isa(S,'p.sparse')
%if isfield(S,'xpsp')%if sparse...
    X.Xpsp=~S.Xpsp;%Flip convention
    X.Reg = -S.Reg';%conjugate finite non-tops
    X.Unitp = S.Unitp';%transpose (and invert) units
    X.Topp  = S.Topp';%transpose (and change encoding) for tops
else%full
    X=-S';%Simply conjugate matrix.
end
return
