function b = ge(X,Y)
% OO lower greater or equal predicate
switch class(X)
    case 'mmp.x.Sparse'
        switch class(Y)
            case 'double'
                b = mmp_x_ge(X.Reg, Y);
            case 'mmp.x.Sparse'
                b = mmp_x_ge(X.Reg,X.Reg);
            case 'mmp.n.Sparse'
                %        Y = from_mmp_n_sparse(Y);
                b = mmp_x_ge(X.Reg,mmp_n_to_x(Y.Reg));
            otherwise
                error('mmp:x:Sparse:ge','Unknown type for second parameter');
        end
    case 'double'%then Y must be MXPLUS
        b = mmp_x_ge(X,Y.Reg);
    otherwise
        error('mmp:x:Sparse:ge','Unknown type for first parameter');
end
return
