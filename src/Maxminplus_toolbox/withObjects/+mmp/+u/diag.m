function [Y] = diag(varargin)
% mmp.u.diag min-plus diagonal matrices and diagonals of a matrix. Tries to
% follow the diag convention. mmp.u.diag tries to keep the base type of
% vec.
%
%     mmp.u.diag(V,K) when V is a vector with N components is a square matrix
%     of order N+ABS(K) with the elements of V on the K-th diagonal. K = 0
%     is the main diagonal, K > 0 is above the main diagonal and K < 0
%     is below the main diagonal. The result is min-plus sparse.
%  
%     mmp.u.diag(V) is the same as mmp.u.diag(V,0) and puts V on the main diagonal.
%  
%     mmp.u.diag(X,K) when X is a matrix is a column vector formed from
%     the elements of the K-th diagonal of X, inheriting the sparse of full
%     status from the parent matrix.
%  
%     mmp.u.diag(X) is the main diagonal of X. mmp.u.diag(mmp.u.diag(X)) is a
%     diagonal min-plus sparse matrix. 
  
%%Author: fva, 25/02/09
Y = mmp.n.Sparse.diag(varargin{:});
return%Y

