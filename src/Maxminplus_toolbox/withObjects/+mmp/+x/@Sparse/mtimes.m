function Z = mtimes(X,Y)
% OO lower matrix multiplication of sparse double matrices in whatever
% encoding.
% Result is:
% - MXPLUS if any is MXPLUS
% - MNPLUS if both are MNPLUS
%
% AUTHOR FVA: 4/09/09
nX = size(X,2);
mY = size(Y,1);
if nX == mY
    switch class(X)
        case 'mmp.x.Sparse'
            switch class(Y)
                case 'mmp.x.Sparse'
                    Z=mmp.x.Sparse(mmp_l_xXxYxZ_mtimes_raw(X.Reg,Y.Reg));
                case 'mmp.n.Sparse'
                    Z=mmp.x.Sparse(mmp_l_xXnYxZ_mtimes(X.Reg,Y.Reg));
                otherwise
                    error('mmp:x:Sparse:mtimes','unknown second input parameter type %s when first is %s', class(Y),class(X))
            end
        case 'mmp.n.Sparse'
            switch class(Y)
                case 'mmp.x.Sparse'
                    Z=mmp.x.Sparse(mmp_l_nXxYxZ_mtimes(X.Reg,Y.Reg));
                case 'mmp.n.Sparse'
                    Z=mmp.n.Sparse(mmp_l_nXnYnZ_mtimes(X.Reg,Y.Reg));%%%%Returns a type MNPLUS!!
                otherwise
                    error('mmp:x:Sparse:mtimes','unknown second input parameter type %s when first is %s', class(Y),class(X))
            end
        otherwise
            error('mmp:x:Sparse:mtimes','unknown first input parameter type %s', class(X))
    end
else
    error('mmp:x:Sparse:mtimes','non-conformant input matrices');
end
    
return
