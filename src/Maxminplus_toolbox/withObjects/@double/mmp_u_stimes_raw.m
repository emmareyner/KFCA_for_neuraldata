function Z = mmp_u_stimes_raw(s,X)
% upper maxplus scalar multiplication
%
% function Z = mmp_u_stimes_raw(s,X)
%
% -s is double[1x1]
% -X is full or sparse double[m x n]
% - Z is double full, essentially.
%
% CAVEAT: this is a RAW primitive: no dimension or type checking is done. 
% author: fva 09/09

switch(s)
    case 0.0
        Z = X;
    case Inf%Everything goes to bottom
        Z = Inf(size(X));
    case -Inf%All finite elements go to uTop, but lBottoms stay what they are.
        Z=X;
        Z(isfinite(Z))=-Inf;
    otherwise
        Z = X + s;
end
return%Z
