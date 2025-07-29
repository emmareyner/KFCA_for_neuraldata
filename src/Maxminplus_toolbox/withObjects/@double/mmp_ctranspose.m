function  Z = mmp_ctranspose(X)
% Returns the maxplus inverse using the conjugate transpose notation.
% for a double M, this ctranspose(M)=M' is in normal calculus -M.'
%error(nargchk(1,1,nargin));
%Y=mmp.Double(-X.');
 if issparse(X)
    Z = spfun(@uminus,X.');
 else
    Z = -X.';
 end
%Y=mmp.Double(-ctranspose@double(X))
return
