function [Z]=mmp_u_zeros(X,Y)
%MPM_ZEROS min-plus algebraic zeros array
%
%   MPM_ZEROS returns min-plus zero (Inf).
%   MPM_ZEROS(X) or MPM_ZEROS([X]) is an X-by-X matrix of min-plus zeros
%   MPM_ZEROS(X,Y) or MPM_ZEROS([X,Y]) 
%       is an X-by-Y matrix of min-plus zeros
%
%   See also 
%   MPM_ZERO, MPM_ONE, MPM_ONES, MPM_EYE
%
%   Max-Plus Algebra Toolbox, ver. 1.5 27-Apr-2005
%   Copyright (C) J.Stanczyk 2003-2005

error(nargchk(0,2,nargin));
switch nargin 
case 0
    Z = inf;
case 1
    Z = ones(X) * inf;
case 2
    Z = ones(X,Y) * inf;
end

% end of file 
