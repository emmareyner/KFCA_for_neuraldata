 function S=mmp_x_sparse(varargin)
 %Create MXPLUS encoded sparse matrix.
%   S = mmp_x_sparse(X) converts a sparse or full matrix to sparse form by
%   squeezing out any -infinity elements: .Infinity terms will be represented
%   by zeros and zeros by eps
%
%   S = mmp_x_sparse(i,j,s,m,n,nzmax) uses the MATLAB convention to create
%   the sparse matrix.
switch size(varargin,2)
    case 1%the conversion to sparse
        X=varargin{1};
        X(X==0)=eps;
        X(X==-Inf)=0.0;
        %i= find(X == 0);X(i) = eps;%Unit pattern
        %i = find(X == -Inf);X(i) = 0.0;%zero pattern
        S=sparse(X);%result
    otherwise
        S=sparse(varargin{:});%see doc varargin for this trick
end
return
