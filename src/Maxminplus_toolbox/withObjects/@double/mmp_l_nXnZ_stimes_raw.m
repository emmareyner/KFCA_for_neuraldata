function Z = mmp_l_nXnZ_stimes_raw(s,X)
% lower maxplus scalar product for MNPLUS encoded matrices.
%
% function Z = mmp_l_nXnZ_stimes_raw(s,X)
%
% -s is double[1x1]
% -X is MNPLUS sparse [m x n]
% - Z is MNPLUS sparse [m x n]
%
% CAVEAT: this is a RAW primitive: no dimension or type checking is done. 
% author: fva 09/09

switch(s)
    case 0.0
        Z = X;
    case -Inf%Everything goes to lBottom
        Z = sparse(-Inf(size(X)));
    case Inf%All finite elements go to lTop, but lBottoms stay what they are.
        [m,n]=size(X);
        Z = sparse(m,n);
        Z(isinf(X))=-Inf;%Since there are no Infs in X.
    otherwise%s is finite, non-zero
        Z = spfun(@(x) x+s,X);%add to non-bottom elements
        Z(X == eps) = s;%post detect original zeros
        Z(X == -s) = eps;%account for zeros
end
return%Z
