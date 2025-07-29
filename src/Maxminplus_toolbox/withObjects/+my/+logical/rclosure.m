function rclos = rclosure(r)
%reflexive closure for a logical matrix

siz=size(r);
m = min(siz);
i = sub2ind(siz,1:m,1:m);%linear index for diagonal
rclos=r;
rclos(i)=true;
return
