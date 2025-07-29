function c = countelem (x)

% x is a cell array of cell arrays of... something that's not a cell array. 
% In other words, x is like a tree, in which case c = number of leaves of x.

c = 0;
if strcmp (class(x),'cell')
  for i = 1 : length(x)
    c = c + countelem (x{i});
  end;
else
  c = length(x);
end;