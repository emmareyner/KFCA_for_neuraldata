function Z = mtimes(X,Y)
% function Z = mmp.u.mtimes(X,Y)
% upper matrix multiplication of either full or sparse double matrices
% in either MXPLUS or MNPLUS encoding.

%FVA: 27/26/09. package and oo version
error(nargchk(2,2,nargin));
% Tries to follow the invocation pattern of mtimes q.v.
[mX nX]=size(X);
[mY nY]=size(Y);
%1. X is scalar
if (mX ==1) && (nX==1)
    Z = mmp.u.stimes(X,Y);
elseif (mY==1) && (nY == 1)
    Z= mmp.u.stimes(Y,X);
elseif (nX == mY)%conformant matrices, carry out multiplication
    %     if nX==0%nX == mY == 0, don't multiply!
    %     end
    switch class(X)
        case 'double'%All results are double
            switch class(Y)
                case 'double'
                    Z = mmp_u_mtimes_raw(X,Y);
                case {'mmp.n.Sparse','mmp.x.sparse'}
                    Z = mmp_u_mtimes_raw(X, double(Y));
                otherwise
                    error('mmp:u:mtimes','unknown second input parameter type %s when first type is double', class(Y))
            end
        case 'mmp.n.Sparse'%Try to keep sparse result
            switch class(Y)
                case 'mmp.n.Sparse'
                    Z = mmp.n.Sparse(mmp_u_nXnYnZ_mtimes_saw(X.Reg,Y.Reg));%Defaults to mm.n.mtimes which is SPARSE upper addition
                case 'mmp.x.Sparse'%Defaults to mm.n.mtimes which is SPARSE upper addition
                    Z = mmp.n.Sparse(mmp_u_nXxYnZ_mtimes_raw(X.Reg, Y.Reg));
                    %                Z = mmp.n.Sparse(mmp_u
                case 'double'
                    Z = mmp_u_mtimes_raw(double(X), Y);
                otherwise
                    error('mmp:u:mtimes','unknown second input parameter type %s when first type is mmp.n.Sparse', class(Y))
            end
        case 'mmp.x.Sparse'%try to keep results mmp.n.sparse (why not mmp.x.sparse)
            switch class(Y)
                case 'mmp.n.Sparse'
                    Z = mmp.n.Sparse(mmp_u_xXnYnZ_mtimes_raw(X.Reg, Y.Reg));;%Defaults to mm.n.mtimes which is SPARSE upper addition
                case 'mmp.x.Sparse'%stranger, Why not upper-multiply them?
                    Z = mmp.x.Sparse(mmp_u_xXxYxZ_mtimes_raw(X.Reg,Y.Reg));%Defaults to mm.n.mtimes which is SPARSE upper addition
                case 'double'%OK checked
                    Z = mmp_u_mtimes_raw(double(X), Y);
                otherwise
                    error('mmp:u:mtimes','unknown second input parameter type %s when first type is mmp.x.Sparse', class(Y))
            end
        otherwise
            error('mmp:u:mtimes','unknown first input parameter type %s', class(X))
    end
else
    error('mmp:l:mtimes','Non-conformant matrices!');
end
return%Z
