function makesymmetric (pm, varargin)

% MAKESYMMETRIC sets the .symmetric field of a PHONMAT object
%
%	makesymmetric (pm, not)
% 
%	pm is a PHONMAT object. 
%	pm.symmetric is set to 1
%	if not is supplied (with any value), pm.symmetric is set to 0.

tmp = 0;
if (nargin==1)
     tmp = 1;
end
set (pm, 'symmetric', tmp);
assignin ('caller', inputname(1), pm);
