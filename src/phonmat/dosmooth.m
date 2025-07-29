function [y] = dosmooth (x,M)

% x is 1 x N vector, y is its smoothed version
% M is a parameter for smoothing - large M means more smoothing


y = x;
if ~M, return; end;
N = length(x);

for i = 1: M
  y(1:N-1) = (y(1:N-1) + y(2:N))/2;
  y(2:N) = (y(1:N-1) + y(2:N))/2;
end;
