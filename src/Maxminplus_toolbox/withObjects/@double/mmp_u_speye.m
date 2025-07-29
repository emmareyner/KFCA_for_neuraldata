function E = mmp_u_speye(M,N)
% mmp_u_speye  upper Sparse maxplus identity matrix.
%     mmp_u_speye(M,N) forms an M-by-N sparse maxplus matrix with 00 on
%     the main diagonal.  mmp_u_speye(N) abbreviates mmp_u_speye(N,N).
%  
%     mmp_u_speye(SIZE(A)) is a space-saving SPARSEMP(mmp_u_eye(SIZE(A))).
%  
% 
% FVA: 23/07/09

% check input values
error(nargchk(1,2,nargin));

if nargin==1, N=M;end
E=speye(M,N)*(-eps);
return
