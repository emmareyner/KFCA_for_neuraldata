function [Y] = mmp_u_spdiag(vec,offset)
% mmp_u_spdiag maxplus upper diagonal sparse matrices and diagonals of a matrix.
% Tries to follow the conventions of diag (q.v.)
%
% FVA, 06/07/2010, imported from mmp_u_spdiag.m

%     mmp_u_spdiag(V,K) when V is a vector with N components is a square matrix
%     of order N+ABS(K) with the elements of V on the K-th diagonal. K = 0
%     is the main diagonal, K > 0 is above the main diagonal and K < 0
%     is below the main diagonal. The result is min-plus sparse.
%  
%     mmp_u_spdiag(V) is the same as mmp_u_spdiag(V,0) and puts V on the main diagonal.
%  
%     mmp_u_spdiag(X,K) when X is a matrix is a column vector formed from
%     the elements of the K-th diagonal of X, inheriting the sparse of full
%     status from the parent matrix.
%  
%     mmp_u_spdiag(X) is the main diagonal of X. mmp_u_spdiag(mmp_u_spdiag(X)) is a
%     diagonal min-plus sparse matrix. 
  
%%Author: fva, 25/02/09, 06/07/2010
 
%% Validate and preprocess args
switch nargin
    case 1
        offset=0;
    case 2%Do nothing
        if ~isscalar(offset),
            error('double:mmp_u_spdiag','Non-scalar diagonal selection parameter');
        end
    otherwise%at least two arguments.
       error(nargchk(1,2,nargin));
end


% dispatch on vec size
siz=size(vec);
if any(siz==1)%it IS a vector: return a diagonal matrix built out of it
    %find the index on the diagonal elements in the matrix.
    nm=max(siz);
    co=(1:nm).';
    dim=nm+abs(offset);
    if ~issparse(vec)
        vec = mmp_x_sparse(vec);
    end
    if offset >= 0
        Y=sparse(co,co+offset,vec,dim,dim);
    else
        Y=sparse(co,co+abs(offset),co,vec,dim,dim);
    end

else%Consider case where extraction occurs, i.e. vec is not a vector
    if issparse(vec)
        Y = mmp_n_full(diag(vec,offset));
    else
        Y = diag(vec,offset);%return lower diag, but full!
    end
end
return%Y
