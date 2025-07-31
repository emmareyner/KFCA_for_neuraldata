function n = numdim (M)

% NUMDIM returns the number of dimensions of a matrix
%        n = numdim (M)
%
%	 M is a n-dimensional matrix or cell array of any type. 
%	 n is returned.
%
%        Trailing dimensions of 1 are not considered, which may or 
%	 may not be what you want. If you want all dimensions, use
%	 length(size(M)). 
%	 
%        For example, if M is a 3x3x1x1 array, n = 2.
%		      if M is a 3x1 array  or a single number, n = 1.
%
%        if M is an empty matrix, 0 is returned.

lens = size (M);

if ~min(lens)
  n = 0;
  return;
end;

n = length (lens);

while n > 1 & 1 == lens(n)
  lens = lens(1:n-1);
  n = n - 1;
end;

