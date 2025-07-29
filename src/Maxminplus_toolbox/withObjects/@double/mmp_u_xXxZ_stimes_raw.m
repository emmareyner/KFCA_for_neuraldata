function Z = mmp_u_xXxZ_stimes_raw(s,X)
% upper maxplus scalar product for MXPLUS encoded matrices.
%
% function Z = mmp_u_xXxZ_stimes_raw(s,X)
%
% -s is double[1x1]
% -X is MXPLUS sparse [m x n]
% -Z is MXPLUS sparse [m x n]
%
% CAVEAT: this is a RAW primitive: no dimension or type checking is done. 
% author: fva 09/09

switch(s)
    case 0.0
        Z = X;
    case Inf
        %Z=spfun(@(x) Inf, X);%Saturate finite elements
        Z = sparse(Inf(size(X)));%Everything is saturated, but sparse
    case -Inf%All finite elements go to lTop, but lBottoms stay what they are.
        %Z = sparse(size(X));
        %Z = spfun(@(x) check(x), X);
        Z = spfun(@(x) x*0, X);%Smash all finite values. Infs go to NaN. -Infs shouldn't be there
        Z = spfun(@(z) Inf,Z);%Rebuild Infs, if any, from NaNs
    otherwise%s is finite, non-zero
        Z = spfun(@(x) x+s,X);%add to finite elements
        Z(X == eps) = s;%post detect original zeros
        Z(X == -s) = eps;%account for zeros
end
%     function s = check(x)
%     if x == Inf, s = Inf; else s = 0; end
%     end
end
