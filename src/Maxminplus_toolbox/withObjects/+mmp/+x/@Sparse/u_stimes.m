function Z = u_stimes(s,X)
% A function to carry out upper scalar multiplication for matrices in
% maxplus encoding.
%
%FVA: 10/2010, CAVEAT this function is deprecated. Whenever you use it,
% it can safely be expanded into just its two lines!
Z = mmp.x.Sparse();
Z.Reg = mmp_u_xXxZ_stimes_raw(s,X.Reg);
return%Z
