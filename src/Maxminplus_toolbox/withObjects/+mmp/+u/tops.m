function [Z]=tops(X,Y)
%     mmp.u.tops(N) is an N-by-N matrix of mmp.u.tops == -Inf
%  
%     mmp.u.tops(M,N) or mmp.u.tops([M,N]) is an M-by-N matrix of mmp.u.tops.
%  
%     mmp.u.tops(SIZE(A)) is the same size as A and all mmp.u.tops.
%  
%     mmp.u.tops with no arguments is the scalar -Inf.
%  
%     Note: The size inputs M, N, and P... should be nonnegative integers. 
%     Negative integers are treated as 0.
%  
%     See also mmp.u.eye, mmp.u.ones, mmp.u.zeros, mmp.u.eye, mmp.u.ones.

% FVA: 23/09/10
switch nargin
    case 0
        Z = -Inf;%Because of function documentation
        return%early termination
    case 1
        if isscalar(X)%square zero matrix
            Y=X;
        elseif all(size(X)==[1 2])%probably dimensions in a 1x2 matrix
            %not scalar, but matrix
            %X(full(X<0))=0;%neg. dimensions go to 0.
            Y=X(1,2);
            X=X(1,1);
        else
            error('mmp:u:tops','Input parameter configuration not allowed')
        end
    case 2
        if ~isscalar(X) || ~isscalar(Y)
            error('mmp:u:tops','Input parameter configuration not allowed');
        end
    otherwise
        error('mmp:u:tops','Wrong number of input parameters');
end
%m=max(X,0);n=max(Y,0);
%Z=mmp.n.Sparse.zeros(m,n);
Z = -Inf(X,Y);%Sometimes its preferrable to have full tops to sparse bottoms
return%Z
