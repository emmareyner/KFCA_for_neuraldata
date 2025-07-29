function val= range (val, minn, maxx)
% val can be array
% ensures val is in [minn,maxx]
if nargin < 3, maxx = Inf;end;
%if nargin < 2, minn = -Inf;end;  % But if only 1 arg, why use? whatever...
val = max (val, minn);
val = min (val, maxx);