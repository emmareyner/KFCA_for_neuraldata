function Rstar = mmp_l_finite_trclosure(R)
%
% Returns the lower transitive (aka metric matrix, A+) closure of a
% non-null square DEFINITE matrix. It uses Cunninghame-Green's formula:
% finite_tclosure(R)=rclosure(R)^n, where n=size(R,2)
if ~issparse(R)
    [m n] = size(R);
    if m~=n
        error('Double:mmp_l_finite_trclosure','Non-square input');
    end
    if n == 1
        if (R > 0)
%            error('Double:mmp_l_finite_trclosure','Non-definite matrix');
            Rstar = Inf;%this shouldn't really be allowed, but is very easy here
        else
            Rstar = 0;%R otimes Rstar
        end
    else%bigger n's: do the calculation
        Rstar = mmp_l_mpower_raw(mmp_l_rclosure(R),n-1);
    end%TODO use raw primitives for these calculations
else
    error('Double:mmp_l_finite_trclosure','Sparse input matrix not allowed');
end
return
