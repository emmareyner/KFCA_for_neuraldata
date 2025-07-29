function [Z] = mmp_l_mtimes_raw(X,Y)
% lower max-min-plus matrix (non-scalar) multiplication
%
% function [Z] = mmp_l_mtimes_raw(X,Y)
%
% - X is [mX nX] FULL
% - Y is [mY nY] FULL
% - Z is [mX nY] FULL
%
% CAVEAT: no test whether the matrices are conformant and in the same
% sparse encoding is done.
%
% AUTHOR: CPM- FVA 07/09/09

% Only conformant matrices, whether sparse or not. Does not check inner
% dimension. Use with care.
mX = size(X,1);
nY = size(Y,2);
Z=-Inf(mX,nY);%return full matrix.
colZ=-Inf(mX,1);%%initialize ACC for columns
%allocate nz here.
X=X.';%Transpose (negligible cost) to make row extraction easier.
for j=1:nY
    colY=Y(:,j);%Just one extraction
    Ynz = (colY ~= -Inf);%Filter non-zero elements
    if any(Ynz)
        for i=1:mX
            rowX=X(:,i);%Extract as much work out of the loop as possible
            nz = Ynz & (rowX ~= -Inf);
            if any(nz), colZ(i)=max(rowX(nz)+colY(nz)); end
            %Just ignore coordinates in which X or Y show a zero: these go
            %to zero
        end
        Z(:,j)=colZ;%only one access per column
        colZ=-Inf(mX,1);%%initialize ACC for columns
    end
end
return
