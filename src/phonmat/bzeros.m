function A = bzeros (x1,varargin)
% just like zeros, but produces n-dimensional  array of uint8's insead
% of double's.

s= length(varargin);
if s == 0
  A = repmat (boolean(0),x1,1);
elseif s == 1
  A = repmat (boolean(0),x1,varargin{1});
else
  B = bzeros(x1,varargin{1:s-1});
  n = length(size(B));
  A = repmat (B,[ones(1,n) varargin{s}]);
end;

