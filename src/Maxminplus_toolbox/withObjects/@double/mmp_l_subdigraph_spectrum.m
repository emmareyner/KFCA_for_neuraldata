function [Sp] = subdigraph_spectrum(comps,adj,cycles,A)
% function [Sp] = mmp.l.Spectrum.subdigraph_spectrum(comps,adj,cycles,A)
%
% A function to calculate the left and right spectra, i.e. eigenvalues
% and the bases of their left and right eigenspaces for a possibly
% reducible maxplus square matrix, [A] *with a singly connected subdigraph.*
%
% FVA: 2005-2009: Follows the Algorithm by Akian,Bapat and Gaubert, 2006,
% and Gaubert, 1992. Wang, 19??.
%
% Input:
% - [A] a non-empty (n x n) square maxplus matrix describing a singly
% connected subdigraph, i.e. that cannot be square-block diagonalized.
%
% - [comps]: a 1 x nC cell array of strongly connected components of [A].
% comps{c} is a row vector with the list of vertices in component {c}, also
% called a (connected) *class* of [A]. nC is the number of strongly
% connected components of A.
%
% - [adj]: an nC x nC matrix of booleans, the *adjacency* relation for the
% classes in the condensed graph. This is NOT an order relation but a
% covering. See Sp.order below for the transitive closure of this.
%
% - [cycles]: a 1 x nC array of arrays of cycles. cycles{c} is an array of
% cycles with vertices in component{c}. All cycles are simple, all
% different.
%
% Output:
% - [Sp] : the spectrum of the matrix. This is a structure storing the
% actual values of the left and right spectra:
%
%   - [comps]: this is just storing the input parameter [comps]
%   - [order]: the transitive closure of [adj]. [order(ci,cj)] says whether class
% ci is *upstream* from class c in the graph's class diagram. For classes
% that are not related, the ones with higher eigenvalue should come
% first. In fact, for each block,i, the i-th row of this matrix is
% describing the support of block i in terms of other blocks. Consult
% comps to find the actual nodes in each block.
%   - [cycles]: this is just storing input parameter [cycles]
%   - [lambdas] 1x n row matrix . lambdas(b) is the eigenvalue of the
% irreducible submatrix of [A] related to class n. lambdas(1) is the
% rho_max of the whole matrix. Note that the number of eigenvalues is
% bounded by the number of classes.
%   - [ccycles] a row structure coindexed with the [lambdas] matrix
%   including at [ccycles{b}] a subsequent row structure coindexed with
%   the *critical circuits* in component [b]. For each critical circuit
%   its vertices are listed as a row vector. To obtain the critical cycles
%   do: cns=[];
%       cellfun(@(cns,ccell) (cellfun(@(cc) cns=[cns cc(1:end-s)],ccell),
%                Sp.ccycles))
%   - [levs] a row structure co-indexed with the [lambdas] matrix including at
% [levs{b}] the left eigenvectors of the eigenspace of those eigenvalues.
%
%   - [revs] a column structure co-indexed with the [lambdas] matrix
%   including at [revs{b}] the right eigenvectors of the eigenspace of
%   those eigenvalues.
%
% The following eigenvector equations have to be explored  on a per-cycle
% basis:
% mmp.l.multi(Sp.levs{c},A) == mmp.l.multi(Sp.lambdas(c),Sp.levs{c})
% mmp.l.multi(A,Sp.revs{c}) == mmp.l.multi(Sp.revs{c},Sp.lambdas(c))
%
% Note that the components, aka blocks, are in FNF. If you need to order
% them in descending or ascending eigenvalue order do something like:
%       [olambdas,iblocks]=sort(Sp.lambdas,'descend')
% And then process blocks accordingly. This is what mmp.l.all_evs.m tries to
% do.
%
% See also: mmp.l.Double.eigenspace_irreducible2, mmp.l.spectra2, mmp.l.crc_scc_cycles.m
% mmp.l.all_evs.m, mmp.l.ordered_subgraph_spectrum
%
% Author: fva 03/12/07
% Doc:    fva 10/01/08

