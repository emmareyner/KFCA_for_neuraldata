function [Y] = diag(vec,offset)
% mmp.x.Sparse.diag Maxplus diagonal matrices and diagonals of a matrix.
% Building favors using sparse representation while extraction uses a full
% representation for results.
%
%     mmp.x.Sparse.diag(V,K) when V is a vector with N components is a square matrix
%     of order N+ABS(K) with the elements of V on the K-th diagonal. K = 0
%     is the main diagonal, K > 0 is above the main diagonal and K < 0
%     is below the main diagonal. The result is maxplus sparse.
%  
%     mmp.x.Sparse.diag(V) is the same as np_diag(V,0) and puts V on the main diagonal.
%  
%     mmp.l.diag(X,K) when X is a matrix is a full column vector formed from
%     the elements of the K-th diagonal of X.
%  
%     mmp.x.Sparse.diag(X) is the main diagonal of X.  
%
% See also mmp.l.diag, mmp.u.diag, mmp.n.Sparse.diag
  
%%Author: fva, 25/02/09
 
% Validate and preprocess args
switch nargin
    case 1
        offset=0;
    case 2%Do nothing
        if ~isscalar(offset)
            error('mmp:x:Sparse:diag','non-scalar diagonal selection parameter');
        end
    otherwise%at least two arguments.
        error(nargchk(1,2,nargin));
end

% dispatch
Y= mmp.x.Sparse();
switch class(vec)
    case 'double'
        %Y = mmp_l_diag(vec,offset);
        Y.Reg = mmp_l_spdiag(vec,offset);
    case 'mmp.x.Sparse'
        Y.Reg = mmp_l_spdiag(vec.Reg,offset);
    otherwise
        error('mmp:x:Sparse:diag','wrong input class type');
end
return%Y

