function n = private_isgoodstring(x)
% PRIVATE_ISGOODSTRING is a private function of class confmat
% n = private_isgoodstring (x)
%
% n = length (x) if x is of type char string, else n = -1

if ischar(x)
  n = length(x);
else 
  n = -1;
end;