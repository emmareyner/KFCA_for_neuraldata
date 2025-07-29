function ts = eq(X,Y)
% function ts = mmp.sparse.eq(A,B)
%
% A function to test if two max-min-plus matrices are equal. For that to
% happen their dimensions should be equal and the elements in which they
% differ should not differ by more than 2*eps.

% Mmp adaptation: FVA 24/02/2009
% object conversion: FVA 16/03/2009

error(nargchk(2,2,nargin));

%% conformance analysis
sizX=size(X);
sizY=size(Y);
%Rule out incomparable sizes
if any(sizX ~= sizY)
    error('mmp:eq','Incomparable sizes'); 
end

%% sparseness analysis
spX=isa(X,'mmp.sparse');
spY=isa(Y,'mmp.sparse');

%% Find pattern matrices for X and Y: ALL SPARSE
if spX && X.Xpsp
    [nzotX,oX,tX]=mmp.x.patterns(X);
    zX=~(nzotX|oX|tX);
else
    [nzotX,oX,zX]=mmp.n.patterns(X);%Tops in minp encoding are zeros in maxp
    tX=~(nzotX|oX|zX);
end
if spY && Y.Xpsp
    [nzotY,oY,tY]=mmp.x.patterns(Y);
    zY=~(nzotY|oY|tY);
else
    [nzotY,oY,zY]=mmp.n.patterns(Y);%Tops in minp encoding are zeros in maxp
    tY=~(nzotY|oY|zY);
end

%% Find result matrix
%equal in places where both are Inf, -Inf or 0.0
ts = (zX & zY) | (oX & oY) | (tX & tY);
nzot=nzotX&nzotY;
%Now compare on regular values
if any(any(nzot))
    if spX, Xvals=X.Reg(nzot); else Xvals=X(nzot); end
    if spY, Yvals=Y.Reg(nzot); else Yvals=Y(nzot); end
    %In all different places, the difference should be less than 2*eps
    %TODO check which is quicker
%     [I,J]=find(nzot);
%     ts(sparse(I,J,(abs(Xvals - Yvals) <= 2*eps(26))))=true;
    ts(nzot)=abs(Xvals - Yvals) <= 2*eps(26);
end
if (~spX || ~spY), ts=full(ts); end%massage to full when any factor is full
return%ts
    