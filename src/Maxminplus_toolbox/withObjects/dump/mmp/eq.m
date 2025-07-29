function ts = eq(A,B)
% function ts = eq(A,B)
%
% A function to test if two matrices are equal. For that to happen
% their dimensions should be equal. The definition of when two
% representations differ changes from one representation to another.
%
% Author: fva 27/04/2007
[ma na] = size(A);
[mb nb] = size(B);
if (ma ~= mb) || (na ~= nb)
    error('mmp:eq','Incomparable sizes')
end

%% There is an error in comparison here!!
%dispatch on the type of A.
switch class(A)
    case 'double'
        if isa(B,'double')
            ts=(
end
%Perhaps create here an unsafe version?
diffs = sparse(A ~= B);

%In all different places, the difference should be less than 2*eps
ts = abs(A(diffs) - B(diffs)) <= 2*eps(26);
%maybe do the difference directly?
return
