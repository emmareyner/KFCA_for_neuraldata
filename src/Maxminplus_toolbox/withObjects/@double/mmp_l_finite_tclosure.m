function Rplus = mmp_l_finite_tclosure(R)
%
% Returns the lower transitive (aka metric matrix, A+) closure of a
% non-null square DEFINITE matrix. It uses Cunninghame-Green's formula:
% finite_tclosure(R)=rclosure(R)^n, where n=size(R,2)
if ~issparse(R)
    [m n] = size(R);
    if m==n
        if n > 1%bigger n's: do the calculation
            Rplus = mmp_l_mtimes_raw(R,mmp_l_mpower_raw(mmp_l_rclosure(R),n-1));
        elseif n == 1
            if (R(1,1) > 0)
                error('Double:mmp_l_finite_tclosure','Non-definite matrix');
                %Rplus = Inf;%this shouldn't really be allowed.
            else
                Rplus = R;%R otimes Rstar
            end
        else
            error('Double:mmp_l_finite_tclosure','Empty matrix');
        end%TODO use raw primitives for these calculations
    else
        error('Double:mmp_l_finite_tclosure','Non-square input');
    end
else
    error('Double:mmp_l_finite_tclosure','Sparse input matrix');
end
return
