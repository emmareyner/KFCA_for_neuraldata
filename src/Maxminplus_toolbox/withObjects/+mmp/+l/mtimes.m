function Z = mtimes(X,Y)
% function Z = mmp.l.mtimes(X,Y)
% lower matrix multiplication of either full or sparse double matrices
% in either MXPLUS or MNPLUS encoding.

%FVA: 27/26/09. package and oo version
% FVA: 07/09/09, heavy use of subroutines.

error(nargchk(2,2,nargin));
% Tries to follow the invocation pattern of mtimes q.v.
[mX nX]=size(X);
[mY nY]=size(Y);
%1. X is scalar
if (mX ==1) && (nX==1)
    Z = mmp.l.stimes(X,Y);
elseif (mY==1) && (nY == 1)
    Z= mmp.l.stimes(Y,X);
elseif (nX == mY)%conformant matrices, carry out multiplication
    %     if nX==0%nX == mY == 0, don't multiply!
    %     end
    switch class(X)
        case 'double'%FULL AND SPARSE MATRICES
            switch class(Y)
                case 'double'
                    Z = mmp_l_mtimes_raw(X,Y);
                case {'mmp.x.Sparse','mmp.n.Sparse'}
                    Z = mmp_l_mtimes_raw(X,double(Y));
                otherwise
                    error('mmp:l:mtimes','unknown second input parameter type %s when first is double', class(Y))
            end
        case 'mmp.x.Sparse'
            switch class(Y)
                case 'mmp.x.Sparse'
                    Z =mmp.x.Sparse(mmp_l_xXxYxZ_mtimes_raw(X.Reg,Y.Reg));%Defaults to mmp.x.Sparse.mtimes
                case 'mmp.n.Sparse'
                    Z = mmp.x.Sparse(mmp_l_xXnYxZ_mtimes_raw(X.Reg,Y.Reg));
                    %Z = X * flipflop(Y);%Defaults to mm.x.mtimes which is SPARSE lower multiplication
                case 'double'
                    Z = mmp_l_mtimes_raw(double(X), Y);
                otherwise
                    error('mmp:l:mtimes','unknown second input parameter type %s when first is mmp.x.Sparse', class(Y))
            end
        case 'mmp.n.Sparse'
            switch class(Y)
                case 'mmp.x.Sparse'
                    %Z = flipflop(X) * Y;%Defaults to mm.x.mtimes which is SPARSE lower multiplication
                    Z = mmp.x.Sparse(mmp_l_nXxYxZ_mtimes_raw(X.Reg,Y.Reg));
                case 'mmp.n.Sparse'%stranger, Why not upper-multiply them, then flipflop?
                    %Z = flipflop(X) * flipflop(Y);
                    Z = mmp.n.Sparse(mmp_l_nXnYnZ_mtimes_raw(X.Reg,Y.Reg));
                case 'double'%OK checked
                    Z = mmp_l_mtimes_raw(double(X), Y);
                otherwise
                    error('mmp:l:mtimes','unknown second input parameter type %s when first type is mmp.n.Sparse', class(Y))
            end
        otherwise
            error('mmp:l:mtimes','unknown first input parameter type %s', class(X))
    end
else
    error('mmp:l:mtimes','Non-conformant matrices!');
end
return%Z