%% Check input values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check input values
error(nargchk(4,4,nargin));

%% Parameter testing and initialization
if ~isa(A,'mmp.l.Double')
    error('mmp:l:Spectrum:subdigraph_spectrum','Wrong input class');
end
Sp = mmp.l.Spectrum();
%Sanity check!
%m = test_square(A);
%TODO: transitive closure????
% if ~islogical(order)
%     order=(order==0);%Transform into binary matrix: easier to operate on!
% end
%CAVEAT: the original adjacency is lost here!
%order=tclosure(order);%this uses @logical/tclosure
Sp.order = tclosure(adj);%Store *logical* order tclosure
%Sanity check!
if any(any(tril(Sp.order,-1))),
    error('mmp:l:Spectrum:subdigraph_spectrum','Non-fnf ordered subgraph!');
end
%The graph is not in (upper) Frobenius normal form.
Sp.comps = comps;%Store blocks
Sp.cycles = cycles;%Store cycles


%% Indices
%%%
%%% Since matrices are being analyzed in terms of:
%%% - crc: completely reducible components (disconnected subdigraphs)
%%% - scc: strongly connected components (strongly connected subdigraphs)
%%% three levels of referencing nodes (and the rest of elements) of a
%%% matrix and its induced subdigraph can be discerned:
%%% - the *global level* with node names referring to row and columns
%%% indexed in the overall matrix, i.e. from 1:n where n is the dim of A
%%% - the *local or crc level* with node names referring to row and columns
%%% indexed in the submatrix of the crc, i.e. from 1:m where m is the dim
%%% of the submatrix corresponding to the crc being analyzed.
%%% - the *microlocal or sccs level* with node names referring to row and
%%% columns indexed in the submatrix of the sccs being analyzed.1:p_m
%%% being scc p, in crc m.
%%%
%%% The following are 
%%% For spectrum Sp,
%%%   - Sp.comps stores a 1:p_m cell array of node lists for each scc, hence
%%%   Sp.comps{p_m} is a mapping *from micro-local to global*
%%%   - Sp.nodes stores a (1,m) array with the *global ids* of the m nodes
%%%   in the local crc. Their identities go from 1:m, hence this is a
%%%   mapping *from local to global* identifiers.
%%%   - Sp.g2l stores a global to local mapping (the inverse of Sp.nodes).
%%%   This should be sparse.
%%%   - Sp.g2ml, stores a global to micro local mapping. Should also be
%%%   sparse (the inverse of Sp.comps).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Note that a permutation to put the part of A referred to by blocks in
%UFNF can be obtained by concatenating the nodes in [comps].
Sp.nodes=cell2mat(comps);%This is the permutation AND the mapping!
m=size(Sp.nodes,2);%size of the LOCAL vertex set.
%AuFNF=A(Sp.nodes,Sp.nodes);%i.e. this is, in block form, upper FNF

% CAVEAT: for the rest of the computations we should use as vertices in
%this spectrum 1:m. The following is an inverted index to find quickly
%the local node wrt the global node. Sp.nodes acts as the global to
%local index.
[snodes,isupp]=sort(Sp.nodes);
Sp.g2l=sparse(1,m);
Sp.g2l(snodes)=isupp;%Local to global mapping.
%%% For n_crc==1, this is equal to Sp.nodes

%global to micro-local node translation, to be filled during execution
Sp.g2ml=sparse(1,m);
%convert=@(cy) full(Sp.g2ml(cy));%WRONG, because Sp.g2ml is bound to empty!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Memory catering for global vars
% Define spectral structure holders
%nC=number of classes, aka s.m.c.s's, aka number of totally connected
%components of this subgraph, sccs
nC=size(comps,2);
Sp.ec_below(1:nC)=false;%wheter sccs [c] is eclipsed in the right spectrum
Sp.ec_above(1:nC)=false;%wheter sccs [c] is eclipsed the left spectrum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%structures for the:
quasi_inverses=cell(1,nC);%Quasi inverses for sccs
Sp.lambdas=zeros(1,nC);%maximum cycle means for sccs
Sp.ccycles=cell(1,nC);%Critical cycles for sccs

