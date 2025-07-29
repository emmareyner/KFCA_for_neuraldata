function Z = mtimes_raw(X,Y)
% logical multiplication between conformant logical matrices. Addition is
% with or and multiplication with and. X is already transposed.

[mX]=size(X,1);
[nY]=size(Y,2);

if issparse(X) && issparse(Y)
    Z= logical(sparse([],[],[],mX,nY,ceil(mX*nY/2)));%Just in case it is full!
else
    Z = false(mX,nY);
end
for j = 1:nY
    Z(:,j) = any(X(:,Y(:,j)),2);%multiplying as a linear combination of columns.
end
return%Z
