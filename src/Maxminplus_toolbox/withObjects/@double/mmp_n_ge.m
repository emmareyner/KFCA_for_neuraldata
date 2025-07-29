function ts = mmp_n_ge(A,B)
% function ts = mmp_n_ge(A,B)
%
% A function to test if A is greater or equal than B  encoded matrices are equal. For that to happen
% their dimensions should be equal and the elements in which they differ
% should not differ by more than 2*eps
%
% You can test for equality of doubles too!
%
% Author: fva 27/04/2010
[ma na] = size(A);
[mb nb] = size(B);
if ~((ma == mb) && (na == nb)...%two equal-size matrices
     || (ma == na) && (ma == 1)...%A a scalar, B a matrix
     || (mb == nb) && (mb == 1))% A a scalar, B a matrix
    error('double:mmp_n_ge','Incomparable sizes')
end
m=max(ma,mb);
n=max(na,nb);

spA = issparse(A);
spB = issparse(B);
if xor(spA,spB)%if either, but not both, is sparse
    if spA%...sparsify B
        B = mmp_x_sparse(B);
    else%..sparsify A
        A = mmp_x_sparse(A);
    end
end%both are sparse or full
if spA||spB%if any sparse, result is sparse
    ts=sparse(m,n);
else%both full, result is full
    ts=false(m,n);
end
%look where both entries differ...
diffs = (A ~= B);
%In all different places, the difference should be greater than 2*eps
% for A to be greater than or equal to B 
if ~(m==min(ma,mb))
    if ma == 1%then mb ~= 1
         ts(diffs) = (A - B(diffs)) >= eps(2);
    else%mb == 1 && ma ~= 1
      ts(diffs) = (A(diffs) - B) >= eps(2);
    end
else%same dimensions
      ts(diffs) = (A(diffs) - B(diffs)) >= eps(2);
end
%ts(diffs) = (A(diffs) - B(diffs)) >= eps(2);
%In all other places, they are equal
ts(~diffs)=true;
return
