function X=mmp_n_full(S) 
%mmp_u_full Create min-plus full matrix from a min-plus sparse matrix.
%   X = mmp_l_full(S) converts a MNPE matrix to full form.

%%%%%%
X=mmp_u_zeros(size(S));%Full matrix for output
nz = (S ~= 0);
X(nz)=S(nz);%replace nonzero elements
%X(abs(S)<=eps(2))=0;%change -eps to 0.0
X(nz & abs(S) <= eps(2))=0.0;
return