%% 1. Detect lambdas, critical cycles and quasi_inverses
% CAVEAT: for the rest of the computations we should use as vertices in
% Sweep over components
for c=1:nC
    if Sp.order(c,c)%irreducible component: find infos.
        compsc=comps{c};%sccs nodes
        Sp.g2ml(compsc)=1:size(compsc,2);%global to micro local conversion
        cyclesc=cycles{c};
        %map critical cycles from global to micro local.
        mlcycles=cellfun(@(cy) full(Sp.g2ml(cy)),cyclesc, 'UniformOutput',false);
        [quasi_inverses{c},Sp.lambdas(c),ccindex] =...
            mmp.l.Double.eigenspace_irreducible2(mlcycles,A(compsc,compsc));
%         %Ac=subsref(A,substruct('()',{compsc,compsc}));
%         [quasi_inverses{c},Sp.lambdas(c),ccindex] =...
%             mmp.l.Double.eigenspace_irreducible2(mlcycles,...
%             subsref(A,substruct('()',{compsc,compsc})));
        % The cycles are expressed relative to the local matrix... 
        Sp.ccycles{c}={cyclesc{ccindex}};%change to global numbering
        % iterate over critical cycles to change them to original nodes.
        % Allocate space for left and right eigenvalues
        for cy=1:size(ccindex,2)%Go over critical cycles
            %Sp.cycles{c}{cy}=compsc(lccycles{cy});
            cn=Sp.ccycles{c}{cy}(1:end-1);%# cnodes 1 less than cycle size
            Sp.cnodes{c}{cy}=cn;
            sizev=size(cn,2);
            %Maybe do this later!
            Sp.revs{c}{cy}=mmp.l.zeros(m,sizev);%These will be x.sparse!
            Sp.levs{c}{cy}=mmp.l.zeros(sizev,m);
        end
    else%~Sp.order(c,c), component with lambda==mmp.l.zero
        %The mmp.l.zero eigenvalue is posited in Bapat, Rhagavan,
        %mmp. 967. Theorem 2.1 and also in Gaubert, 92. prommp. 2.2.3.
        quasi_inverses{c}=mmp.l.one();
        Sp.lambdas(c)=mmp.l.zero;
        Sp.ccycles{c}={};%This is the reason why order(c,c)==false
        Sp.cnodes{c}=[];
        %The left and right eigenvectors will be free
        Sp.levs{c}{1}=mmp.l.zeros(m,1);
        Sp.revs{c}{1}=mmp.l.zeros(1,m);
    end
end%for c=1:nC
%Sp.lambdas=mus;%Store the maximal cycle means as eigenvalues

%With supports, the same distinctions apply.
%% b.3) Build support for each *different eigenvalue*,
% is this the transitive, symmetric closure?
csupp= Sp.order|Sp.order';%class support in terms of classes
csize=cellfun(@(c) size(c,2),comps);%Class sizes

%%Do all cycles for components with the same mu at the same time.
for lambda=sort(unique(Sp.lambdas),'descend')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Build the extended quasi inverse [mat] for the classes with
    % such lambda.
    %%% CAVEAT: unless it is built using the structure of the
    % [order] matrix, this recipe for quickly building quasi inverses won't
    % work. This entails working on classes for supports, etc.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    inrange= (Sp.lambdas==lambda);%find components with such lambda
    %Find Lambda's local Class SUPPort upwards and downwards
    lcsupp = any(csupp(inrange,:),1);

    %%find eigenvector global support (non-null coordinates) and allocate
    gsupp=[comps{lcsupp}];%this supplants cell2mat
    %%make a microlocal2global mapping
    g2ml=sparse(1,m);
    g2ml(gsupp)=1:size(gsupp,2);%TODO: make mapping sparse

    %Build matrix closure for classes for this lambda IN CLASS LOCAL TERMS
    %mat=mmp.l.div(A(gsupp,gsupp),lambda);%submatrix corrected by lambda
    mat=mrdivide(A(gsupp,gsupp),lambda);
    %CAVEAT: if lambda==mmp.l.zero, then mat==mpm_zero==Inf everywhere!
    % if lambda==mpm_zero, then mat===mmp.l.zero==-Inf everywhere!
    %mat2=mmp.u.mtimes(A(gsupp,gsupp),-lambda);%Debugged: same result as before
    %SO FAR DEBUGGED

    %lsupp stores, incrementally, the range of coordinate support for each
    %class for this eigenvalue in LOCAL TERMS.
    %ssupp is the size of support
    %ssupp=0;%%Size of support so far
    mlsupp=false(size(gsupp));%incremental microsupport
    for c=find(lcsupp)%at least one class is in here,
        %lsupp=ssupp+(1:csize(c));%indices on mat for class c
        lsupp=g2ml(comps{c});
        %calculate the quasi-inverse to be inserted.
        if inrange(c)%if this is a "lambda" class, work is done
            mat(lsupp,lsupp)=quasi_inverses{c};
        else%work still to be done: findd transitive closure
            mat(lsupp,lsupp)=tclosure(mat(lsupp,lsupp));
