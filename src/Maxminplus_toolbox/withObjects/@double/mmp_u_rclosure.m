function rclos = mmp_u_rclosure(r)
%maxminplus uper reflexive closure for a double full or sparse matrix.

%TODO: use diag to do the job.
siz=size(r);
m = min(siz);
i = sub2ind(siz,1:m,1:m);%linear index for diagonal
rclos=r;
rclos(i)=min(rclos(i),0.0);%on sparse, this erases the elmt. in the diagonal
return%rclos
