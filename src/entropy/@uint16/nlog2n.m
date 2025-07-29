function h = nlog2n(n)
% function h = nlogn2(k) returns h = k * log2(k) when k is an positive
% number or zero.

%error(nargchk(1, 1, nargin));
n = double(n)
if (n==0) 
    h = double(n); %double(-Inf);
else
    h = n * log2(double(n));
end
return