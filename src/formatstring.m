function z = formatstring (x,len,dp)
% FORMATSTRING converts a number/string to a string of given length. Useful in formatting tables.
% z = formatstring (x,len,[dp])
% x is a number (including NaN) or a char string
% z is a string len characters long representing x
%
% The optional argument dp only need be provided if x is a non-integer number.
%  Then it sets the number of decimal places you want x to be. The default is 4.
% If x is NaN, a string with len spaces is returned

if isa(len,'double')
    len = uint16(len);
elseif ~isa(len,'uint16')
%if length(len) ~= 1 || ~isa(len,'double')
   error ('second argument of FORMATSTRING should be a single integer');
end;

origx = x;
if isnumeric (x), 
  if isnan(x)
    z = repmat (' ',1,len);
    return;
  elseif isinteger (x) & (nargin < 3 | dp == 0)
    x = num2str(x); 
  else
    if nargin < 3, dp = 4; end;        % numeric, but not integer.
    x = num2str (x,strcat('%0.',num2str(dp),'f')); 
  end;
elseif ~ischar (x)
  error ('first argument of FORMATSTRING should be a string or number'); 
end;


if length(x) >= len & ~isnumeric (origx)
  z = x(1:len);
else
  z = x;
  for i = 1 : len - length(x)
    z(length(z)+1) = ' ';
  end;
end;


