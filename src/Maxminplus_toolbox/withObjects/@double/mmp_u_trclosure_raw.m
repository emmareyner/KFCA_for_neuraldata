function Rstar = mmp_u_trclosure_raw(R)
% function star = mmp_u_trclosure_raw(R)
%
% Returns the upper transitive-reflexive (aka star, A*) closure of a
% non-null square double matrix. If all the elements in the matrix are
% non-negative this is waaaaay more quick than mp_star.
%
% For strictly positive elements, it uses an iterative algorithm
% and it may take forever! (A warning is issued.)  
%
% See also, mp_star for the original version in the toolbox.
%
% Gondran and Minoux, 2008. Chap. 4 Sec. 2.3. p. 119
%
% CAVEAT: No check of input parameters done! See mmp_u_trclosure.

%TODO: do this by the path-finding methods! for big matrices!
n=size(R,1);
Rstar = mmp_u_mpower_raw(mmp_u_rclosure(R),n-1);
%In Maxminplus, we need to close further than that!
Rstar_sq = mmp_u_mtimes(Rstar,Rstar);
while any(any(Rstar  ~= Rstar_sq))
    Rstar = Rstar_sq;
    %star_sq = mmp.l.mtimes(star,star);
    %star_sq = mmp.n.sparse.mtimesl(star,star);
    Rstar_sq= mmp_u_mtimes(Rstar,Rstar);
end
return%Rstar
