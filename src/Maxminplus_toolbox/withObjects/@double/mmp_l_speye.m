function E = mmp_l_speye(M,N)
% mmp_l_speye  Sparse maxplus identity matrix.
%     mmp_l_speye(M,N) forms an M-by-N sparse maxplus matrix with 1's on
%     the main diagonal.  mmp_l_speye(N) abbreviates mmp_l_speye(N,N).
%  
%     mmp_l_speye(SIZE(A)) is a space-saving SPARSEMP(MP_EYE(SIZE(A))).
%  
% 
% FVA: 4/12/08

% check input values
error(nargchk(1,2,nargin));

if nargin==1, N=M;end
E=speye(M,N)*eps;
return
