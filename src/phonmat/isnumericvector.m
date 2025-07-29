function M = isnumericvector (x,N)
% ISNUMERICVECTOR is a boolean test of whether x is a numeric vector, possibly of a specified size
%        M = isnumericvector (x,[N])
%
%	 If N is supplied, then 
%	    M = N if x is a 1xN or Nx1 numeric vector 
%	    M = 0 otherwise
%	 If N is not supplied, then
%	    M > 0 if x is a 1xM or Mx1 numeric vector
%	    M = 0 otherwise

if nargin < 1 | nargin > 2, error ('wrong number of arguments'); end;

yes = isnumeric(x);		            % check if x is numeric
if yes, yes = 2 == length(size(x)); end;    % check if x is a 1d or 2d vector
if yes, yes = 1 == min (size(x)); end;	    % check if x is a 1d vector
if yes                                      % ok, x is a 1dimensional numeric vector
   if nargin == 1
      M = length(x);
   else
      M = N * (length(x) == N);
   end;
else
   M = 0;
end;
