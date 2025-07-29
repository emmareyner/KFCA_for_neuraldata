function [Z]=plusu(X,Y)
%  plusu  lower addition operation for minplus-encoded matrices
%     mmp.x.sparse.plusu(X,Y) upper-adds matrices X and Y.  X and Y must have
%     the same dimensions. X must always be maxplus encoded.
%
% See also, mmp.u.plus, mmp.n.sparse.plus

%FVA: 27/26/09. package and oo version
% PRECONDITION: X is mmp.n.sparse object

%% conformance analysis
sizX=size(X);
sizY=size(Y);
    
%Conformance analysis drives the case-sifting
if any(sizX~=sizY)
    error('mmp:x:sparse:plusu','non-conformant matrices!');
end

%cast into maxplus form any other class of second arg.
if isa(Y,'double') || isa(Y,'mmp.n.sparse')
    Y = mmp.x.sparse(Y);
end%now both will be sparse maxplus

% X and Y are maxplus: initialize result
Z=mmp.l.zeros(sizX);%maxplus result
%1.Calculate tops aka Inf and intersect.
Z.Topp=X.Topp&Y.Topp;%NO change to maxplus encoding can ensue!

%2.Calculate finite coordinates
Xfinp=logical(X.Reg)|X.Unitp;%pattern of finite entries in X
Yfinp=logical(Y.Reg)|Y.Unitp;%pattern of finite entries in Y
XYfinp=Xfinp&Yfinp;%pattern for the intersection of finite values
Z.Reg(XYfinp)=min(X.Reg(XYfinp),Y.Reg(XYfinp));%work out infinite values

%3.Calculate unit elements
XYnzp=(Xfinp|X.Topp)&(Yfinp|Y.Topp);%nonzero values of result!
XnYfinp=xor(Xfinp&XYnzp,XYfinp);Z.Reg(XnYfinp)=X.Reg(XnYfinp);
nXYfinp=xor(Yfinp&XYnzp,XYfinp);Z.Reg(nXYfinp)=Y.Reg(nXYfinp);
%Z.Unitp=(Z.Reg(XYfinp)==0.0)  | (Y.Unitp&nXYfinp) | (X.Unitp&XnYfinp);%Changes sizes!
Z.Unitp=(Y.Unitp&nXYfinp) | (X.Unitp&XnYfinp);%OK sizes
XYfinp=find(XYfinp);%turn to linear index
%Z.Unitp(XYfinp(Z.Reg(XYfinp)==0.0))=true;%refer to original matrix!!
Z.Unitp(XYfinp(anb(Z.Reg(XYfinp))<= eps))=true;%refer to original matrix!!
return