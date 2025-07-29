function z = private_removecomment (x)
% PRIVATE_REMOVECOMMENT is a private function of class confmat
% x is a line that may begin with a %, followed by some spaces (maybe)
% z is x with the % and any initial spaces removed.
% if x has no %, z = x.

if ~ischar(x), 
   error (sprintf ('%s should be of type char', x));
end;
z = x;
percentsignfound = findstr (x, '%');
if length (percentsignfound) > 0
  start = percentsignfound(1) + 1;              % start of valid (ie to be returned) part of x
  for i = percentsignfound(1) + 1 : length (x)
    if x(i) == ' ', 
      start = start + 1; 
    else
      break;
    end;
  end;
  if start > length(x)
    z = '';
  else
    z = x (start : length(x));
  end;
end;

