function z = empty (x)

% EMPTY returns empty string or vector
%        z = empty(x)
%
%	z = '' if x is a string, {} if cell and [] if numeric

if iscell (x)
   z = {};
elseif ischar (x)
   z = '';
elseif isnumeric (x)
   z = [];
else
  error ('type not supported');
end;