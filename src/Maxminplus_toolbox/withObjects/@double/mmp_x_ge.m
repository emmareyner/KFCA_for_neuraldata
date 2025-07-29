function ts = mmp_x_ge(A,B)
% function ts = mmp_x_ge(A,B)
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
    error('double:mmp_x_ge','Incomparable sizes')
end
m=max(ma,mb);
n=max(na,nb);

spA = issparse(A);
spB = issparse(B);
%if neither, then do normal double ge
if ~(spA || spB)
    ts = A >= B;
    return
end
%if xor(spA,spB)%if either, but not both, is sparse
    if spA%...sparsify B
        B = mmp_x_sparse(B);
    else%..sparsify A
        A = mmp_x_sparse(A);
    end
%end
%if spA||spB%if any sparse, result is sparse
    ts=logical(sparse(m,n));
%else%both full, result is full
%    ts=false(m,n);
%end
%look where both entries differ...
diffs = (A ~= B);
ts(~diffs)=true;%places where they are equal.
%In all different places, the difference should be greater than 2*eps
% for A to be greater than or equal to B 
%ts(diffs) = abs(A(diffs) - B(diffs)) >= 2*eps(26);
if ~(m==min(ma,mb))
    if ma == 1%then mb ~= 1
        if A~=0
            ts(diffs & B==0)=true;
            ts(diffs & B~=0)= A >= B(diffs & B~=0);
%        else% on A==0, nothing left to do
        end
    else%mb == 1 && ma ~= 1
        if B==0
            ts(:)=true;
        else%where B is not -Infi
            %ts(diffs & A==0)=false;%This is the default, unneeded
            ts(diffs & A~=0)=A(diffs & A~=0)>= B;
        end
    end
else%same dimensions
    %ts(diffs & A==0) = false;%this is the default, unneeded
    ts(diffs & B==0) = true;
    diffsNotA0NotB0 = diffs & A~=0 & B~=0;
    ts(diffsNotA0NotB0) = A(diffsNotA0NotB0) >= B(diffsNotA0NotB0);
end
%ts(diffs) = (A(diffs) - B(diffs)) >= eps(2);
%In all other places, they are equal
return

%look where both entries differ...
diffs = (A ~= B);
%In all different places, the difference should be greater than 2*eps
% for A to be greater than or equal to B 
%ts(diffs) = abs(A(diffs) - B(diffs)) >= 2*eps(26);
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
