function removediag (pm, varargin)

% REMOVEDIAG sets the .hasdiag field of a PHONMAT object
%
%	removediag (pm, dontremove)
%
%	pm is a PHONMAT object
%
%	pm.hasdiag = 1 if dontremove is supplied (with any value),
%       else 0

tmp=0;
if nargin>1
  tmp=1;
end

set (pm, 'hasdiag', tmp);
assignin ('caller', inputname(1), pm);
