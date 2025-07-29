function [Z]=plus(X,Y)
%     upper addition operation for minplus-encoded matrices.
%     mmp.n.sparse.plus(X,Y) upper-adds matrices X and Y.  X and Y must have
%     the same dimensions. X must always be minplus encoded.
%
% CAVEAT: This may return a full, a maxplus or minplus encoded matrix.
%
% See also, mmp.u.plus, mmp.n.sparse.plusu, mmp.n.sparse.plusl

%FVA: 27/26/09. package and oo version
% PRECONDITION: X is mmp.n.sparse
%% conformance analysis
%sizX=size(X);
%sizY=size(Y);
[mX nX]=size(X);
[mY nY]=size(Y);
warning('Evaluando mmp.n.sparse.plus');
%Conformance analysis drives the case-sifting
if (mX == mY) && (nX == nY)
%if any(sizX~=sizY)
    error('mmp:n:sparse:plus','Non-conformant matrices!');

elseif ~isa(X,'mmp.n.sparse')
    error('mmp:n:sparse:plus','Wrong type first argument');

%minplus+full => full
elseif isa(Y,'double')
    Z=Y;
    Z(X.Topp)=-Inf;
    %finp=logical(X.Reg)|X.Unitp;
    %Z(finp)=max(X.Reg(finp),Y(finp));
    finp=find(X.Reg|X.Unitp);
    lXfinp=finp(X.Reg(finp) < Y(finp));%find places where Z has to be modified
    Z(lXfinp)=X.Reg(lXfinp);
else%both are sparse, turn into minplus, then operate
    if isa(Y,'mmp.x.sparse'), Y=mmp.n.sparse(Y); end%cast into minplus enc.
    Xfinp=logical(X.Reg)|X.Unitp;%pattern of finite entries in X
    Yfinp=logical(Y.Reg)|Y.Unitp;%pattern of finite entries in Y
    XYfinp=Xfinp&Yfinp;%pattern for the intersection of finite values
    Z=mmp.u.zeros(sizX);
    Z.Topp=X.Topp|Y.Topp;%TODO: change to maxplus encoding if needed!
    XnYfinp=xor(Xfinp&~Z.Topp,XYfinp); Z.Reg(XnYfinp)=X.Reg(XnYfinp);
    nXYfinp=xor(Yfinp&~Z.Topp,XYfinp); Z.Reg(nXYfinp)=Y.Reg(nXYfinp);
    Z.Reg(XYfinp)=min(X.Reg(XYfinp),Y.Reg(XYfinp));
    %Z.Unitp=(Z.Reg(XYfinp)==0.0)  | (Y.Unitp&nXYfinp) | (X.Unitp&XnYfinp);%Changes sizes!
    Z.Unitp=(Y.Unitp&nXYfinp) | (X.Unitp&XnYfinp);%OK sizes
    XYfinp=find(XYfinp);%turn to linear index
    Z.Unitp(XYfinp(abs(Z.Reg(XYfinp))<= eps))=true;%refer to original matrix!!
end
return%Z
