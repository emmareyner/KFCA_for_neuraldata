%% Define experiments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experiment number one!
%cd ~/05experimentos/confusion_matrices/animals
%load('animals.m')

%% Build the Pointwise Mutual Information Matrix
% this is for confusion matrices.
%conf_mat = pim(animals);
%outdirbase=sprintf('test_sweeping_phi');
%Build the context
%Kpre = fca.Precontext(G,M,name);%ABSTRACT!!

I=[5,3,0;2,3,1;0,2,11];
sI=length(I);
Dg=sum(I)'*ones(1,sI).*eye(sI);
Dm=sum(I,2)*ones(1,sI).*eye(sI);

G={'Dog','Cat','Rabbit'};
M={'dog?','cat?','rabbit?'};
conf_mat=log(inv(Dg)*I*inv(Dm));
conf_mat=[3.82157e-1,2.8523,-inf;-0.7378621,2.272438,-5.856696;-Inf,-1.249387,2.796319]*(10^-1);
name='animals';

Ka = fca.mmp.Context(G,M,conf_mat,name);

%% test indexing on mmp.l.Context
Ka.R
Ka.R([1 2],[1 2])%OK, returns an mmp.l.Double
Ka.R(logical([1 1 0]), logical([1 1 0]))

%% Explore in phi
outdirbase='/tmp';
Kout = explore_in_phi(Ka,outdirbase);
