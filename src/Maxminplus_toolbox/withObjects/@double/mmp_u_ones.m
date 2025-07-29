function [Z]=mpm_ones(X,Y);
%MPM_ONES min-plus algebraic ones array.
%
%   MPM_ONES returns min-plus unit (0).
%   MPM_ONES(X) or MPM_ONES([X]) is an X-by-X matrix of min-plus ones (0's).
%   MPM_ONES(X,Y) or MPM_ONES([X,Y]) is an X-by-Y matrix of min-plus ones.
%   MPM_ONES(SIZE(A)) is the same size as A and all min-plus ones.
%
%   See also 
%   MPM_ONE, MPM_ZERO, MPM_ZEROS, MPM_EYE
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
