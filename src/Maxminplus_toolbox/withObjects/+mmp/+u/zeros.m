function [Z]=zeros(X,Y)
%     mmp.u.zeros(N) is an N-by-N matrix of mmp.u.zeros.
%  
%     mmp.u.zeros(M,N) or mmp.u.zeros([M,N]) is an M-by-N matrix of mmp.u.zeros.
%  
%     mmp.u.zeros(SIZE(A)) is the same size as A and all mmp.u.zeros.
%  
%     mmp.u.zeros with no arguments is the scalar -Inf.
%  
%     Note: The size inputs M, N, and P... should be nonnegative integers. 
%     Negative integers are treated as 0.
%  
%     See also mmp.u.eye, mmp.u.ones, mmp.x.zeros, mmp.x.eye, mmp.x.ones.

% FVA: 24/02/09
switch nargin
    case 0
        Z = Inf;%Because of function documentation
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
            error('mmp:u:zeros','Input parameter configuration not allowed')
        end
    case 2
        if ~isscalar(X) || ~isscalar(Y)
            error('mmp:u:zeros','Input parameter configuration not allowed');
        end
    otherwise
        error('mmp:u:zeros','Wrong number of input parameters');
end
m=max(X,0);n=max(Y,0);
Z = mmp.n.Sparse(sparse(m,n));%create empty minplus
%Z.Xpsp = false;
return%Z
