function [Z]=mmp_u_mtimes(X,Y)
% maxminplus double matrix upper multiplication  of either full or sparse
% matrices. Result is full except if both are sparse.
%
% Tries to follow the invocation pattern of mtimes q.v.


[mX nX]=size(X);
[mY nY]=size(Y);

%1. X is scalar
if (mX ==1) && (nX==1) 
    switch X
        case Inf%minplus zero, everywhere
            if issparse(Y)
                Z=sparse(mY,nY);
            else
                Z=Inf(mY,nY);
            end
        case -Inf%minplus top, except at Inf locii
            if issparse(Y)%erase finite values
                Z=Y;%Z inherits sparseness from Y
                Z(logical(Y))=-Inf;
            else%full Y, just honour minplus zeroes
                Z=-Inf(mY,nY);
                Z(Y==Inf)=Inf;
            end
        case 0
            if issparse(X)%the null
                Z=sparse(mY,nY);
            else%the unit, do nothing
                Z=Y;
            end
        case eps
            if issparse(X)%the unit
                Z = Y;
            else
                Z = Y + eps;%Really useless
            end
        otherwise%a regular scalar
            %top and bottom patterns don't change
            %finite values are shifted, Units disappear only to appear
            %where original was -Xscalar
            if issparse(Y)
                newUnits=spfun(@(y) abs(X+y) <=eps(2), Y);
                Z=spfun(@(y) y+X,Y);
                Z(newUnits)=-eps;
            else
                Z=X+Y;%allowed in matlab 
            end
    end
    
%% 2. Y is scalar
elseif (mY==1) && (nY == 1)
    switch Y
        case Inf%minplus zero
            if issparse(X)
                Z=sparse(mX,nX);
            else
                Z=Inf(mX,nX);
            end
        case -Inf%minplus top
            if issparse(X)
                Z=X;
                Z(logical(X))=-Inf;
            else%full Y, just honour minplus zeroes
                Z=-Inf(mX,nX);
                Z(X==Inf)=Inf;
            end
        case 0
            if issparse(Y)%the null
                Z=sparse(mX,nX);
            else%the unit, do nothing
                Z=X;
            end
        case eps
            if issparse(Y)%the unit
                Z = X;
            else
                Z = X + eps;
            end
        otherwise%in any othe case, we have a scalar/full matrix.
            %top and bottom patterns don't change
            %finite values are shifted, Units disappear only to appear
            %where original was -Xscalar
            if issparse(X)
                newUnits=spfun(@(x) abs(x+Y) <=eps(2), X);
                Z=spfun(@(x) x+Y,X);
                Z(newUnits)=eps;
            else
                Z=X+Y;
            end
%             Z=X+Y;%the casting prevents mmp.l.Double.plus being called
    end

elseif (nX == mY)
    if nX==0%nX == mY
        if issparse(X) && issparse(Y)
            Z=sparse(mX,nY);
        else
            Z=Inf(mX,nY);%return full, empty, zero matrix.
        end
    else%Else do the multiplication!!
        Z = mmp_u_mtimes_raw(X,Y);
    end
else%% Error on non-conformant matrices
    error('double:mmp_u_mtimes','Non-conformant matrices!');
    
%     %solve in basic domain: cast to supertype
%     X=X.';%Transpose (negligible cost) to make row extraction easier.
%     if issparse(X) && issparse(Y)
%         Z=sparse(mX,nY);%return sparse matrix
%         eps2=2*eps;
%         for i=1:mX
%             rowX=X(:,i);%Extract as much work out of the loop as possible
%             Xnz = (rowX ~= 0.0);%Preassign
%             for j=1:nY
%                 %locate places that would go to Inf
%                 colY=Y(:,j);
%                 nz= Xnz & (colY ~= 0.0);
%                 %if there are any places not going to Inf
%                 if any(nz)
%                     %FVA: why not first do the max, then detect 0 or 2*eps
%                     %and correct? Takes less time!
%                     %res=max(pom);
%                     res=min(rowX(nz)+colY(nz));
%                     %detect generated zeros
%                     if abs(res) > eps2
%                     %if ((res~=0) && (res~=eps2))
%                         Z(i,j)=res;
%                     else
%                         Z(i,j)=-eps;
%                     end
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 end
%             end
%         end
%     else%either X or Y are sparse or both are full
%         if issparse(X)
%             X=mmp_u_full(X);
%         elseif issparse(Y)
%             Y=mmp_u_full(Y);
%         end
%         Z=Inf(mX,nY);%return full, matrix.
%         for i=1:mX
%             rowX=X(:,i);%Extract as much work out of the loop as possible
%             Xnz = (rowX ~= Inf);%Filter non-zero elements
%             if any(Xnz)
%                 for j=1:nY
%                     colY=Y(:,j);%Just one extraction
%                     XYnz = Xnz & (colY ~= Inf);
%                     if any(XYnz), Z(i,j)=min(rowX(XYnz)+colY(XYnz)); end
%                     %Just ignore coordinates in which X or Y show a zero: these go
%                     %to zero
%                 end
%             end
%         end
%     end
end
return
