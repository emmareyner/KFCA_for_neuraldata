function [S] = of_digraph(A,comps,adj,cycles)
% function [S,Aplus] = mmp.l.Sectrum.of_connected_digraph(A,comps,adj,cycles)
%
% A function to calculate the left and right spectra, i.e. eigenvalues
% and the bases of their left and right eigenspaces for a possibly
% reducible maxplus square matrix, [A] *with a single connected subdigraph
% (UFNF_1).
%
% if [Aplus] is requested, the transitive closure of A is worked out too.
%
% This revamped version tries to avoid calculation non-finite closures when
% they appear.
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
% connected components of A. Linearizing this array obtains the permuation
% that renders A in UFNF_1
%
% - [adj]: an nC x nC matrix of booleans, the *adjacency* relation for the
% classes in the condensed graph. This is NOT an order relation but a
% covering relation. See S.order below for the transitive closure of this.
%
% - [cycles]: a 1 x nC array of arrays of cycles. cycles{c} is an array of
% cycles with vertices in component{c}. All cycles are simple, all
% different.
%
% Output:
% - [S] : the spectrum of the matrix. This is a structure storing the
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
%                S.ccycles))
%   - [levs] a row structure co-indexed with the [lambdas] matrix including at
% [levs{b}] the left eigenvectors of the eigenspace of those eigenvalues.
%
%   - [revs] a column structure co-indexed with the [lambdas] matrix
%   including at [revs{b}] the right eigenvectors of the eigenspace of
%   those eigenvalues.
%
% The following eigenvector equations have to be explored  on a per-cycle
% basis:
% mmp.l.multi(S.levs{c},A) == mmp.l.multi(S.lambdas(c),S.levs{c})
% mmp.l.multi(A,S.revs{c}) == mmp.l.multi(S.revs{c},S.lambdas(c))
%
% Note that the components, aka blocks, are in FNF. If you need to order
% them in descending or ascending eigenvalue order do something like:
%       [olambdas,iblocks]=sort(S.lambdas,'descend')
% And then process blocks accordingly. This is what mmp.l.all_evs.m tries to
% do.
%
% See also: mmp.l.Sectrum.of_digraph, mmp.l.Sectrum.of_completely_disconnected_digraph,
% mmp.l.Sectrum.of_strongly_connected_digraph, digraph.crc_scc_cycles.m
% mmp.l.Sectrum.all_evs.m, mmp.l.Sectrum.UtSV
%
% Author: fva 03/12/07- 22/04/11
% Doc:    fva 10/01/08

%% Check input values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check input values
error(nargchk(4,4,nargin));

% %% Parameter testing and initialization
% if isa(A,'double')
%     if issparse(A)
%         error('mmp:l:Sectrum:of_connected_digraph','Direct sparse input not allowed to prevent formatting confusions. Use mmp.x.Sarse, etc.');
%     else
%         A = mmp.x.Sarse(A);
%     end
% elseif isa(A,'mmp.x.Sarse')%MX sparse encoding OK
%     %A = A.Reg;
% else
%     error('mmp:l:Sectrum:of_connected_digraph','Wrong input class');
% end
% %From now on A is mmp_x_sparse!!
% %spA = true;%FVA: KLUDGE

% %n = size(A,1);%Global node size!!! Don't need it! Don't trust it!
% %A flag to make comparisons quicker.
% returnAplus = nargout > 1;

%% Create spectrum structure and store glocal parameters to be kept
%S = mmp.l.Sectrum();
S = mmp.l.Spectrum.UFNF_1(A,comps,adj,cycles);
%CAVEAT: the original adjacency is lost here, supplanted by tclosure.
%order=tclosure(order);%this uses @logical/tclosure

