function Z=opposite(X)
% Sconj = opposite(S) Return the transpose of the conjugate transpose .
% Works for any type of convention for [S]. 
%
% p.opposite(S) == p.ctranspose(p.transpose(S) == p.transpose(p.opposite(S))
%
% See also: p.ctranspose, p.transpose

% original coding: FVA 24/02/2009

%error(nargchk(1,1,nargin));

%if isa(X,'p.sparse')
    Z.Xpsp=~X.Xpsp;%Flip convention
    Z.Reg=-X.Reg;%invert finite non units.
    %!!! rest of fields remain the same!
    Z.Unitp=X.Unitp;
    Z.Topp =X.Topp;
else%full or sparse!!
    Z=-X;%Simply plus-invert matrix.
end
return
