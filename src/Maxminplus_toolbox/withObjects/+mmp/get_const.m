function [zero,one,top]=get_const(X)
%function [zero,one,top]=get_const(X)
% Obtains the constants in the encoding carried by X. Encodings considered
% are: full, p.x.sparse and p.n.sparse
error(nargchk(1,1,nargin));

%TODO: consider sparse encodings!
one=0.0;
if isa(X,'p.n.sparse') 
        zero=Inf;
        top=-Inf;
else%if p.x.sparse or full, it follows maxplus convention
        zero=-Inf;
        top=Inf;
end
return
    