%% CLASS RELATED INFO INITIALIZATION
nC=length(comps);
%nC=number of classes, aka s.m.c.s's, aka number of totally connected
%components of this subgraph, sccs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% S.lambdas=double(mmp.l.zeros(1,nC));%maximum cycle means for sccs
% S.ccycles=cell(1,nC);%Critical cycles for sccs

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
%%% For spectrum S,
%%%   - S.comps stores a 1:p_m cell array of node lists for each scc, hence
%%%   S.comps{p_m} is a mapping *from micro-local to global*
%%%   - S.nodes stores a (1,m) array with the *global ids* of the m nodes
%%%   in the local crc. Their identities go from 1:m, hence this is a
%%%   mapping *from local to global* identifiers.
%%%   - S.g2l stores a global to local mapping (the inverse of S.nodes).
%%%   This should be sparse.
%%%   - S.g2ml, stores a global to micro local mapping. Should also be
%%%   sparse (the inverse of S.comps).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CAVEAT: for the rest of the computations we should use as vertices in
%this spectrum 1:m.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Note that a permutation to put the part of A referred to by blocks in
% %UFNF_1 can be obtained by concatenating the nodes in [comps].
% S.nodes=cell2mat(comps);%This is the permutation AND the mapping!
% n = max(S.nodes);
% %n is not the real size of the global matrix, but it is as big as needs be
% %to include the highest node.
% %this is the size of the global matrices
% sizeA = size(A,1);%Don't really need to test for squareness
% m=size(S.nodes,2);%size of the LOCAL vertex set AND the local matrix.
% %AuFNF=A(S.nodes,S.nodes);%i.e. this is, in block form, upper FNF and
% %connected
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % The following is an inverted index to find quickly
% %the local node wrt the global node.
% %[snodes,isupp]=sort(S.nodes);
% S.g2l=sparse(1,n);%scrape some memory(?)
% %S.g2l(snodes)=isupp;%Global to local mapping.
% S.g2l(S.nodes)=1:m;%Global to local mapping.
% % Note that S.nodes acts as the local to global index.
% %%% CAVEAT: Only for n_crc==1, this is equal to S.nodes

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %global to micro-local node translation, to be filled during execution
% S.g2ml=sparse(1,n);
% %note that S.comps{c} acts as the micro-local to global index.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 1. Detect lambdas, critical cycles and metric_matrices
% % Define spectral structure holders
% metric_matrices=cell(1,nC);%Quasi inverses for sccs, only a temporary store
% % CAVEAT: for the rest of the computations we should use as vertices in
% % First sweep over components
for c = 1:nC
    S.spectra0{c}=mmp.l.Spectrum.UFNF_0.of_digraph(A,comps{c},cycles{c});
end
% for c=1:nC
%     compsc=comps{c};%sccs nodes
%     nN = size(compsc,2);%Number of nodes in component
% %    if S.order(c,c)%irreducible component: find infos.
%        S.g2ml(compsc)=1:nN;%global to micro local conversion
%         cyclesc=cycles{c};
%         %map critical cycles from global to micro local.
%         mlcycles=cellfun(@(cy) S.g2ml(cy),cyclesc, 'UniformOutput',false);
%         [S.lambdas(c),metric_matrices{c},ccindex] =...
%             mmp.l.Sectrum.of_strongly_connected_digraph(A(compsc,compsc),mlcycles);
%         % The cycles are expressed relative to the local matrix, so ...
%         %change back to global numbering
%         S.ccycles{c}={cyclesc{ccindex}};
%         % iterate over critical cycles to change them to original nodes.
%         %CAVEAT: The following can never be reached!! It is ruled out
%         %explicitly.
% %     else%~S.order(c,c), component with lambda==mmp.l.zero
% %         %The mmp.l.zero eigenvalue is posited in Bapat, Rhagavan,
% %         %mmp. 967. Theorem 2.1 and also in Gaubert, 92. prop. 2.2.3.
% %         error('mmp:l:Sectrum:of_connected_digraph','Component %i is actually disconnected',c);
% % %         S.lambdas(c)=mmp.l.zeros; %#ok<UNRCH>
% % %         S.ccycles{c}{1}={};%This is the reason why order(c,c)==false
% %     end
% end%for c=1:nC

% We have to do two passes in order to be able to do both left and right
% eigenvalues in this second pass.
%class support holds downstream classes in row csupp(c,:) and upstream
%classes in colum csupp(:,c)
%Only upstream classes are important for the support of revs
for c = 1:nC
    %First we build a support pattern matrix, then we store the
    %eigenvectors and their cycles
    compsc=comps{c};%sccs nodes
    nN = size(compsc,2);%Number of nodes in component
    
    %%Now build the eigenvalue piece-wise: insaturated support is
    %%introduced by default in the initialization
    rpat =mmp.l.zeros(m,nN);
    %upstream and unrelated classes belong to the left insaturated support
    %lins = ~dsc
    lpat = mmp.l.zeros(nN,m);
    
    lambda = S.lambdas(c);
