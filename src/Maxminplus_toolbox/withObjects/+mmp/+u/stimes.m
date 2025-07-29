function Z = stimes(s,X)
% function Z = mmp.u.stimes(s,X)
% upper scalar multiplication of matrices and vectors
% It is commutative.

%CAVEAT: This is a RAW implemnetation: no dim check.

%Implementation notes:
error(nargchk(nargin,2,2));

%Guarantee that s is double
switch(class(s))
    case 'double'%just do nothing
    case {'mmp.x.Sparse','mmp.n.Sparse'}
        s = double(s);
    otherwise
        error('mmp:u:stimes','unknown first input parameter type %ss', class(s))
end

% Consider all possible kinds of input
if s == 0.0%mmp.l.ones
    Z = X;
elseif s == Inf %mmp.u.zeros%Everything goes to bottom, MNPLUS encoding!
    Z = mmp.n.Sparse.zeros(size(X));
else%for other types of inputs...
    switch class(X)
        case 'double'
            Z = mmp_u_stimes_raw(s,X);
        case 'mmp.n.Sparse'
            %Z = mmp.n.Sparse(mmp_u_nXnZ_stimes_raw(s,X));
            Z = mmp.n.Sparse();
            Z.Reg = mmp_u_nXnZ_stimes_raw(s,X.Reg);
        case 'mmp.x.Sparse'
            Z= mmp.x.Sparse(mmp_u_xXxZ_stimes_raw(s,X.Reg));
        otherwise
            error('mmp:u:stimes','unknown second input parameter type %ss', class(X))
    end
end
return%Z
