function ts = mmp_l_eq(A,B)
% function ts = mmp_l_eq(A,B)
%
% A function to test if two maxplus encoded matrices are equal. For that to happen
% their dimensions should be equal and the elements in which they differ
% should not differ by more than 2*eps
%
% If any of them is sparse, the result is sparse.
%
% Author: fva 27/04/2007
[ma na] = size(A);
[mb nb] = size(B);
if (ma == 1) && (na == 1)
    Am = zeros(mb,nb);
    Am(:)=A;
    A=Am;
elseif (mb == 1) && (nb == 1)
    Bm = zeros(ma,na);
    Bm(:)=B;
    B=Bm;
elseif (ma ~= mb) || (na ~= nb)
    error('Double:mmp_l_eq','Incomparable sizes')
end

spA = issparse(A);
spB = issparse(B);
if spA || spB
    if ~spA
        A = mmp_l_sparse(A);
    elseif ~spB,
        B = mmp_l_sparse(B);
    end
    ts=sparse(ma,na);
else%both full
    ts=false(ma,na);
end
diffs = (A ~= B);
%In all different places, the difference should be less than 2*eps
%ts(diffs) = abs(A(diffs) - B(diffs)) <= 2*eps(26);
ts(diffs) = abs(A(diffs) - B(diffs)) <= eps(2);
%In all other places, they are equal
ts(~diffs)=true;
return
