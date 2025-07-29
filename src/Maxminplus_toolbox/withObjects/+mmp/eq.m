function b = eq(X,Y)
% OO MNP lower equality predicate
switch class(X)
    case 'mmp.x.Sparse'
        switch class(Y)
            case 'double'
                b = mmp_x_eq(X.Reg, mmp_x_sparse(Y));
            case 'mmp.x.Sparse'
                b = mmp_x_eq(X.Reg,X.Reg);
            case 'mmp.n.Sparse'
                b = mmp_x_eq(X.Reg,mmp_n_to_x(Y.Reg));
            otherwise
                error('mmp:Sparse:eq','Unknown type for second parameter');
        end
    case 'double'
%        b = mmp_x_eq(mmp_x_sparse(X),Y.Reg);
        switch class(Y)
            case 'double'
                b = abs(X - Y) <= eps(2);%Seems to small sometimes
            case 'mmp.x.Sparse'
                b = mmp_x_eq(mmp_x_sparse(X),Y.Reg);
            case 'mmp.n.Sparse'
                b = mmp_n_eq(mmp_n_sparse(X),Y.Reg);
            otherwise
                error('mmp:Sparse:eq','Unknown type for second parameter');
        end
    otherwise
        error('mmp:Sparse:eq','Unknown type for first parameter: %s', class(X));
end
return
