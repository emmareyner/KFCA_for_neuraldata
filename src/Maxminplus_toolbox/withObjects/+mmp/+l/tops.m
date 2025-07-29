function [Z]=tops(X,Y)
%     mmp.l.tops(N) is an N-by-N matrix of mmp.l.tops == Inf
%  
%     mmp.l.tops(M,N) or mmp.l.tops([M,N]) is an M-by-N matrix of mmp.l.tops.
%  
%     mmp.l.tops(SIZE(A)) is the same size as A and all mmp.l.tops.
%  
%     mmp.l.tops with no arguments is the scalar Inf.
%  
%     Note: The size inputs M, N, and P... should be nonnegative integers. 
%     Negative integers are treated as 0.
%  
%     See also mmp.l.eye, mmp.l.ones, mmp.l.zeros, mmp.l.eye, mmp.l.ones.

% FVA: 23/09/10
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
            error('mmp:l:tops','Input parameter configuration not allowed')
        end
    case 2
        if ~isscalar(X) || ~isscalar(Y)
            error('mmp:l:tops','Input parameter configuration not allowed');
        end
    otherwise
        error('mmp:l:tops','Wrong number of input parameters');
end
%m=max(X,0);n=max(Y,0);
%Z=mmp.n.Sparse.zeros(m,n);
Z = Inf(X,Y);%Sometimes its preferrable to have full tops to sparse bottoms
return%Z
