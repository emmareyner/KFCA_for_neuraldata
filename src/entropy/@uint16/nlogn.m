function h = nlog2n(n)
% function h = nlogn(k) returns h = k * log2(k) when k is an integer!
% Memoize this function and then used the memoized version as in
% nlognM = memoize(@nlogn) 
% ...
% nlognM(5)

%error(nargchk(1, 1, nargin));
%persistent store

store = sparse(1,10000);

if (n==0) 
    h = double(-Inf);
else
    h = nlog2n1(n);%this is the memoized version 
end

nlog2n1M = memoize(nlog21);