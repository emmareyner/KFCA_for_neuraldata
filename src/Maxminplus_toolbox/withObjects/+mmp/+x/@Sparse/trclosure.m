function Rstar = trclosure(R)
% OO maxplus transitive reflexive closure
%
% Returns the lower transitive-reflexive (aka star, A*) closure of a
% non-null square mmp.x.Sparse matrix. If all the elements in the matrix are
% non-positive this is waaaaay more quick than mp_star.
%
% For strictly positive elements, it uses an iterative algorithm
% and it may take forever! (A warning is issued.)  
%
% See also, mp_star for the original version in the toolbox.
%
% TODO: iterative version of algorithm
[m n]=size(R);
if m~=n
    error('Double:mmp_l_trclosure','Not a square matrix');
end
if m > 1
    Rstar = mmp.x.Sparse();
    Rstar.Reg = mmp_l_xXxZ_trclosure(R.Reg);
elseif m == 1
     if double(R) > 0, star = Inf; else star = 0; end
    Rstar = mmp.x.Sparse(star);
else%if m == 0
    error('Double:mmp_l_trclosure','undefined on empty matrix');
end
return%star
