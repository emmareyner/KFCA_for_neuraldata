function spX=spmpconvert(X)
%   S = SPARSEMP(X) converts a sparse or full matrix to sparse form by
%   squeezing out any -infinity elements: .Infinity terms will be represented
%   by zeros and zeros by eps
%
%spX = [X(:,1) X(:,2) log(X(:,3)./sum(X(:,3)))];
spX = X;
%Detect zeros and mutate to something small but diff to zero
i=find(X(:,3)==0.0);if ~isempty(i),spX(i,3)=eps;end
%Detext -Inf==mp_zero and mutate to zero
j=find(X(:,3)==mp_zero);if ~isempty(j),spX(j,3)=0;end
%Finally use the standard conversion algo.
spX=spconvert(spX);
return
