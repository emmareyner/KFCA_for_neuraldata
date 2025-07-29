function [Z] = mmp_l_nXxY_mtimes_raw(X,Y)
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
nz=spalloc(nX,1,nX);%Create storing var. to avoid increments
zcol=spalloc(mX,1,mX);%allocate storing var.
% for i = 1:mX
%     rowX=X(:,i);
%     Xnz = logical(rowX);
%     if any(Xnz)%Some of Xrow are not -Inf
%         rowX(rowX==eps)=0.0;
%         for j = 1:nY
%             colY=Y(:,j);
%             YnInf = logical(colY);
%             %On finite X entrie with Inf Y entries, no effort is needed
%             %if any(~Ynz & Xnz)
%             nInf=YnInf|~Xnz;
%             if all(nInf)
%                 colY(colY==eps)=0.0;
%                 Z(i,j)=max(
%             end
%         end
%         Z(i,:)=zcol;
%     else%all are 0/-Inf
%         Z(i,:)=-Inf;
%     end
% end
for j=1:nY
    colY=Y(:,j);%Extract as much work out of the loop as possible
    Ynz = logical(colY);
    if any(Ynz)%If all are zero, the result in this col is -Inf
        colY(colY==eps)=0.0;%undo sparse encoding!!!This suggests storing Unitp.
        for i=1:mX
            %nz = Ynz & (rowX ~= 0.0);
            nz = Ynz & logical(rowX);
            if any(nz)
                rowX(rowX==eps)=0.0;%undo sparse encoding!!!This suggests storing Unitp.
                res=max(rowX(nz)+colY(nz));
                if res==0.0, zcol(i)=eps; else zcol(i)=res; end
            end
         end
         Z(:,j)=zcol;%store column accumulator
         zcol(logical(zcol))=0.0;%blank accumulator
    else%all are 0/-Inf
        Z(:,j)=-Inf;
    end
end
% else%either X or Y are sparse or both are full
%     if spX%may be this is not needed?
%         X=mmp_l_full(X);
%     elseif spY
%         Y=mmp_l_full(Y);
%     end
%     Z=-Inf(mX,nY);%return full, matrix.
%     %allocate nz here.
%     for j=1:nY
%         colY=Y(:,j);%Just one extraction
%         Ynz = (colY ~= -Inf);%Filter non-zero elements
%         if any(Ynz)
%             colZ=-Inf(mX,1);
%             for i=1:mX
%                 rowX=X(:,i);%Extract as much work out of the loop as possible
%                 nz = Ynz & (rowX ~= -Inf);
%                 if any(nz), colZ(i)=max(rowX(nz)+colY(nz)); end
%                 %Just ignore coordinates in which X or Y show a zero: these go
%                 %to zero
%             end
%             Z(:,j)=colZ;
%         end
%     end
% end
return%Z in MNPLUS encoding
