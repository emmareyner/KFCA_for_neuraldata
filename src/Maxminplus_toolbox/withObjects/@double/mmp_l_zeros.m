function [Z]=mmp_l_zeros(X,Y)
%     mmp.l.Double..zeros(N) is an N-by-N matrix of mmp.l.Double..zeros == -Inf
%  
%     mmp.l.Double..zeros(M,N) or mmp.l.Double..zeros([M,N]) is an M-by-N matrix of mmp.l.Double..zeros.
%  
%     mmp.l.Double..zeros(SIZE(A)) is the same size as A and all mmp.l.Double..zeros.
%  
%     mmp.l.Double..zeros with no arguments is the scalar -Inf.
%  
%     Note: The size inputs M, N, and P... should be nonnegative integers. 
%     Negative integers are treated as 0.
%  
%     See also mmp.l.Double..eye, mmp.l.Double..ones, mmp.l.Double.zeros,
%     mmp.l.Double..eye

% FVA: 24/02/09
switch nargin
    case 0
        Z = -Inf;
        return%early termination
    case 1
        if isscalar(X)%square zero matrix
            Y=X;
        elseif length(X)==2%probably dimensions in a 1x2 matrix
            %not scalar, but matrix
            %X(full(X<0))=0;%neg. dimensions go to 0.
            Y=X(1,2);
            X=X(1,1);
        else
            error('Double:mmp_l_zeros','input parameter configuration not allowed')
        end
    case 2
        if ~isscalar(X) || ~isscalar(Y)
            error('Double:mmp_l_zeros','input parameter configuration not allowed');
        end
    otherwise
        error(nargchk(1,2,nargin))
end
m=max(X,0);n=max(Y,0);
Z = -Inf(m,n);%create empty maxplus
return%Z