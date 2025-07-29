function ts = mmp_l_eq(A,B)
% function ts = mmp_l_eq(A,B)
%
% A function to test if two mp matrices are equal. For that to happen
% their dimensions should be equal and the elements in which they differ
% should not differ by more than 2*eps. Sparse matrices are taken to be
% encoded in MXPLUS encoding
%
% If any of them is sparse, the result is sparse.
% 
%
% Author: fva 27/04/2007
[ma na] = size(A);
if (ma == 1) && (na == 1)
%     Am = zeros(mb,nb);
%     Am(:)=A;
%     A=Am;
    ts = abs(B-A) <= eps;
    return%early termination
end
[mb nb] = size(B);
if (mb == 1) && (nb == 1)
%     Bm = zeros(ma,na);
%     Bm(:)=A;
%     B=Bm;
    ts = abs(A-B) <= eps;
    return%early termination
end
if (ma ~= mb) || (na ~= nb)
    error('double:mmp_l_eq','Incomparable sizes')
else
%     spA = issparse(A);
%     spB = issparse(B);
%     if spA || spB
%         if ~spA
%             A = mmp_x_sparse(A);
%         elseif ~spB,
%             B = mmp_x_sparse(B);
%         end
%         ts=sparse(ma,na);
%     else%both full
        ts=false(ma,na);
%     end
    diffs = (A ~= B);
    ts(~diffs)=true;
    %In all different places, the difference should be less than 2*eps
    %ts(diffs) = abs(A(diffs) - B(diffs)) <= 2*eps(26);
    ts(diffs) = abs(A(diffs) - B(diffs)) <= eps;
end
return
