function [Z] = mmp_u_nXxYnZ_mtimes_raw(X,Y)
% A primitive to carry out upper multiplication between a MNPLUS and a
% MXPLUS encoded  matrices. Result is MNPLUS
%
%
% function [Z] = mmp_u_nXxYnZ_mtimes_raw(X,Y)
%
% - X is [mX nX] sparse MNPLUS encoded
% - Y is [mY nY] sparse MXPLUS encoded
% - Z is [mX nY] sparse MNPLUS encoded
%
% CAVEAT, there are no checks on the storage format, dimensional
% conformance or the encoding!
%
% AUTHOR: CPM- FVA 07/09/09

[mX nX]= size(X);
nY = size(Y,2);

X=X.';%Transpose (negligible cost) to make row extraction easier.
% if spX && spY
%Z=sparse(mX,nY);%return sparse matrix
Z=spalloc(mX,nY,floor((mX*nY)/10));
nYbot=spalloc(nX,1,nX);%Create storing var. to avoid increments
zcol=spalloc(mX,1,mX);%allocate storing var.

%%THIS governed by Y: remember: result is MXPLUS encoded
for j=1:nY%Y is MNPLUS encoded
    colY=Y(:,j);%Extract as much work out of the loop as possible
    nYbot = (colY ~= Inf);%find non-bottoms
    if any(nYbot)%any non-bottom in column 
        Ytop = ~logical(colY);
        colY(colY == eps) = 0.0;
        for i = 1:mX
            rowX = X(:,i);
            %XYfin = nYtop & logical(rowX) & ~Ybot & (rowX ~= -Inf);
            nXorYbot = logical(rowX) & nYbot;%neither entry is bottom
            if any(nXorYbot)%If any value to be considered for max
                %If any Inf left, result is Inf
                if any((Ytop|rowX==-Inf) & nXorYbot)%detects any TOPS in non-bottoms
                    zcol(i)=-Inf;
                else%all are finite
                    rowX(rowX==-eps)=0.0;
                    res=min(colY(nXorYbot)+rowX(nXorYbot));
                    if res==0.0, zcol(i)=-eps; else zcol(i)=res; end%MXPLUS encoding
                end                    
%                 %calculate strictly finite support
%                 XandYfin= (nYtop | (rowX  ~= Inf)) & nXorYbot;
%                 if all(XandYfin)
%                     rowX(rowX==eps)=0.0;
%                     res=max(colY(XandYfin)+rowX(XandYfin));
%                     if res==0.0, zcol(i)=eps; else zcol(i)=res; end
%                 else%else result is Inf.
%                     zcol(i)=Inf;
%                 end
            end
        end%for i
        Z(:,j) = zcol;%Store accumulator
        zcol(:)=0.0;%blank accumulator
    end%otherwise, Z(:,j)  is an inf.
end
return%Z in MNPLUS encoding
