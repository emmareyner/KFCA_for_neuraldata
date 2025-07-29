function [Z]=ones(X,Y,varargin)
%     mmp.l.ones(N) is an N-by-N matrix of 0.0
%  
%     mmp.l.ones(M,N) or mmp.l.ones([M,N]) is an M-by-N matrix of  0.0
%  
%     mmp.l.ones([M N P ...]) is an M-by-N-by-P-by-... array of
%     0.0
%  
%     mmp.l.ones(SIZE(A)) is the same size as A and all 0.0
%  
%     mmp.l.ones with no arguments is the scalar 0.0.
%  
%     Note: The size inputs M, N, and P... should be nonnegative integers. 
%     Negative integers are treated as 0.
%  
%     See also mmp.l.eye, mmp.l.zeros, np_ones, np_eye, np_zeros

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
