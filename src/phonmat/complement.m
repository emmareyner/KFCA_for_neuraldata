function z = complement (x,N,hasdups)

% x is a subset of [1:N]. It is assumed to have no duplicates by default.
% z is [1:N] with x removed.

if ~length(x), z=[1:N];return; end;
if nargin<3, hasdups=0;end;
if hasdups,x=removeduplicates(x);end;
x=sort(x);
z = [1:x(1)-1];

for i=2:length(x),
 z = append (z,[x(i-1)+1:x(i)-1]);
end;
z = append (z,[lastelem(x)+1:N]);

