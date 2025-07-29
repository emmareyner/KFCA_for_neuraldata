function [m,n] = test_non_null(R)
% function [m,n] = test_non_null(R)
%
    error(nargchk(1,1,nargin));
    [m,n] = size(R);
    ((m*n) ~= 0) || error('Null-matrix!');
    %~isempty(R) || error('null-matrix');
    return
