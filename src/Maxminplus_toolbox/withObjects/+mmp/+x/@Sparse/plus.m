function Z = plus(X,Y)
% OO lower addition of MXPLUS encoded matrices
switch class(X)
    case 'mmp.x.Sparse'
        switch class(Y)
            case 'mmp.x.Sparse'
                Z=mmp.x.Sparse(mmp_l_plus(X.Reg,Y.Reg));
            case 'double'
                Z=mmp.x.Sparse(mmp_l_plus(X.Reg,Y));
            case 'mmp.n.Sparse'
                error('mmp:x:Sparse:plus','Mixing MXPLUS and MNPLUS representations disallowed', class(Y))
%                 Y=mmp_x_sparse(Y);
%                 Z=mmp.x.Sparse(mmp_l_plus(X.Reg, Y.Reg));
            otherwise
                error('mmp:x:Sparse:plus','unknown second input parameter type %', class(Y))
        end
    case 'double'%Y must be MXPLUS encoded
        Z = mmp.x.Sparse(mmp_l_plus(X,Y.Reg));
    otherwise
        error('mmp:x:Sparse:plus','unknown first input parameter type %', class(X))
end
return
