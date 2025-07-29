function [Z]=zeros(X,Y)
%     mmp.l.zeros(N) is an N-by-N matrix of mmp.l.zeros == -Inf
%  
%     mmp.l.zeros(M,N) or mmp.l.zeros([M,N]) is an M-by-N matrix of mmp.l.zeros.
%  
%     mmp.l.zeros(SIZE(A)) is the same size as A and all mmp.l.zeros.
%  
%     mmp.l.zeros with no arguments is the scalar -Inf.
%  
%     Note: The size inputs M, N, and P... should be nonnegative integers. 
%     Negative integers are treated as 0.
%  
%     See also mmp.l.eye, mmp.l.ones, mmp.l.zeros, mmp.l.eye, mmp.l.ones.

% FVA: 24/02/09
switch nargin
    case 1
        if isscalar(X)%square zero matrix
            Y=X;
        elseif length(X)==2%probably dimensions in a 1x2 matrix
            %not scalar, but matrix
            %X(full(X<0))=0;%neg. dimensions go to 0.
            Y=X(1,2);
            X=X(1,1);
        else
            error('mmp:x:sparse:zeros','input parameter configuration not allowed')
        end
    case 2
        if ~isscalar(X) || ~isscalar(Y)
            error('mmp:x:sparse:zeros','input parameter configuration not allowed');
        end
    otherwise
        error(nargchk(1,2,nargin))
end
m=max(X,0);n=max(Y,0);
Z = mmp.x.sparse(m,n);%create empty maxplus
return%Z