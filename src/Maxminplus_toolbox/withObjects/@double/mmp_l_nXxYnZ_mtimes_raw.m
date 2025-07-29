function [Z] = mmp_l_nXxYnZ_mtimes_raw(X,Y)
% A primitive to carry out lower multiplication between a MNPLUS and a
% MXPLUS encoded matrix. Only conformant SPARSE matrices, first argument is
% MNPLUS and second argument is MXPLUS.
% Result is MNPLUS (because Infs accumulate in the lower addition).
%
% CAVEAT, there are no checks on the storage format, dimensional
% conformance or the encoding!

[mX nX] = size(X);
nY = size(Y,2);
X=X.';%Transpose (negligible cost) to make row extraction easier.
% if spX && spY
%Z=sparse(mX,nY);%return sparse matrix
Z=spalloc(mX,nY,floor((mX*nY)/10));
nInfs=spalloc(nX,1,nX);%Create storing var. to avoid increments
zcol=spalloc(mX,1,mX);%allocate storing var.
for j=1:nY
    colY=Y(:,j);%Extract as much work out of the loop as possible
    Ynz = logical(colY);
    if any(Ynz)%If all are zero, 
        colY(colY==eps)=0.0;%undo sparse encoding!!! This suggests storing Unitp.
        for i=1:mX%X is MNPLUS encoded
            rowX=X(:,i);%%%%SO FAR 
            %Detect Infs. / non-Infs
            %Infs = ((colY == Inf) & (rowX ~=-Inf)) | ~logical(rowX);
            nInfs = logical(rowX) & ((colY ~= Inf) | (rowX == -Inf));
            %nz = Ynz & (rowX ~= 0.0);
            %Ynz & ~logical(rowx) marks Infs induced by 0s in X
            if any(nInfs)
                rowX(rowX==-eps)=0.0;%undo sparse encoding!!!This suggests storing Unitp.
                res=max(rowX(nInfs)+colY(nInfs));%this is lower addition!
                if res==0.0, zcol(i)=-eps; else zcol(i)=res; end%has to be done here to protect Infs
            end
        end
         Z(:,j)=zcol;%store column accumulator
         zcol(logical(zcol))=0.0;%blank accumulator
    else%all are 0/-Inf the result in this col is -Inf
        Z(:,j)=-Inf;%result is in MNPLUS
    end
end
return%Z in MNPLUS encoding
