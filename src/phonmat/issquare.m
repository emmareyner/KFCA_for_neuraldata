function y = issquare(A)
% ISSQUARE boolean test of whether a given matrix is square
%          Does not check if matrix is also numeric.
%
%	   y = issquare (A)

y = length(size(A)) == 2 & size(A,1) == size(A,2);