function z = elem (x,k,default)

% z = x{k} or x(k) dependeing on if x is type cell or not.
% If length(x) > k then it returns default.
% if k isnt supplied it returns the first element.

if nargin < 2, k = 1; end;
if nargin < 3, default = -Inf; end;

if length(x) >= k
  if iscell (x)
     z = x{k};
  elseif isnumeric (x) | ischar (x)
     z = x(k);
  end;
else 
  z = default;
end;
 
