function [z,ave,total,N] = fullsum(A)

% A is ND array. z is sum of all elements.
% Note that sum(A) gives a (N-1)dim array.
% Also returns average value of array. 
% If array has total elements, ave = z/total

N = length (size (A));
total = prod (size(A));
z = sum(A);
for n = 1 : N-1
  z = sum(z);
end;
if total
  ave = z/total;
else
  ave = 0;
end;
