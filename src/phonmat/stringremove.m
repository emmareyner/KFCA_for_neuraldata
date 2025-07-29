function xnew = stringremove (xold,y,eachchar)

% STRINGREMOVE removes characters from string
%       xnew = stringremove (xold,y,eachchar)
%
%	xold, xnew and y are strings. 
%       If eachchar = 1 (default) then xnew is xold without
%         any character in y.
%       If eachchar = 0 then xnew is xold without y, where
%	  y is seen to be a whole string.
%
%	Examples: 
%	  stringremove ('blahblahhalb','bl')   returns 'ahahha'
%	  stringremove ('blahblahhalb','bl',1) returns 'ahahha'
%	  stringremove ('blahblahhalb','bl',0) returns 'ahahhalb'

CHAR = 1;
if nargin >= 3
  if  isnumeric (eachchar) | islogical (eachchar)
    CHAR = eachchar;
  end;
end;

if ~ischar (xold) | ~ischar (y)
  error ('first two arguments should be strings');
end;


xnew = xold;
if CHAR
  for i = 1 : length (y)
    xnew = xnew (xnew ~= y(i));
  end;
else
  foundy = 1;
  while foundy
    foundy = findinvec (xnew, y);
    if foundy
      xnew = charcat (xnew(1:foundy-1), xnew(foundy+length(y):length(xnew)) );
    end;
  end;
end;

