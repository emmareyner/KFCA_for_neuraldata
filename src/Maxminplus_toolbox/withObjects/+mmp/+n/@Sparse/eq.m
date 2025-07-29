function b = eq(X,Y)
% OO MNP upper encoding equality predicate
switch class(X)
    case 'mmp.n.Sparse'
        switch class(Y)
            case 'double'
                b = mmp_n_eq(X.Reg, Y);
            case 'mmp.n.Sparse'
                b = mmp_n_eq(X.Reg,Y.Reg);
            case 'mmp.x.Sparse'
                b = mmp_n_eq(X.Reg,mmp_x_to_n(Y.Reg));
            otherwise
                error('mmp:n:Sparse:eq','Unknown type for second parameter');
        end
    case 'double'%then Y must be MNPLUS
        b = mmp_n_eq(mmp_n_sparse(X),Y.Reg);
    otherwise
        error('mmp:n:Sparse:eq','Unknown type for first parameter: %s', class(X));
end
return
