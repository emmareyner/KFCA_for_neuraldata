function Z=inv(X)
% Sconj = xnp_inv(S) Return the plus inverse [Sinv] for a
% matrix [S]. Works for any type of convention for [S].
%
% xnp_inv(S) == xnp_conj(xnp_transpose(S) == xnp_transpose(xnp_conj(S))
%
% See also: xnp_conj, xnp_transpose

% original coding: FVA 24/02/2009

error(nargchk(1,1,nargin));

if isa(X,'p.sparse')
%if isfield(S,'xpsp')%if sparse...
    Z.Xpsp=~X.Xpsp;%Flip convention
    Z.Reg=-X.Reg;%invert finite non units.
    %!!! rest of fields remain the same!
    Z.Unitp=X.Unitp;
    Z.topp =X.Topp;
else%full or sparse!!
    Z=-X;%Simply plus-invert matrix.
end
return
