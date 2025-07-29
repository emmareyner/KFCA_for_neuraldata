function rclos = lrclosure(r)
% function rclos = mmp.n.sparse.lrclosure(r)
%
% For square minplus encoded matrices, it returns the lower reflexive
% closure of the matrix, i.e. mmp.l.plus(mmp.l.eye(n),r). For non-square,
% it tries to lower add a zero  to the diagonal of the matrix; this case
% can't be a closure.
%
% Tries to avoid carrying out a lot of maxplus additions. 
%
% fva, Apr-Jul 2008
siz=size(r);
m = min(siz);
i = sub2ind(siz,1:m,1:m);%linear index for diagonal
rclos=r;%create closure
%dReg=logical(r.Reg(i));%dUnit=r.Unitp(i);dTopp=r.Topp(i);
negregd=(r.Reg(i) < -eps);%regular diagonal negative els.
rclos.Reg(i(negregd))=0.0;%delete neg regulars on diagonal
%zd = ~(dReg|r.Unitp(i)|r.Topp(i));%zero diagonal elements;
rclos.Unitp(i(r.Topp(i)|negregd))=true;%on -Inf and negs, top with 0.0
rclos.Topp(i(r.Topp(i)))=false;%delete -Inf on diagonal.
return%rclos

