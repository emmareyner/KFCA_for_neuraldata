function b = ge(X,Y)
% OO lower greater or equal predicate
switch class(X)
    case 'mmp.n.Sparse'
        switch class(Y)
            case 'double'
                b = mmp_n_ge(X.Reg, Y);
            case 'mmp.n.Sparse'
                b = mmp_n_ge(X.Reg,X.Reg);
            case 'mmp.x.Sparse'
                %        Y = from_mmp_n_sparse(Y);
                b = mmp_n_ge(X.Reg,mmp_x_to_n(Y.Reg));
            otherwise
                error('mmp:n:Sparse:ge','Unknown type for second parameter');
        end
    case 'double'%then Y must be MXPLUS
        b = mmp_n_ge(X,Y.Reg);
    otherwise
        error('mmp:n:Sparse:ge','Unknown type for first parameter');
end
return
