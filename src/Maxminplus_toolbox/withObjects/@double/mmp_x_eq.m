function ts = mmp_x_eq(A,B)
% function ts = mmp_x_eq(A,B)
%
% A function to test if two MXPLUS encoded matrices are equal. For that to happen
% their dimensions should be equal and the elements in which they differ
% should not differ by more than 2*eps
%
% You can test for equality of doubles too!
%
% Author: fva 27/04/2007
error(nargchk(nargin,2,2));
if ~issparse(A) 
    error('double:mmp_x_eq','Non-sparse first argument')
elseif ~issparse(B)
    error('double:mmp_x_eq','Non-sparse second argument')
end

[ma na] = size(A);
sA = ma == 1 && na == 1;%scalar  A
[mb nb] = size(B);
sB = mb == 1 && nb == 1;%scalar B
if ~((ma == mb) && (na == nb)...%two equal-size matrices
     || sA...%A a scalar, B a matrix
     || sB)% A a scalar, B a matrix
    error('double:mmp_x_eq','Incomparable sizes')
end
%decide size of output
if sA
    m = mb;
    n = nb;
else%if sB or both non-scalar
    m = ma;
    n = na;
end
ts=sparse(m,n);

% if xor(spA,spB)%if either, but not both, is sparse
%     if spA%...sparsify B
%         B = mmp_x_sparse(B);
%     else%..sparsify A
%         A = mmp_x_sparse(A);
%     end
% end%both are sparse

%look where both entries differ...
diffs = (A ~= B) ;
%In all different places, the difference should be less than 2*eps
% for them to be equal, except accumulating errors!
%ts(diffs) = abs(A(diffs) - B(diffs)) < eps;%since abs(0 -eps) is not <
%than eps
if sA
%    ts(diffs) = ((A == 0) & (B(diffs)==eps)) | ((A==eps) & (B(diffs)==0) | abs(A - B(diffs)) <= eps;
    ts(diffs) = xor(((A==0) & (B(diffs)==eps)) | ((A==eps) & (B(diffs)==0)), abs(A - B(diffs)) <= eps);
elseif sB
    ts(diffs) = xor(((A(diffs)==0) & (B==eps)) | ((A(diffs)==eps) & (B==0)), abs(A(diffs) - B) <= eps);
else%same dimensions
%    ts(diffs) = ~(abs(A(diffs) - B(diffs)) >= eps);
    ts(diffs) = xor(((A(diffs)==0) & (B(diffs)==eps)) | ((A(diffs)==eps) & (B(diffs)==0)), abs(A(diffs) - B(diffs)) <= eps);
end
%ts(diffs) = abs(A(diffs) - B(diffs)) <= eps(4);
%doesn't work for 0 (aka -INf) and eps (aka 0)
%In all other places, they are equal
ts(~diffs)=true;
return