%     if lambda > -Inf%For non-null eigenvalue, do support analysis...
        %find upstream and downstream classes
        usc=S.order(:,c)';
        dsc=S.order(c,:);
        %%downstream classes and unrelated belong to the right
        %%insaturatedsupport
        %rins = ~usc;
        
        if lambda == Inf
            %  no dominating classes up- or down-stream.
            domc = (S.lambdas == Inf);
            %detect all other Inf since they will contribute saturated
            %coordinates.
            if any(~domc)%if there are dominating classes...
               %Choose the biggest lambda as normalizer
               norm = max([S.lambdas(~domc) mmp.l.ones]);%Ensure not -Inf!
            else%otherwise, all classes have Inf evalues or this is a single class!
                norm = 0;
            end
            domc(c) = false;%do not consider the present class!
        else%Finite eigenvalue is the most complicated case...
            %find dominating classes for c
            domc = (S.lambdas > lambda);
            norm = lambda;
        end
        
        %find dominating upstream & downstream classes
        % For Inf classes these will be other Inf classes
        dom_usc = usc & domc;
        dom_dsc = dsc & domc;
        S.ec_above(c)=any(dom_usc);%whether c is upstream dominated
        S.ec_below(c)=any(dom_dsc);%whether c is downstream dominated
                                    
        % To process the support we do not take into consideration
        % this class because we have already calculated its transitive
        % closure (righthand left corner in UFNF).
%         usc(c)=false;
%         if any(usc)
%             ugnsupp=[comps{usc}];%upwards global node support
%             if any(dom_usc)%saturate the diagonal blocks of dominating classes...
%                 B=mmp.l.zeros(sizeA);%However big, it is mostly empty!
%                 %create block diagonal Inf mask
%                 for satc=find(dom_usc)
%                     satsupp = comps{satc};
%                     B(satsupp,satsupp)=Inf;
%                 end
%                 rnStar = mmp.l.plus(A(ugnsupp,ugnsupp),B(ugnsupp,ugnsupp));
%             else
%                 rnStar = A(ugnsupp,ugnsupp);
%             end
%             % Therefore the tclosure is reached in finite number of steps,
%             % even if there are dominating classes with Infinite stars!
%             rnStar=mmp.l.finite_trclosure(mmp.l.mrdivide(rnStar,norm));
%             rlink = mmp.l.mrdivide(A(ugnsupp,compsc),norm);
%             rpat(S.g2l(ugnsupp),:)=mmp.l.mtimes(mmp.l.mtimes(rnStar,rlink),mmp.l.rclosure(metric_matrices{c}));
%         end
%         %The values for the finite support of this class
%         rpat(S.g2l(compsc),:)=metric_matrices{c};
        rpat(S.g2l(compsc),:)=metric_matrices{c};
        usc(c)=false;
         %The values for the finite support of this class
        if any(usc)%if it has any upstream support
            rn = length([comps{usc}]);
            rnStar=mmp.l.zeros(rn,rn);
            classes=find(usc);
            k=classes(1);
            supp=comps{k};
            nsupp=length(supp);
            ran=(1:nsupp);
            if dom_usc(k)
                %on dominating downstream class: saturate
                rnStar(ran,ran)=Inf;%mmp.l.tops, actually
            else
                %on non-dominated downstream class: finite closure
                %exists!
                rnStar(ran,ran)=mmp.l.finite_trclosure(mmp.l.mrdivide(A(supp,supp),norm));
            end
            ugnsupp=supp;
            gsupp=nsupp;
            %do the rest of the classes, in case there is any!
            for k = 2:length(classes)
                supp = comps{classes(k)};
                nsupp=length(supp);
                ran = gsupp+(1:nsupp);
                if dom_usc(classes(k))
                    %on dominating downstream class: saturate
                    rnStar(ran,ran)=Inf;%mmp.l.tops, actually
                else
                    %on non-dominated downstream class: finite closure
                    %exists!
                    rnStar(ran,ran)=mmp.l.finite_trclosure(mmp.l.mrdivide(A(supp,supp),norm));
                end
                rnStar(1:gsupp,ran)=mmp.l.mtimes(rnStar(1:gsupp,1:gsupp),mmp.l.mtimes(mmp.l.mrdivide(A(ugnsupp,supp),norm),rnStar(ran,ran)));
                ugnsupp=[ugnsupp supp]; %#ok<AGROW>
                gsupp=gsupp+nsupp;
            end
            rpat(S.g2l(ugnsupp),:)=mmp.l.mtimes(mmp.l.mtimes(rnStar,mmp.l.mrdivide(A(ugnsupp,compsc),norm)),mmp.l.rclosure(metric_matrices{c}));
            %lpat(:,S.g2l(dgnsupp))=mmp.l.mtimes(metric_matrices{c},mmp.l.mtimes(mmp.l.mrdivide(A(compsc,dgnsupp),norm),lnStar));
        end%If any(usc)

        %Repeart mutatis mutandis for downstream dominated classes and left
        %eigenvectors
        %Store the values for the present class
        lpat(:,S.g2l(compsc))=metric_matrices{c};
        dsc(c)=false;%do not consider this class for processing
        if any(dsc)
            ln=length([comps{dsc}]);%size of downstream local matrix being built
            lnStar=mmp.l.zeros(ln,ln);
            classes=find(dsc);%non empty
            k=classes(1);
            supp = comps{k};
            nsupp=length(supp);
            ran = (1:nsupp);
            if dom_dsc(k)
                %on dominating downstream class: saturate
                lnStar(ran,ran)=Inf;%mmp.l.tops, actually
            else
                %on non-dominated downstream class: finite closure
                %exists!
                lnStar(ran,ran)=mmp.l.finite_trclosure(mmp.l.mrdivide(A(supp,supp),norm));
            end
            dgnsupp=supp;
            gsupp=nsupp;
            %do the rest of the classes, in case there is any!
            for k = 2:length(classes)
                supp = comps{classes(k)};
                nsupp=length(supp);
                ran = gsupp+(1:nsupp);
                if dom_dsc(classes(k))
                    %on dominating downstream class: saturate
                    lnStar(ran,ran)=Inf;%mmp.l.tops, actually
                else
                    %on non-dominated downstream class: finite closure
                    %exists!
                    lnStar(ran,ran)=mmp.l.finite_trclosure(mmp.l.mrdivide(A(supp,supp),norm));
                end
                lnStar(1:gsupp,ran)=mmp.l.mtimes(lnStar(1:gsupp,1:gsupp),mmp.l.mtimes(mmp.l.mrdivide(A(dgnsupp,supp),norm),lnStar(ran,ran)));
                dgnsupp=[dgnsupp supp]; %#ok<AGROW>
                gsupp=gsupp+nsupp;
            end
            lpat(:,S.g2l(dgnsupp))=mmp.l.mtimes(mmp.l.rclosure(metric_matrices{c}),mmp.l.mtimes(mmp.l.mrdivide(A(compsc,dgnsupp),norm),lnStar));
        end
        
        % Find eigennodes and eigenvectors
        for cy=1:size(S.ccycles{c},2)%Go over critical cycles for class
            %S.cycles{c}{cy}=compsc(lccycles{cy});
            cn=S.ccycles{c}{cy}(1:end-1);%# cnodes 1 less than cycle size
            S.enodes{c}{cy}=cn;%all critical nodes are eigennodes
            if lambda == Inf
                %Only one different eigenvector per class, only sat or insat
                %support is found, but we keep them for completion's sake
                S.revs{c}{cy}=rpat(:,S.g2ml(cn));%All revs are the same
                S.levs{c}{cy}=lpat(S.g2ml(cn),:);%all levs are the same
            else
                S.revs{c}{cy}=rpat(:,S.g2ml(cn));
                S.levs{c}{cy}=lpat(S.g2ml(cn),:);
            end
        end
        %CAVEAT: for each class with apparently some finite support, there
        %is a non-finite support eigenvector for the Inf eigenvalue, the
        %result of multiplying any of the eigenvalues by Inf!
