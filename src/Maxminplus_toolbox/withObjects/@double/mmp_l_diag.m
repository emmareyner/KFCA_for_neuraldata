function [Y] = mmp_l_diag(vec,offset)
% mmp_l_diag Maxplus diagonal matrices and diagonals of a matrix. Tries to
% follow the definition of diag (q.v.)

%% Validate and preprocess args
switch nargin
    case 1
        offset=0;
    case 2
        if ~isscalar(offset),
            error('Double:mmp_l_diag','Non-scalar diagonal selection parameter');
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
    Y =-Inf(dim);%Square matrix all Infs
    Y(idx)=vec;


%2 Extraction primitives: create a vector with the idx
else%Consider case where extraction occurs, i.e. vec is not a vector
    Y = diag(vec,offset);%return lower diag, but full!
end
return%Y
