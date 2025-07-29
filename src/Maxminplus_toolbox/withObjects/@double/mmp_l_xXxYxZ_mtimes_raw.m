function [Z] = mmp_l_xXxYxZ_mtimes_raw(X,Y)
% lower max-min-plus matrix (non-scalar) multiplication
%
% function [Z] = mmp_l_xXxYxZ_mtimes_raw(X,Y)
%
% - X is [mX nX] sparse MXPLUS encoded
% - Y is [mY nY] sparse MXPLUS encoded
% - Z is [mX nY] sparse MXPLUS encoded
%
% CAVEAT, there are no checks on the storage format, dimensional
% conformance or the encoding!
%
% AUTHOR: CPM- FVA 07/09/09

% Only conformant matrices, whether sparse or not. Does not check inner
% dimension. Use with care.
[mX nX] = size(X);
nY = size(Y,2);
X=X.';%Transpose (negligible cost) to make row extraction easier.
%Z=sparse(mX,nY);%return sparse matrix
Z=spalloc(mX,nY,floor((mX*nY)/10));
nz=spalloc(nX,1,nX);%Create storing var. to avoid increments
zcol=spalloc(mX,1,mX);%allocate storing var.
for j=1:nY
    colY=Y(:,j);%Extract as much work out of the loop as possible
    %Ynz = (colY ~= 0.0);%Preassign
    Ynz = logical(colY);
    if any(Ynz)
        colY(colY==eps)=0.0;%undo sparse encoding!!!This suggests storing Unitp.
        for i = 1:mX
            rowX=X(:,i);
            %nz = Ynz & (rowX ~= 0.0);
            nz = Ynz & logical(rowX);
            if any(nz)
                rowX(rowX==eps)=0.0;%undo sparse encoding!!!This suggests storing Unitp.
                res=max(rowX(nz)+colY(nz));
                if res==0.0, zcol(i)=eps; else zcol(i)=res; end
            end
        end
        Z(:,j)=zcol;%store column accumulator
        zcol(:)=0.0;%blank accumulator
    end%if any(Ynz)
end
return%Z

