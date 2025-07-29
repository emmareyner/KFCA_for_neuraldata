function z = append (x,y)

% APPEND adds element to end of string or vector 
%	 z = append (x,y)
% 
%	This is an allpurpose concatenation operator. 
%       y is placed AFTER x.
%	Often used in a context where z = x.
%	Possible (x,y,z) triples here are:
%
%	'trwoh'		'x'	     'trwohx'
%	'trwd'		'xxa'	     'trwdxxa'
%	[42 15 43]	3	     [42 15 43 3]
%	[43 51]		[3 1]	     [43 51 3 1]
%	{'ferw', 'frw'}	'ae'	     {'ferw', frw','ae'}
%	{'ferw', 'frw'}  {4,'req'}    {'ferw', frw',4,'req'}
%
%       If the first argument is a cell array and the second argument 
%       is also a cell, but you want to add it as an entity by itself, 
%       eg you want {'ferw', 'frw', {4,'req'}} in the last case, you 
%       should not use this function.

z = x;

if iscell (x)
  if iscell (y)                    % ambiguity here
    for i = 1 : length (y)
      z {1 + length(z)} = y{i};
    end;
  else
    z {1 + length(z)} = y;
  end;

elseif ischar(x)
  if ischar(y)
     z = charcat (x,y);
  else
     error ('first argument is char, so should second argument be')
  end;

elseif isnumeric (x)
  if isnumeric (y)
    for i = 1 : length (y)
      z (1 + length(z)) = y(i);
    end;
  else
     error ('first argument is numeric, so should second argument be')
  end;

else
  error ('argument types not supported');
end;
