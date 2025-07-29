function [Z]=ones(X,Y,varargin);
%     mmp.u.ones(N) is an N-by-N matrix of mmp.u.one.
%  
%     mmp.u.ones(M,N) or ONES([M,N]) is an M-by-N matrix of mmp.u.ones.
%  
%     ONES([M N P ...]) is an M-by-N-by-P-by-... array of
%     mmp.u.ones.
%  
%     mmp.u.ones(SIZE(A)) is the same size as A and all ones.
%  
%     mmp.u.ones with no arguments is the scalar 1.
%  
%     Note: The size inputs M, N, and P... should be nonnegative integers. 
%     Negative integers are treated as 0.
%  
%     See also mmp.u.eye, mmp.u.zeros, xp_ones, xp_eye, xp_zeros

switch nargin 
    case 0
        Z = 0;
    case 1
        Z = zeros(X);
    case 2
        Z = zeros(X,Y);
    otherwise
        Z = zeros(X,Y,varargin);
end
return
