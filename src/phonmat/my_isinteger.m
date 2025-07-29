function yes = isinteger (x)
% ISINTEGER True for integer arrays (or numbers - rem that numbers are 1x1 arrays). Same as ISINTEGRAL.
%
%        isinteger (x) returns true if array x is numeric and all its members are integers.
%	 If x is an empty array, true is returned.
%        Not particularly efficient...

yes = isnumeric(x);
if yes & ~isempty(x) 
  yes = rem ( x(1),1 ) == 0;                   % check the first element of x, in case x is a huge matrix, this saves some time. 
  if yes 
    yes = fullmin ( rem (x,1) == 0);        % pretty inefficient !
  end;
end;

