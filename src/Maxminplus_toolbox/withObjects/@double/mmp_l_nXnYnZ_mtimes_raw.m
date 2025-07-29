function [Z] = mmp_l_nXnYnZ_mtimes_raw(X,Y)
% lower max-min-plus matrix (non-scalar) multiplication for matrices in
% MNPLUS encoding
%
% function [Z] = mmp_l_nXnYnZ_mtimes_raw(X,Y)
%
% - X is [mX nX] sparse MNPLUS encoded
% - Y is [mY nY] sparse MNPLUS encoded
% - Z is [mX nY] sparse MNPLUS encoded
%
% CAVEAT, there are no checks on the storage format, dimensional
% conformance or the encoding!
%
% AUTHOR: CPM- FVA 07/09/09

[mX nX]= size(X);
nY = size(Y,2);

Z=spalloc(mX,nY,floor((mX*nY)/10));%Empty matrix denotes all INF == TOP
nYbot=spalloc(nX,1,nX);%Create storing var. to avoid increments
zcol=spalloc(mX,1,mX);%allocate storing var.

X=X.';%Transpose (negligible cost) to make row extraction easier.
% the logic is strange: we have to look into all zeros of either matrix,
% except those that are paired in the other matrix with a -Inf (since
% Inf+-Inf = -Inf in lower multiplication).
for j=1:nY
    colY=Y(:,j);%Extract as much work out of the loop as possible
    nYbot = (colY~=-Inf);%find non-bottom elements
    if any(nYbot)
        Ytop = ~logical(colY);%Y finite or bottom
        colY(colY == -eps) = 0.0;
        for i = 1:mX
            rowX = X(:,i);
            %XYfin = nYtop & logical(rowX) & ~Ybot & (rowX ~= -Inf);
           nXorYbot = (rowX ~= -Inf) & nYbot;%neither is bottom
            if any(nXorYbot)%If any coordinate NOT covered by bottom...
             %Otherwise, if there is no left coordinate covered by Top
                if all((Ytop | ~logical(rowX)) & nXorYbot)
                    rowX(rowX==-eps)=0.0;
                    res=max(colY(nXorYbot)+rowX(nXorYbot));
                    if res==0.0, zcol(i)=eps; else zcol(i)=res; end
                end
%                 XandYfin=(nYtop | logical(rowX)) & ~XorYbot;
%                 if all(XandYfin)
%                     rowX(rowX==-eps)=0.0;
%                     res=max(colY(XandYfin)+rowX(XandYfin));
%                     if res==0.0, zcol(i)=eps; else zcol(i)=res; end
%                 end
            else%If all coordinates are covered by bottom...
                zcol(i) = -Inf;
            end
        end%for i
        Z(:,j) = zcol;%Store accumulator
        zcol(:)=0.0;%blank accumulator
    else
        Z(:,j)=-Inf;
    end
end
% for j=1:nY
%     colY=Y(:,j);%Extract as much work out of the loop as possible
%     %Ynz = (colY ~= 0.0);%Preassign
%     nYtop = logical(colY);%top elements
%     nYbot = colY~=-Inf;%Bottom elements
%     %Yfin = ;%finite elements
% %    if any(Ynz)
%         colY(colY==-eps)=0.0;%undo sparse encoding!!!This suggests storing Unitp.
%         for i = 1:mX
%             rowX=X(:,i);
%             fin = nYtop & (rowX ~= -Inf) | (logical(rowX) & nYbot);
%             %nz = Ynz & (rowX ~= 0.0);
%             nz = Ynz & logical(rowX);
%             if any(nz)
%                 rowX(rowX==eps)=0.0;%undo sparse encoding!!!This suggests storing Unitp.
%                 res=max(rowX(nz)+colY(nz));
%                 if res==0.0, zcol(i)=eps; else zcol(i)=res; end
%             end
%         end
%         Z(:,j)=zcol;%store column accumulator
%         zcol(logical(zcol))=0.0;%blank accumulator
% %    end
% end
return%Z

