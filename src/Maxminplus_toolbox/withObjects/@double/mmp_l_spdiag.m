function [Y] = mmp_l_spdiag(vec,offset)
% mmp_l_spdiag(vec,offset)  sparse Maxminplus diagonal matrices and diagonals of a matrix. Tries to
% follow the definition of diag (q.v.). If vec is sparse, it is already in
% mmp.x.Sparse format.

%% Validate and preprocess args
switch nargin
    case 1
        offset=0;
    case 2%Do nothing
        if ~isscalar(offset),
            error('double:mmp_l_spdiag','Non-scalar diagonal selection parameter');
        end
    otherwise%at least two arguments.
        error(nargchk(1,2,nargin));
end

% dispatch on vec size
siz=size(vec);
if any(siz==1)%it IS a vector: return a diagonal matrix built out of it
    %find the index on the diagonal elements in the matrix.
    nm=max(siz);
    co=(1:nm)';
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
        Y = mmp_x_full(diag(vec,offset));
    else
        Y = diag(vec,offset);%return lower diag, but full!
    end
end
return%Y
