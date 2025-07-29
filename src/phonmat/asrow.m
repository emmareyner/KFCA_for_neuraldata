function z = asrow (y)

% ASROW converts a column (or row) cell/numeric vector to a row one.
%        z = asrow (y)

if iscell(y) | isnumeric(y)
  z = reshape (y, 1, length(y));
else
  z = y;
end;