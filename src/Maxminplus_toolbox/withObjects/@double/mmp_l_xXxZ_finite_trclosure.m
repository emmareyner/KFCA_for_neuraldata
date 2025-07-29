function Rstar = mmp_l_xXxZ_finite_trclosure(R)
% function star = mmp_l_xXxZ_finite_trclosure(R)
%
% Returns the lower transitive-reflexive (aka star, A*) closure of a
% non-null square sparse maxplus encoded matrix. If all the elements in the matrix are
% non-positive this is waaaaay more quick than mp_star.
%
% For strictly positive elements, it uses an iterative algorithm
% and it may take forever! (A warning is issued.)  
%
% See also, mp_star for the original version in the toolbox.
%
% TODO: iterative version of algorithm
if issparse(R)
    [m n]=size(R);
    if m~=n,
        error('Double:mmp_l_xXxZ_finite_trclosure','Not a square matrix')
    elseif m > 1
        Rstar = mmp_l_xXxZ_mpower_raw(mmp_l_xXxZ_rclosure(R),m-1);
    elseif m == 1
        if R > eps
            Rstar = Inf;
        else
            Rstar = eps;
        end
    else%if m == 0
        error('Double:mmp_l_xXxZ_finite_trclosure','0-dimension matrix!');
    end
else
    error('Double:mmp_l_xXxZ_finite_trclosure','sparse maxplus encoding required');
    
end
return%Rstar
