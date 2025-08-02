function x = spaces (n)

% SPACES returns a string of n spaces
%
%	x = spaces (n)

if n < 0 || ~isa(n,'double')
    error ('input must be a nonnegative integer');
else
    n=uint16(n);
end;
x = repmat (' ', 1, n);
return
