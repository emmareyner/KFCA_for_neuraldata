function [ wPMIxy,Pxy] = weightedPMI( Pxy )
% function [ wPMI ] = weightedPMI( Pxy )
% function [ wPMI,Pxy ] = weightedPMI( Nxy )
%
% A function to work out the weighted pointwise mutual information [wPMIxy] 
% in a slightly more efficient way, specially for sparse distributions.
%
% Note that the input distribution [Nxy](on counts, probabilities) will be
% re-normalized and returned, hence this primitive can be supplied with a
% distribution over counts and it will return a probability distribution,
% as well [Pxy] as in the second usage suggested.
%
% Author: FVA, 01, 2014

% CAVEAT: The following might not be TRUE!
% from wPMIxy and Pxy you can obtain the pointwise mutual information as:
% PMIxy = wPMIXxy ./ Pxy;%Watch out, there will be infinites in here!
% PMIxy(Pxy == 0) = -Inf
%
error(nargchk(1,1,nargin))
%error(nargchk(1,1,nargout))%Don't do the expensive calculation if it is not going to be used

%renormalize P to include count matrices
N = full(sum(sum(Pxy)));
Pxy = Pxy/N;%P is now a probability distribution
%marginalize
Px = sum(Pxy,2);
Py = sum(Pxy,1);
wPMIxy = Pxy ./ (Px * Py);%may generate NaNs
Lx = Px == 0;
if any(Lx); wPMIxy(Lx,:) = 0; end
Ly = Py == 0;
if any(Ly); wPMIxy(:,Py' == 0) = 0; end
%PMIxy(isnan(PMIxy)) = 0;%dispose of them!TOO SLOW!
%clear('Px','Py')
if issparse(Pxy)
    %Only apply the log at the non-zero points, since the wPMI is going to
    %be null at these!
    wPMIxy = spfun(@log2, wPMIxy);%this is now PMIxy with zeros for Inf.
else
    wPMIxy = log2(wPxy);%this is now PMIxy
end
wPMIxy = Pxy .* wPMIxy;
%wPMIxy(Pxy == 0) = 0;%preempt NaNs
%Correct incurred Inf * 0 = NaNs in full matrices
%if ~(issparse(wPMI)); wPMI(isnan(wPMI)) = 0; end
end