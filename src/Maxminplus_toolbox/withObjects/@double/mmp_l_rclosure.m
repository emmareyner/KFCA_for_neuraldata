function rclos = mmp_l_rclosure(r)
%maxplus lower reflexive closure for a double matrix
if issparse(r)
     error('Double:mmp_l_rclosure','non-maxplus encoded matrix');
else
    siz=size(r);
    m = min(siz);
    i = sub2ind(siz,1:m,1:m);%linear index for diagonal
    rclos=r;
    rclos(i)=max(rclos(i),0.0);%on sparse, this would erase the elmt.
end;
return
