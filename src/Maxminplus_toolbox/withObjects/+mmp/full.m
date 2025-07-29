function X=full(S)
% X=mmp.full(S) Create a full matrix [X] from any type of maxplus or
% minplus conventional matrix [S]. Works for any type of maxplus
% convention. 

% original coding: CPM
% Mmp adaptation: FVA 24/02/2009
% object conversion: FVA 16/03/2009

error(nargchk(1,1,nargin));

%% Actual 
[m,n]=size(S);
if isa(S,'mmp.Sparse')
%if isfield(S,'xpsp')%if sparse...
    X=full(S);%%% This doesn't work! You should invoke 'double' to fill a sparse matrix.
elseif isa(S,'double')%full or sparse
    if issparse(S)%in maxplus or minplus convention
        if any(S==-eps)%in minplus
            X=Inf(m,n);
            X(logical(S))=S;
            X(S==-eps)=0.0;
        else%it should be maxplus
            X=-Inf(m,n);
            X(logical(S))=S;
            X(S==eps)=0.0;
        end
    else%full
        X=S;
    end
else
    error('p:full','wrong input type');
end
%% return value
return%X
