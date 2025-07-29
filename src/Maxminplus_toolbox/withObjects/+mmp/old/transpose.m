function X=transpose(S)
% Strans = xnp_transpose(S) Return the transpose [Strans] for a
% matrix [S]. Works for any type of convention for [S].
%
% xnp_trans(S) == xnp_inv(xnp_conj(S) == xnp_conj(xnp_inv(S))
%
% See also: xnp_inv, xnp_conj.

% original coding: FVA 24/02/2009

error(nargchk(1,1,nargin));

if isa(S,'p.sparse')
%if isfield(S,'xpsp')%if sparse...
    X.Xpsp =S.Xpsp;%Keep convention
    X.Reg = S.Reg';%transpose finite non units
    X.Unitp = S.Unitp';%transpose unit pattern
    X.Topp  = S.Topp';%transpose top pattern
else%full...
    X=S';%Simply transpose matrix.
end
return
