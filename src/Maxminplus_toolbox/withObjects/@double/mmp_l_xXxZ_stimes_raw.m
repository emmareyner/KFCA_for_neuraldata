function Z = mmp_l_xXxZ_stimes_raw(s,X)
% lower maxplus scalar product for MXPLUS encoded matrices.
%
% function Z = mmp_l_xXxZ_stimes_raw(s,X)
%
% -s is double[1x1]
% -X is MXPLUS sparse [m x n]
% - Z is MXPLUS sparse [m x n]
%
% CAVEAT: this is a RAW primitive: no dimension or type checking is done. 
% author: fva 09/09

switch(s)
    case 0.0
        Z = X;
    case -Inf%Everything goes to lBottom
        Z = sparse(size(X));
    case Inf%All finite elements go to lTop, but lBottoms stay what they are.
        Z=spfun(@(x) Inf, X);%Saturate finite elements
    otherwise%s is finite, non-zero
        Z = spfun(@(x) x+s,X);%add to finite elements
        Z(X == eps) = s;%post detect original zeros
        Z(X == -s) = eps;%account for zeros
end
return%Z
