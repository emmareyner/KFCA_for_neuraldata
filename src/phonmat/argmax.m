function [first,all] = argmax (z,oneof)

% ARGMAX 
%	 [first,all] = argmax (z,oneof)
%
%	 z is a Nx1 numeric vector. 
%	 oneof, an optional argument, is a subset of [1:N]. 
%	   If not supplied it is assumed to equal [1:N], i.e. x is the highest value in all of z.
%	 all is the subset of oneof of all x such that z(x) >= z(y) for every y in oneof.
%	 first = all(1)

N = isnumericvector(z);
if ~N, error ('first argument must be a numeric vector'); end;
if nargin < 2, oneof = [1 : N]; end;

maxx = max (z(oneof));
all = [];
for i = oneof
    if z(i) == maxx, 
       all = append (all, i);
    end;
end;
first = all(1);
