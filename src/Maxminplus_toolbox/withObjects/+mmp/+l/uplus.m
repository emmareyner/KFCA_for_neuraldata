function Rplus = uplus(R)
% function Rplus = uplus(R) aka +R
%
% Returns the metric matrix of the square matrix provided as input
% parameter when R is definite (Cuninghame-Green, 1979, Butkovic, 2006).
%
% Otherwise it returns the max-plus equivalent of a "transitive
% closure".
%
% Caveat! This only works for definite matrices!
%
% See also mp_star
error(nargchk(1,1,nargin));

[m n]=size(R);
if m~=n,
    error('mmp:l:uplus','Non-square argument');
end

switch n
    case 1%early termination
        if (R(1,1) > 0.0)
            Rplus = Inf;
        else
            Rplus = R;%R otimes Rstar
        end
    otherwise%R+=R(I+R)^(n-1), recipe by Cunninghame-Green
        Rplus = mmp.l.mtimes(R,mmp.l.mpower(mmp.l.rclosure(R),n-1));
end
return


