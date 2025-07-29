function [PMI, WPMI, I, PP, NWPMI, NPMI] = pmi(C)

% PMI Point-wise mutual information of a (count) matrix, C
% WI Weighted PMI
% I Mutual Information
% PP A posteriori log probability matrix

%Dimensions
[p,m]=size(C);

%Probabilities computation
ncounts=sum(sum(C));
priors=sum(C,2)/ncounts;
marg_post= sum (C, 1)/ncounts;
C=C/ncounts

%Point-wise mutual information
PMI=C./(priors* marg_post);

%Right stochastic (A posteriori prob)
PP=C./(priors*ones(1,m));

%Solution of the indetermined values
i=find(priors==0);
j=find(marg_post==0);
PMI(find(isnan(PMI)))=0;
if (length(i)>0) & (length(j)>0)
    ind=(j-1)*p+i;
    PMI(ind)=Inf;
end



PMI=log2(PMI);
%PP=log2(PP);

Hxy=-C.*log2(C);
Hxy(C==0)=0;
Hxy=sum(sum(Hxy))
NPMI=PMI-Hxy;

%Weighted PMI
WPMI=C.*PMI;
WPMI(find(isnan(WPMI)))=0;

%Mutual info
I=sum(sum(WPMI));

%Normalized WPMI
%NWPMI=(WPMI./(ones(p,1)*(-marg_post.*log2(marg_post))));
NWPMI=-2*WPMI/(max(priors.*log2(priors))+max(marg_post.*log2(marg_post)));