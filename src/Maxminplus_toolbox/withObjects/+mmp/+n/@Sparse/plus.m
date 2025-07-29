function Z = plus(X,Y)
% OO upper addition of MNPLUS encoded matrices
switch class(X)
    case 'mmp.n.Sparse'
        switch class(Y)
            case 'mmp.n.Sparse'
                Z=mmp.n.Sparse(mmp_u_plus(X.Reg,Y.Reg));
            case 'double'
                Z=mmp.n.Sparse(mmp_u_plus(X.Reg,Y));
            case 'mmp.x.Sparse'
                error('mmp:n:Sparse:plus','Mixing MXPLUS and MNPLUS representations disallowed', class(Y))
%                 Y=mmp_x_sparse(Y);
%                 Z=mmp.x.Sparse(mmp_l_plus(X.Reg, Y.Reg));
            otherwise
                error('mmp:n:Sparse:plus','unknown input parameter type %s', class(Y))
        end
    case 'double'%Y must be MNPLUS encoded
        Z = mmp.n.Sparse(mmp_u_plus(X,Y.Reg));
    otherwise
        error('mmp:n:Sparse:plus','unknown first input parameter type %s', class(X))
end
return
