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
posregd=(r.Reg(i) > eps);%find regular diagonal positive els.
rclos.Reg(i(posregd))=0.0;%delete pos regulars on diagonal
zd = ~(posregd|r.Unitp(i)|r.Topp(i));%find Inf diagonal elements;
rclos.Unitp(i(zd|posregd))=true;%on Inf and pos elts, bottom with 0.0
return%rclos

