function yes = isintegral (x)

% ISINTEGRAL True for integer arrays (or numbers - rem that numbers are 1x1 arrays). Same as ISINTEGER.
%
%        isintegral (x) returns true if array x is numeric and all its members are integers.
%	 If x is an empty array, true is returned.
%        Not particularly efficient...


yes = isinteger(x);