%     else %Lambda == -Inf
%         S.enodes{c}{1:nN}=compsc;%Not critical nodes, but they are all eigennodes
%         %The left and right eigenvectors will be free, and in different
%         %cycles!!
%         %         S.levs{c}{1}=mmp.l.eye(n,nN);
%         %         S.revs{c}{1}=mmp.l.eye(nN,n);
%         rpat(g2l(compsc),:) = mmp.l.eye(nN);
%         lpat(:,g2l(compsc)) = mmp.l.eye(nN);
%         %Unfortunately mat2cell won't work on objects like mmp.x.Sarse
%         for cy =1:nN
%             S.revs{c}{cy}=rpat(:,cy);
%             S.levs{c}{cy}=lpat(cy,:);
%         end
%     end%if lambda==...
end%for c=
% if returnAplus
%     %A final sweep to obtain the transitive closure matrix:
%     %FVA: this can be done during the initial exploration!! TODO!
%     Aplus=mmp.l.zeros(m);
%     % wsupp=0;%width of support, to index Aplus
%     supp=false(1,m);%support to index A
%     wsupp=0;
%     % supp(comps{1})=true;%include class A
%     % wsupp=sum(+supp);%work out width
%     % Aplus(1:wsupp,1:wsupp)=metric_matrices{1};
%     for c=1:nC
%         compsc=comps{c};
%         base=1:wsupp;
%         ran=wsupp+(1:length(compsc));
%         if S.lambdas(c) > 0
%             Aplus(ran,ran)=mmp.l.tops;
%         else
%             Aplus(ran,ran)=metric_matrices{c};
%         end
%         Aplus(base,ran)=mmp.l.mtimes(Aplus(base,base),mmp.l.mtimes(A(supp,compsc),Aplus(ran,ran)));
%         supp(compsc)=true;
%         wsupp=ran(end);
%     end
% end
return%Exit with no more work to be done
