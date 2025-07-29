function [PI,Pxy,MI,Hxy,WPI] = pmi(N)
% pointwise mutual information operator [I,Pxy,MI,Hxy,WPI] = pmi(N)
%
% From a real counts matrix, [N], describing the occurrence of joint events of two
% different phenomena, this obtains the pointwise mutual information [I] in bits of
% those events, which is the logarithm (base 2) of the quotients of the joint
% probability by the marginals. 
%
% The MLE of the joint probability distribution [Pxy] can also be requested
% and then it is easy to obtain the mutual information [MI] and the joint
% entropy [Hxy].
% 
% CAVEAT: if N is sparse I is returned in the maxplus sparse convention:
% - a blank in N represents -Inf.
% - an eps in N represents 0.
% - all other numbers represent themselves.
%
% The (average pointwise) mutual information (MI) can be easily calculated
% from these, as well as other statistics. Remember that 0*log 0 = 0 by
% convention.
%  WPI = Pxy.*I;
%  WPI(Pxy==0)=0;%avoids NaN in 0*log 0
% Hence the average mutual information MI is:
%  MI = sum(sum(WPI))
%
% THis works for either sparse of full N matrices.

%Build the contingency matrix, then the MLE estimate of the joint
%probabilites.
Ni = sum(N,2);%column of row marginal counts
Nj = sum(N,1);%row of column marginal counts
Nt = sum(Ni);%either the sum of the row or columns marginal counts.
NiNj = Ni* Nj;
PI = N * Nt ./ NiNj;%pointwise quotient of probs.
if nargout > 1, Pxy=N/Nt; end%Store for calculating average

%When nans are generated, some adjustements are required
%Consider Nij=0, Ni=0, Nj=0, when Nt -> Inf. The quotient goes to Inf, and the
%counts are indiscernible from as many zeroes. However, when only two of
%the counts go to zero, Nij must vanish more quickly than Ni (or Nj), hence
%the quotient goes to zero.

mynans = isnan(PI);%This should be sparse!
if any(any(mynans))
    [in,jn]=find(mynans);
    both = (Ni(in,1) + Nj(jn)')==0;%both counts are zero: these go to Inf.
    sP = size(PI);
    PI(sub2ind(sP,in(both),jn(both)))=Inf;
    PI(sub2ind(sP,in(~both),jn(~both)))=0;%otherwise, the quotienf goes to 0.
end
%Now work out the real matrix

if issparse(N)
    % This is the maxplus encoding of sparse matrices:
    % - a blank represents -Inf
    % - eps represents 0.
    % - all other numbers represent themselves.
    myeps=(PI==1);
    PI = spfun(@log2,PI);%Avoid going over whole ranges of zeroes.
    PI(myeps)=eps;
else
    PI = log2(PI);%This is bad for matrices with many zeroes.
end
if nargout > 2%Calculate also MI
    nulls = sparse(Pxy == 0);
    WPI = Pxy.*PI;%Weighted pointwise mutual info
    WPI(nulls)=0;%Dispose of 0*log 0
    MI = sum(sum(WPI));%The average of PMI is MI
    if nargout > 3%Calculate also joint entropy
        % 1. Calculate the joint entropy
        Hxy = Pxy .* log2(Pxy);
        Hxy(nulls) = 0;
        Hxy = -sum(sum(Hxy));
    end
end
return
