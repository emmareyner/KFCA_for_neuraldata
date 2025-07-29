function Z = stimes(s,X)
% lower scalar multiplication of matrices and vectors
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
        error('mmp:l:stimes','unknown first input parameter type %ss', class(s))
end

% Consider all possible kinds of input
if s == 0.0
    Z = X;
elseif s == -Inf%Everything goes to bottom, MXPLUS encoding!
    Z = mmp.x.Sparse.zeros(size(X));
else%for other types of inputs...
    switch class(X)
        case 'double'
            Z = mmp_l_stimes_raw(s,X);
        case 'mmp.x.Sparse'
            Z = mmp.x.Sparse(mmp_l_xXxZ_stimes_raw(s,X.Reg));
        case 'mmp.n.Sparse'
            Z = mmp.n.Sparse(mmp_l_nXnZ_stimes_raw(s,X.Reg));
        otherwise
            error('mmp:l:stimes','unknown second input parameter type %ss', class(X))
    end
end
return%Z
