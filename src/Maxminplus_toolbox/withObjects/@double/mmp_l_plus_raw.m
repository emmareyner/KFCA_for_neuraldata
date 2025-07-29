function [Z]=mmp_l_plus_raw(X,Y)
%  oplusl   Maxplus lower addtion operation
%     mmp_l_plus(X,Y) lower-adds matrices X and Y.  X and Y must have the same
% The result is full if either is full

if ~issparse(X)%Full S
    sp = false;
    if issparse(Y), Y = mmp_x_full(Y); end
else%Sparse X
    if ~issparse(Y)
        sp = false;
        X = mmp_x_full(X);
    else
        sp = true;
    end
end
%postcondition: both are sparse or both non-sparse
if sp
    %this is the max in sparse representation
    nzX=(X~=-Inf);nzY=(Y~=-Inf);
    Z=X;%Store at locii where Y is zero in Xs representation
    %Store at locii where both are zero
    nnz=nzX & nzY;
    Z(nnz)=max(Z(nnz),Y(nnz));%Store at locii where both are non-zero
    zXnzY=~nzX & nzY;
    Z(zXnzY)=Y(zXnzY);%Store at locii where X is zero and Y non-zero
else
    Z=max(X,Y);
end

return
