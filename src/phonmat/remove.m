function xx = remove (xxy, y)

% REMOVE removes first occurrence an element from a string or vector
%	 xx = remove (xxy, y)
%
%	If xxy is a string, y must also be one
%	If xxy is a numeric vector, y must be a number
%	If xxy is a cell vector, y can be anything that can be 
%	  compared to its elements with == or strcmp
%

z = findinvec (xxy, y);
xx = empty (xxy);
if z
  for i = 1 : length (xxy)
    if i ~= z
      xx = append (xx, elem (xxy, i) );
    end;
  end;
else
  xx = xxy;
end;
	 