function same = comparearray (A,B)

[ax,ay] = size(A);
[bx,by] = size(B);
same = (ax==bx) & (ay==by);
if same, same = prod(prod(A==B,2),1); end;
