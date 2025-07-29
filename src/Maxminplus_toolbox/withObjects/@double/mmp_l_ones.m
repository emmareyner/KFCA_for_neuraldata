function [Z]=mp_ones(X,Y);
%MP_ONES max-plus algebraic ones array
%
%   MP_ONES returns m-p unit (0).
%   MP_ONES(X) or MP_ONES([X]) is an X-by-X matrix of m-p ones (0's).
%   MP_ONES(X,Y) or MP_ONES([X,Y]) is an X-by-Y matrix of m-p ones.
%   MP_ONES(SIZE(A)) is the same size as A and all m-p ones.
%
%   See also 
%   MP_ONE, MP_EYE, MP_ZERO, MP_ZEROS
%
%   Max-Plus Algebra Toolbox, ver. 1.5 27-Apr-2005
%   Copyright (C) J.Stanczyk 2003-2005

error(nargchk(0,2,nargin));

switch nargin 
case 0
    Z = 0;
case 1
    Z = zeros(X);
case 2
    Z = zeros(X,Y);
end

% end of file 
