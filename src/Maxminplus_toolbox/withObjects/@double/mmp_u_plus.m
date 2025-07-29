function [Z]=mmp_u_plus(X,Y)
%  oplusu --   maxminplus upper addtion operation
%     mmp_u_plus(X,Y) upper-adds matrices X and Y.  X and Y must have the same
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
    if X == -Inf%minplus top
        Z = -Inf(mY,nY);%full top is better expressed in minplus!
    elseif (spX && X==0) || (~spX && X == Inf)%minplus bottom
        Z = Y;
    else
        Z = min(X,Y);%maintains sparsity
    end      
    
%2. Y is scalar
elseif (mY == 1) && (nY == 1)
    if Y == -Inf%minplus top
        Z = -Inf(mX,nX);
    elseif (spY && Y==0) || (~spY && Y == Inf)%minplus bottom
        Z = X;
    else
        Z = min(X,Y);
    end      

elseif (mX ~= mY) || (nX ~= nY)
    error('Double:mmp_u_plus','Non-conformant matrices!');

%% 3. Conformant, i.e. non-scalar.% all(sizX==sizY)%
else
    Z = mmp_u_plus_raw(X,Y);
end
return
