function [Y] = mmp_u_diag(vec,offset)
% mmp_u_diag min-plus diagonal matrices and diagonals of a matrix.
% Tries to follow the conventions of diag (q.v.)
%
% FVA, 06/07/2010, imported from mmp_u_diag.m

%     mmp_u_diag(V,K) when V is a vector with N components is a square matrix
%     of order N+ABS(K) with the elements of V on the K-th diagonal. K = 0
%     is the main diagonal, K > 0 is above the main diagonal and K < 0
%     is below the main diagonal. The result is min-plus sparse.
%  
%     mmp_u_diag(V) is the same as mmp_u_diag(V,0) and puts V on the main diagonal.
%  
%     mmp_u_diag(X,K) when X is a matrix is a column vector formed from
%     the elements of the K-th diagonal of X, inheriting the sparse of full
%     status from the parent matrix.
%  
%     mmp_u_diag(X) is the main diagonal of X. mmp_u_diag(mmp_u_diag(X)) is a
%     diagonal min-plus sparse matrix. 
  
%%Author: fva, 25/02/09, 06/07/2010
 
%% Validate and preprocess args
switch nargin
    case 1
        offset=0;
    case 2%Do nothing
        if ~isscalar(offset),
            error('double:mmp_u_diag','Non-scalar diagonal selection parameter');
        end
    otherwise%at least two arguments.
        error(nargchk(1,2,nargin));
end


% dispatch on vec size
siz=size(vec);
if any(siz==1)%it IS a vector: return a diagonal matrix built out of it
    %find the index on the diagonal elements in the matrix.
    nm=max(siz);
    co=1:nm;
    dim=nm+abs(offset);
    if offset >= 0%Build a linear index
        idx=sub2ind([dim dim],co,(co+offset));
    else
        idx=sub2ind([dim dim],co+abs(offset),co);
    end
    Y =Inf(dim);%Square matrix all Infs
    %Y = mmp.u.zeros(dim);%SPARSE square matrix all Infs
    Y(idx)=vec;

%2 Extraction primitives: create a vector with the idx
else%Consider case where extraction occurs, i.e. vec is not a vector
    Y = diag(vec,offset);%return lower diag, but full!
end
return%Y
