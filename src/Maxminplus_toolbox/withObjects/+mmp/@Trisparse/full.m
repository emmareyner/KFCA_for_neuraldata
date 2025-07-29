function X=full(S)
% X=full(S) Create a full double matrix [X] from any type of maxplus or
% minplus conventional matrix [S]. Works for any type of maxplus
% convention.
% This primitive should actually be called 'double' q.v.

%% Actual 
[m,n]=size(S);
if isa(S,'mmp.x.sparse')
    X=-Inf(m,n);%create matrix
    X(S.Topp)=Inf;%Put in tops
else%sparse in minplus convention
    X=Inf(m,n);%Create matrix
    X(S.Topp)=-Inf;%Put in tops
end
X(S.Unitp)=0.0;%put in zeroes
regnu=logical(S.Reg);%regular not units
X(regnu)=S.Reg(regnu);%put in regulars not units
%X=mmp.Double(X);
return%X
