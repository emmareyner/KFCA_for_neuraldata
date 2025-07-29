function [Z]=plus(X,Y)
%     lower addtiion operation for maxplus-encoded matrices.
%     mmp.x.sparse.plus(X,Y) lower-adds matrices X and Y.  X and Y must have
%     the same dimensions. X must always be maxplus encoded.
%
% CAVEAT: This may return a full, a maxplus or minplus encoded matrix.
%
% See also, mmp.n.plus, mmp.x.sparse, mmp.n.sparse

%FVA: 27/26/09. package and oo version
% PRECONDITION: X is mmp.x.sparse
if ~isa(X,'mmp.x.sparse')
    error('mmp:x:sparse:plus','Wrong type first argument');
end
%% conformance analysis
sizX=size(X);
sizY=size(Y);
    
%Conformance analysis drives the case-sifting
if any(sizX~=sizY)
    error('mmp:x:sparse:plus','non-conformant matrices!');  
%maxplus+full => full
elseif isa(Y,'double')
    Z=Y;
    Z(X.Topp)=Inf;
    %finp=(logical(X.Reg)|X.Unitp);
    finp=find(X.Reg|X.Unitp);
    %Z(finp)=max(X.Reg(finp),Y(finp));
    lXfinp=finp(X.Reg(finp) > Y(finp));%find places where Z has to be modified
    Z(lXfinp)=X.Reg(lXfinp);

else%both are sparse, turn into maxplus, then operate
    if isa(Y,'mmp.n.sparse'), Y=mmp.x.sparse(Y); end%cast into maxplus enc.
    Xfinp=logical(X.Reg)|X.Unitp;%pattern of finite entries in X
    Yfinp=logical(Y.Reg)|Y.Unitp;%pattern of finite entries in Y
    XYfinp=Xfinp&Yfinp;%pattern for the intersection of finite values
    Z=mmp.l.zeros(sizX);
    Z.Topp=X.Topp|Y.Topp;%TODO: change to minplus encoding if needed!
    XnYfinp=xor(Xfinp&~Z.Topp,XYfinp); Z.Reg(XnYfinp)=X.Reg(XnYfinp);
    nXYfinp=xor(Yfinp&~Z.Topp,XYfinp); Z.Reg(nXYfinp)=Y.Reg(nXYfinp);
    Z.Reg(XYfinp)=max(X.Reg(XYfinp),Y.Reg(XYfinp));
    %Z.Unitp=(Z.Reg(XYfinp)==0.0)  | (Y.Unitp&nXYfinp) | (X.Unitp&XnYfinp);%Changes sizes!
    Z.Unitp=(Y.Unitp&nXYfinp) | (X.Unitp&XnYfinp);%OK sizes
    XYfinp=find(XYfinp);%turn to linear index
    Z.Unitp(XYfinp(abs(Z.Reg(XYfinp))<= eps))=true;%refer to original matrix!!
end
return%Z
