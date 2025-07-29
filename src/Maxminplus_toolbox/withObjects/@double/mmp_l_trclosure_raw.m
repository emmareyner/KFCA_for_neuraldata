function Rstar = mmp_l_trclosure_raw(R)
% function star = mmp_l_trclosure_raw(R)
%
% Returns the lower transitive-reflexive (aka star, A*) closure of a
% non-null square mmp.l.Double matrix. If all the elements in the matrix are
% non-positive this is waaaaay more quick than mp_star.
%
% For strictly positive elements, it uses an iterative algorithm
% and it may take forever! (A warning is issued.)  
%
% See also, mp_star for the original version in the toolbox.
%
% Gondran and Minoux, 2008. Chap. 4 Sec. 2.3. p. 119

%TODO: do this by the path-finding methods! for big matrices!
n=size(R,1);
Rstar = mmp_l_mpower_raw(mmp_l_rclosure(R),n-1);%in maxplus, when stricly less than e.
%In Maxminplus, we need to close further than that!
Rstar_sq = mmp_l_mtimes(Rstar,Rstar);
while any(any(Rstar  ~= Rstar_sq))
    Rstar = Rstar_sq;
    %star_sq = mmp.l.mtimes(star,star);
    %star_sq = mmp.n.sparse.mtimesl(star,star);
    Rstar_sq= mmp_l_mtimes(Rstar,Rstar);
end
return%Rstar
