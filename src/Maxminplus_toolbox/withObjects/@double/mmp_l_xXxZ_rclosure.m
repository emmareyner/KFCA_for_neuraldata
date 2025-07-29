function rclos = mmp_l_xXxZ_rclosure(r)
%maxplus lower reflexive closure for a double MX encoded matrix

if issparse(r)
    siz=size(r);
    m = min(siz);
    i = sub2ind(siz,1:m,1:m);%linear index for diagonal
    rclos=r;
    rclos(i)=max(rclos(i),eps);%eps is the value encoding zero.
else
    error('Double:mmp_l_xXxZ_rclosure','non-sparse maxplus encoded matrix');
end;
return%rclos
