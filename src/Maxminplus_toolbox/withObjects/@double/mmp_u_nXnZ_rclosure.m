function rclos = mmp_u_nXnZ_rclosure(r)
%maxplus lower reflexive closure for a double MN encoded matrix

if issparse(r)
    siz=size(r);
    m = min(siz);
    i = sub2ind(siz,1:m,1:m);%linear index for diagonal
    rclos=r;
    rclos(i)=min(rclos(i),-eps);%eps is the value encoding zero.
else
    error('Double:mmp_l_nXnZ_rclosure','non-sparse minplus encoded matrix');
end;
return%rclos