%             mat(lsupp,lsupp)=...
%                 mtimes(mat(lsupp,lsupp),...
%                 trclosure(mat(lsupp,lsupp)));
        end
        %%The upper left-hand corner is to be calculated with the
        %stars of the diagonal blocks after well-known formula.
        %if ssupp~=0
        if any(mlsupp)
            m11star=rclosure(mat(mlsupp,mlsupp));
            m22star=rclosure(mat(lsupp,lsupp));%find star.
            mat(mlsupp,lsupp)=...
                mtimes(m11star,mtimes(mat(mlsupp,lsupp),m22star));
        end
        mlsupp(lsupp)=true;
        %ssupp=ssupp+csize(c);
    end
    %On exit, lsupp has the support on LOCAL TERMS

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%Go over components whose mean is lambda to extract left and right
    % eigenvectors.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    lsupp=logical(sparse(1,m));
    %lsupp=false(1,m);
    lsupp(Sp.g2l(gsupp))=true;%lsupp The egv support in LOCAL terms.
%     %global to microlocal mapping function
%     g2ml(gsupp)=1:ssupp
    for class=find(inrange)
        %Find whether they are eclipsed from above or below to deal
        %with non-finite support.
        Sp.ec_below(class)=(max(Sp.lambdas(Sp.order(:,class)')) > lambda);
        Sp.ec_above(class)=(max(Sp.lambdas(Sp.order(class,:))) > lambda);
        %In each critical cycle, the r-evs are all multiples of
        %each other and likewise for l-evs, but we collect them
        %anyway, except if their multiplier is the UNIT element (0)
        thesecnodes=Sp.cnodes{class};
        for cy=1:size(thesecnodes,2)%number of ccycles
            insupp=g2ml(thesecnodes{cy});
%             insupp=false(size(gsupp));
%             %                 %insupp(g2l(thesecycles{cy}))=true;
%             %                 %%Locate the critical nodes in the support.
%             %                 thesecnodes=thesecycles{cy}(1:end-1);
%             %                 Sp.cnodes{class}{cy}=thesecnodes;%Store them for future use
%             %                 for node=thesecnodes,
%             %                     insupp= insupp|(gsupp==node);
%             %                 end
%             insupp(g2ml(thesecnodes))=true;
            %%Fill with mpm_zero==Inf when classes are eclipsed
            Sp.revs{class}{cy}(lsupp,:)=mat(:,insupp);
            if Sp.ec_below(class)
                Sp.revs{class}{cy}(~lsupp,:)=Inf;
            end
            %%Fill with mpm_zero==Inf when classes are eclipsed
            Sp.levs{class}{cy}(:,lsupp)=mat(insupp,:);
            if Sp.ec_above(class)
                Sp.levs{class}{cy}(:,~lsupp)=Inf;
            end
        end%for cy=1:size(thesecnodes,2)%number of ccycles
    end%for class=find(inrange)
end%for lambda=sort(unique(mus),'descend')
%end%switch
%% End processing
return%Sp
