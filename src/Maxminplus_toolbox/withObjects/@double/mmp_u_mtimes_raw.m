function [Z] = mmp_u_mtimes_raw(X,Y)
% upper max-min-plus matrix (non-scalar) multiplication
%
% function [Z] = mmp_u_mtimes_raw(X,Y)
%
% - X is [mX nX] FULL
% - Y is [mY nY] FULL
% - Z is [mX nY] FULL
%
% CAVEAT: no test whether the matrices are conformant and in the same
% sparse encoding is done.
%
% AUTHOR: CPM- FVA 09/09/09

% Only conformant matrices, whether sparse or not. Does not check inner
% dimension. Use with care. Result is sparse only when both X, Y are,
% otherwise it is full
mX = size(X,1);
nY = size(Y,2);

X=X.';%Transpose (negligible cost) to make row extraction easier.
Z=Inf(mX,nY);%return full, zero matrix.
for j=1:nY
    colY=Y(:,j);%Just one extraction
    Ynz = (colY ~= Inf);%Filter non-zero elements
    if any(Ynz)
        colZ= Inf(mX,1);
        for i=1:mX
            rowX=X(:,i);%Extract as much work out of the loop as possible
            nz = Ynz & (rowX ~= Inf);
            if any(nz), colZ(i)=min(rowX(nz)+colY(nz)); end
            %Just ignore coordinates in which X or Y show a zero: these go
            %to zero
        end
        Z(:,j)=colZ;
    end
end
return
