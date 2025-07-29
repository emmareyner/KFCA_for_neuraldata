function ts = mmp_x_ne(A,B)
% function ts = mmp_x_ne(A,B)
%
% A function to test if two mp matrices are unequal. For that to happen
% their dimensions should be equal and the elements in which they differ
% should differ by more than 2*eps
%
% Author: fva 27/04/2007
[ma na] = size(A);
[mb nb] = size(B);
spA = issparse(A);
spB = issparse(B);
if (ma == mb) && (na == nb)%two equal-size matrices
    if spA || spB
        if ~spA
            A = mmp_x_sparse(A);
        elseif ~spB,
            B = mmp_x_sparse(B);
        end
        ts=sparse(ma,na);
    else%both full
        ts=false(ma,na);
    end
elseif (ma == 1) && (na == 1)%A is scalar
    if spB,
        ts = sparse(mb,nb);
    else
        ts = false(mb,nb);
    end
%     Am = zeros(mb,nb);
%     Am(:)=A;
%     A=Am;
elseif (mb == 1) && (nb == 1)%B is scalar
    if spA
        ts = sparse(ma,na);
    else
        ts = false(ma,na);
    end
else%if (ma ~= mb) || (na ~= nb)
    error('Double:mmp_x_ne','Incomparable sizes')
end
diffs = (A ~= B);
ts(~diffs)=false;
%In all different places, the difference should be less than 2*eps
%ts(diffs) = abs(A(diffs) - B(diffs)) <= 2*eps(26);
ts(diffs) = abs(A(diffs) - B(diffs)) > eps(2);
return
