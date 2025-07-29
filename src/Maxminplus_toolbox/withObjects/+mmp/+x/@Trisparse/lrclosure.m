function rclos = lrclosure(r)
% function rclos = mmp.x.sparse.lrclosure(r)
%
% For square matrices, it returns the lower reflexive closure of the matrix,
% i.e. mmp.l.plus(mmp.l.eye(n),r). For non-square, it tries to add a zero to the
% diagonal of the matrix; this case can't be a closure.
%
% Tries to avoid carrying out a lot of maxplus additions. 
%
% fva, Apr-Jul 2008
siz=size(r);
m = min(siz);
i = sub2ind(siz,1:m,1:m);%linear index for diagonal
rclos=r;%create closure
%dReg=logical(r.Reg(i));%dUnit=r.Unitp(i);dTopp=r.Topp(i);
negregd=(r.Reg(i) < -eps);%find regular diagonal negative els.
rclos.Reg(i(negregd))=0.0;%delete neg regulars on diagonal
zd = ~(negregd|r.Unitp(i)|r.Topp(i));%find -Inf diagonal elements;
rclos.Unitp(i(zd|negregd))=true;%on -Inf and negs, top with 0.0
return%rclos

