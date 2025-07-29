function Z = mmp_x_sparse(X)
% OO change encoding from mmp.x.Double to mmp.n.Double
    Z=mmp.x.Sparse(double(X));
return
