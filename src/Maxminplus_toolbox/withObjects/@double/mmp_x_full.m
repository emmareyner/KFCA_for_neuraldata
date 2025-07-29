function X=mmp_x_full(S)
%FULLMP Create max-plus full matrix from a max-plus sparse matrix.
%   X = mmp_x_full(S) converts a MXPE matrix to full form.

X=mmp_l_zeros(size(S));%transform all 0 to -Inf
nz = (S ~= 0);
X(nz)=S(nz);%proportional to nnz(S)
%iseps= X==eps;X(iseps)=0;
%X(abs(S)<=eps(2))=0.0;%proportional to nnz(S)
X(nz & abs(S) <= eps(2))=0.0;
return
