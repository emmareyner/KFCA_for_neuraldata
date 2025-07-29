%Program for calculating the Adjusted Mutual Information (AMI) between
%two clusterings, tested on Matlab 7.0 (R14)
%(C) Nguyen Xuan Vinh 2008-2009
%Contact: n.x.vinh@unsw.edu.au 
%         vthesniper@yahoo.com
%--------------------------------------------------------------------------
%*Input: cluster label of the two clusterings in two vectors
%        eg: true_mem=[1 2 4 1 3 5]
%                 mem=[2 1 3 1 4 5]
%        Cluster labels are coded using interger 
%*Output:NMI: normalize mutual information (NMI_max)
%        AMI: adjusted mutual information  (AMI_max)
%        AVI: adjusted variation of information 
%        EMI: expected mutual information
%--------------------------------------------------------------------------
%References: 
% 1. 'A Novel Approach for Automatic Number of Clusters Detection based on Consensus Clustering', 
%       N.X. Vinh, and Epps, J., to appear in Proc. IEEE Int. Conf. on 
%       Bioinformatics and Bioengineering (Taipei, Taiwan), 2009.
% 2. 'Information Theoretic Measures for Clusterings Comparison: Is a
%	    Correction for Chance Necessary?', N.X. Vinh, Epps, J. and Bailey, J.,
%	    submitted to the 26th International Conference on Machine Learning (ICML'09)
% 3. 'Information Theoretic Measures for Clusterings Comparison: Variants, Properties, 
%       Normalization and Correction for Chance', N.X. Vinh, Epps, J. and
%       Bailey, J., in preparation.

%Modified CPM: changed the inputs to admit the contingency table insted of
%the two clusterings.


%function [NMI,AMI,AVI,EMI]=ANMI(true_mem,mem)
function [NMI,AMI,AVI,EMI,PAMI,PNMI]=ANMI(T)


%calculate the contingency table
%K1=max(true_mem);
%K2=max(mem);
%n=length(mem);N=n;


%identify the missing labels
%list_t=ismember(1:K1,true_mem);
%list_m=ismember(1:K2,mem);

%calculating the Entropy
%NK1=zeros(1,K1);
%NK2=zeros(1,K2);
%for i=1:N
%    NK1(true_mem(i))=NK1(true_mem(i))+1;
%    NK2(mem(i))=NK2(mem(i))+1;
%end
%NK1=NK1(list_t);%deleting the missing labels
%NK2=NK2(list_m);

%HK1=-(NK1/n)*log(NK1/n)'; %calculating the Entropies
%HK2=-(NK2/n)*log(NK2/n)';
HK1=entropy(sum(T,1)/sum(sum(T)));
HK2=entropy(sum(T,2)/sum(sum(T)));


%building contingency table
%T=Contingency(true_mem,mem);
%T=T(list_t,:);%deleting the missing labels
%T=T(:,list_m);

%update the true dimensions
[K1 K2]=size(T);
n=sum(sum(T));N=n;

%calculate the MI (unadjusted)
%MI=0;
%for i=1:K1
%    for j=1:K2
%        if T(i,j)>0 MI=MI+T(i,j)*log(T(i,j)*n/(NK1(i)*NK2(j)));end;
%    end
%end
%MI=MI/n
[PMI, WPMI, MI, PP, NWPMI] = pmi(T);

%a=NK1;b=NK2;
a=sum(T,2);
b=sum(T,1);
%AB=a'*b;
AB=a*b;

% MI=sum(sum(T.*mylog(T*n./AB)))/n;
%-------------correcting for randomness---------------------------
%Changed from decimal to base 2 log
E3=(AB/n^2).*log2(AB/n^2);

EPLNP=zeros(K1,K2);
%Changed from decimal to base 2 log
LogNij=log2([0:min(max(a),max(b))]/N);
for i=1:K1
    for j=1:K2
        %nij=max(1,a(i)+b(j)-N);
        nij=max(0,a(i)+b(j)-N);
        X=sort([nij N-a(i)-b(j)+nij]);
        if N-b(j)>X(2)
            nom=[[a(i)-nij+1:a(i)] [b(j)-nij+1:b(j)] [X(2)+1:N-b(j)]];
            dem=[[N-a(i)+1:N] [1:X(1)]];
        else
            nom=[[a(i)-nij+1:a(i)] [b(j)-nij+1:b(j)]];       
            dem=[[N-a(i)+1:N] [N-b(j)+1:X(2)] [1:X(1)]];
        end
        p0=prod(nom./dem)/N;
        if nij==0
            EPLNP(i,j)=0;
        else
            EPLNP(i,j)=nij*LogNij(nij+1)*p0;
        end
        p1=p0*(a(i)-nij)*(b(j)-nij)/(nij+1)/(N-a(i)-b(j)+nij+1);  
        
        %for nij=max(1,a(i)+b(j)-N)+1:1:min(a(i), b(j))
        for nij=max(0,a(i)+b(j)-N)+1:1:min(a(i), b(j))
            EPLNP(i,j)=EPLNP(i,j)+nij*LogNij(nij+1)*p1;
            p1=p1*(a(i)-nij)*(b(j)-nij)/(nij+1)/(N-a(i)-b(j)+nij+1);            
        end
    end
end


EMI=sum(sum(EPLNP))-sum(sum(E3));
PAMI=PMI-EPLNP;
AMI=(MI-EMI)/(max(HK1,HK2)-EMI);
AVI=2*(MI-EMI)/(HK1+HK2-2*EMI);

%VI=HK1+HK2-2*MI;
NMI=MI/max(HK1,HK2);
PNMI=PAMI/max(HK1,HK2);
%NMI=MI/sqrt(HK1*HK2);
% fprintf('Mutual information= %f  VI= %f\n',MI,VI);

%---------------------auxiliary functions---------------------
function Cont=Contingency(Mem1,Mem2)

if nargin < 2 || min(size(Mem1)) > 1 || min(size(Mem2)) > 1
   error('Contingency: Requires two vector arguments')
   return
end

Cont=zeros(max(Mem1),max(Mem2));

for i = 1:length(Mem1);
   Cont(Mem1(i),Mem2(i))=Cont(Mem1(i),Mem2(i))+1;
end

            