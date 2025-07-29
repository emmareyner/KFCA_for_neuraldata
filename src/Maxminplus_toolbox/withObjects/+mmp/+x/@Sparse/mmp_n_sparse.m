function Z = mmp_n_sparse(X)
% OO change encoding from mmp.x.Double to mmp.n.Double
    Z=mmp.n.Sparse(double(X));
return
