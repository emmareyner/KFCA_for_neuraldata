function [Z]=mmp_l_plus(X,Y)
%  oplusl   Maxplus lower addtion operation
%     mmp_l_plus(X,Y) lower-adds matrices X and Y.  X and Y must have the same
%     dimensions unless one is a scalar (a 1-by-1 matrix).
%     A scalar can be added to anything.


error(nargchk(2,2,nargin));
%FVA: 27/26/09. package and oo version

%% sparsity analysis
[mX nX]=size(X);
[mY nY]=size(Y);
spX = issparse(X);
spY = issparse(Y);

%Conformance analysis drives the case-sifting
%% 1. X is scalar
if (mX == 1) && (nX == 1)
    if X == Inf%maxplus top
        Z = Inf(mY,nY);%full top is better expressed in minplus!
    elseif (spX && X==0) || (~spX && X == -Inf)%maxplus bottom
        Z = Y;
    else
        Z = max(X,Y);%maintains sparsity
    end      
%     if spX%spY TOO!
%         switch X
%             case 0%maxplus additive zero, sparse encoding
%                 Z = Y;
%             case Inf
%                 Z=Inf(mY,nY);
%             otherwise
%                 Z = max(X,Y);
%         end
%     else%~spX
%         switch X
%             case -Inf%maxplus additive zero, full encoding
%                 Z=Y;
%             case Inf%Full maxplus additive top
%                 Z=Inf(mY,nY);
%             otherwise
%                 Z=max(X,Y);%TODO: maybe inline
%         end
%     end

    
%2. Y is scalar
elseif (mY == 1) && (nY == 1)
    if Y == Inf%maxplus top
        Z = Inf(mX,nX);
    elseif (spY && Y==0) || (~spY && Y == -Inf)%maxplus bottom
        Z = X;
    else
        Z = max(X,Y);
    end      
%     if spY%spX too
%         switch Y
%             case 0%maxplus additive zero, sparse encoding
%                 Z=X;
%             case Inf%maxplus top
%                 Z=Inf(mX,nX);
%             otherwise
%                 Z = max(X,Y);
%         end
%     else
%         switch Yscalar
%             case -Inf%maxplus additive zero
%                 Z=X;
%             case Inf%maxplus top
%                 Z=Inf(mX,nX);
%             otherwise%in any othe case, we have a scalar/full matrix.
%                 Z=max(Y,X);%TODO: maybe inline
%         end
%     end

elseif (mX ~= mY) || (nX ~= nY)
    error('Double:mmp_l_plus','Non-conformant matrices!');

%% 3. Conformant, i.e. non-scalar.% all(sizX==sizY)%
else
    Z = mmp_l_plus_raw(X,Y);
end
return
