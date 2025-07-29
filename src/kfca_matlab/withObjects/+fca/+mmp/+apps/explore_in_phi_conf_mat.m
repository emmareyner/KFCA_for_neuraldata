% fca.mmp.apps.explore_in_phi_conf_mat()
%
% A script to explore a multiway classification experiment
% using structural context analysis on its confusion
% matrix. 
%
% You have to invoke this script in the directory where
% the data are or a script to generate them.
% the data to be read from data.mat are:
% - rawcounts: a g x m matrix of confusion counts
% - G : a g x1 cell of input stimuli labels
% - M: an m x 1 cell of output percept labels
% - name: a name for the experiment
%
% If data.mat is not in the invokation dir, the script tries to create it
% by invoking configure.m, which is a user-provided script that should
% create data.mat with the data specified above.
%
% After processing, all information about the confusion context remains
% in Kout.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define experiments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    load data.mat%G, M, name, rawcounts
catch ME
    fprintf('File data.mat with all files not found. Run configure.m to generate it.\n');
end

%% Build the Pointwise Mutual Information Matrix
%and the context

% this is for confusion matrices.
conf_mat = pmi(rawcounts);%Retain only the PMI matrix.

%Build the context
K = fca.mmp.Context(G,M,conf_mat,name);

%% Explore the contexts
outdirbase='structural_contexts';
%Kpre = fca.Precontext(G,M,name);%ABSTRACT!!

% %% test indexing on mmp.l.Context
% Ka.R.Reg
% Ka.R([1 2],[1 2])%OK, returns an mmp.l.Double
% Ka.R(logical([1 1 0]), logical([1 1 0]))

%%% Explore in phi
Kout = explore_in_phi(K,outdirbase);
