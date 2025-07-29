function [Y] = diag(varargin)
% mmp.l.diag Maxplus diagonal matrices and diagonals of a matrix.mmp.u.diag
% Building favors using sparse representation while extraction uses a full
% representation for results.
%
%     mmp.l.diag(V,K) when V is a vector with N components is a square matrix
%     of order N+ABS(K) with the elements of V on the K-th diagonal. K = 0
%     is the main diagonal, K > 0 is above the main diagonal and K < 0
%     is below the main diagonal. The result is maxplus sparse.
%  
%     mmp.l.diag(V) is the same as np_diag(V,0) and puts V on the main diagonal.
%  
%     mmp.l.diag(X,K) when X is a matrix is a full column vector formed from
%     the elements of the K-th diagonal of X.
%  
%     mmp.l.diag(X) is the main diagonal of X. mmp.l.diag(p.l.diag(X)) is a
%     maxplus diagonal matrix (elements off the diagonal are -Inf). 
  
%%Author: fva, 25/02/09
Y = mmp.x.Sparse.diag(varargin{:});
return%Y

