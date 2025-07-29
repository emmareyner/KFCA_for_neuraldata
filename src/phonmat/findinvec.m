function [z,ALL] = findinvec (A,x)

% [z,ALL] = findinvec(A,x)
% A is nx1 numeric/cell vector or a string
% x is the number/char (single number or multiple-char-in-single-string)
%   you want to find in A.
% z is smallest index such that A(z) = x, z = 0 if x not in A
% ALL has the list of all such integers

if ischar (A)
  if ischar (x)
    ALL = findstr (A,x);
  else
    error ('first argument is char, so second should be char too');
  end;
elseif iscell (A) | isnumeric (A)
  ALL = [];
  for i = 1 : length(A)
   elemhere = elem (A,i);
   if cmp (elemhere, x)
     ALL = append (ALL,i); 
   end;
  end;
else
  error ('arguments not supported');
end;

if length(ALL)
  z = ALL(1);
else 
  z = 0;
end;
