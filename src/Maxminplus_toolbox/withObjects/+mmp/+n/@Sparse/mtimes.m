function Z = mtimes(X,Y)
% OO lower matrix multiplication of sparse double matrices in MNPLUS
% encoding.
    
Z=mmp.n.Sparse(mmp_u_mtimes(X.Reg,Y.Reg));
return
