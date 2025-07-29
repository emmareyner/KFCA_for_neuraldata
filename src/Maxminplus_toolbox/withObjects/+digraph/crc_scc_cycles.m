function [subgraph,order,cycle,components,crc,vis,finishTime,ncycle] =...
    crc_scc_cycles(X,trace)
%function [subgraph,order,cycle] = digraph.crc_scc_cycles(A,trace)
%
% A function to obtain the completely reducible components (disconnected
% subdigraphs), strongly connected components and simple cycles of a the
% digraph induced by a matrix using the 
% parametric approach of the matlab_BGL port of the Boost Graph library and
% the techniques of [Mehlhorn and Sanders, 2008. Algorithms and Data
% Structures, pp. 178--189] and [Weinblatt, 1972. A New Search Algorithm...]
%
%The techniques for doing the parameterization in the visitor functions can
%be found in the doc. of the matlab_BGL library, Section 5, "Visitors".
%
% Input:
% - [A] a (n x n) square maxplus matrix, interpreted as the adjacency
% matrix of a digraph.
% - [trace] a boolean indicating whether to trace the DFS of cycles.
% Default is 'false'.
%
% Let nS be the number of completely reducible components (crc), aka
% unconnected subgraphs. Let nC_s be the number of strongly connected
% components (scc) of completely reducible component s.
%
% Output:
% - [subgraph]: a 1 x nS array with the sets of vertices in each
% connected component. For each s=1:nS, subgraph{s} is a 1 x nC_s array
% of arrays of vertices in component {s}{c}.
%
% - [order] : a 1 x nS array coindexed with subgraph. For each s:1:nS
% order{s} is the nC_s x nC_s *adjacency* matrix of the *components* in the
% condensed graph. It is also topologically sorted, but in order to obtain
% the order between components you should build the transitive closure of
% this matrix, which should result in an upper triangular boolean matrix.
%
%- [cycle] : a 1 x Nc array coindexed with [subgraph]. For each s=1:nS,
% cycle{s} is a 1 x nC_s (no. of components) array of 1 x nCS_l cycles (l for 'loop')
% in cycle{s}{c}{l}.
%
% Note that: 
%  - if the graph is everywhere disconnected (everywhere null), [subgraph]
%  is of size nS=1 but nC_1 = 1 and [order(1,1)==0], [cycle{1}{1} is empty.]
%
%  - if A is completely reducible (has disconnected subgraphs), [subgraph]
%  is of length > 1, and the total number of connected components is
%  bigger than one (at least one for each crc).
%
%  - for a reducible component s we have (call A(s,s) its submatrix):
%    if A(s,s) is reducible, the number of components is nCs > 1
%
%  - if A(s,s) is irreducible, the subgraph is also irreducible it  is of
%  length 1 and order(1,1)=true.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
error(nargchk(1,2,nargin));

%% ARGUMENT PROCESSING
[m n]=size(X);
if m~=n
    error('digraph:crc_scc_cycles','Non-square matrix')
end

% Default flag for sorting components is FALSE.
if (nargin == 1), trace=false; end

%% Sparsify matrix, previous to dfs 
%Transform any matrix into a sparse matrix with 0 in the bottom elements
%and eps in the unit elements
% CAVEAT: for MN encoded matrices this may take a LONG TIME!
switch class(X)
    case 'double'
        if issparse(X)
            error('digraph:crc_scc_cycles','Doesn"t work with a plain sparse format. Use mmp.x.Sparse instead!');
        else%For full matrices, turn into MX format
            A=mmp_x_sparse(X);
        end
    case 'mmp.x.Sparse'
        A = X.Reg;%Obtain the sparse part!
    case 'mmp.n.Sparse'
        A = mmp_x_sparse(double(X));%Obtain the sparse part!
    case 'mmp.x.Trisparse'
        A=double(X);
    otherwise
        error('digraph:crc_scc_cycles','Unexpected matrix input format')
end
options.full2sparse=1;%Sparsification already done!
    
%%%OVERALL DEBUGGING FLAGS
debug=trace;%maybe really sylly
if debug && trace, disp(A); end

%% Shared data structures
%basic dfs search quantities:
% - count1 is the counter of visited vertices
count1=0;
count2=0;

%component-finding structures
% Component stores de dfs visit time of an open node. When it closes it
% stores de sccs number (changes to negative).
% if component(v)=0, then v is unvisited
% if component(v) < 0, then c is closed, component(v) is the sccs number.
% if component(v) > 0, then the component v belongs to is still open with
% dfs(v)=component(v)
components=zeros(1,m);
% finishTime(u) > 0 when u is finished aka totally explored.
finishTime=zeros(1,m);%needed for sorting.
%TODO: encode completely reducible component crc in this array too!
crc=zeros(1,m);%Id of completely reducible component node belongs to!
cid=0;%Identity of current crc, aka disconnected subdigraphs
%TODO: this is a waste... It should be an array denoting which nodes are in
%which CRC

%CAVEAT: THERE IS TOO MUCH VALUE PASSING AROUND HERE! YOU SHOULD USE THE
%FOLLOWING ARRAYS TO PASS MATRICES BY REFERENCE!!
% components=ipdouble(zeros(1,m));
% finishTime=ipdouble(zeros(1,m));%needed for sorting. Dummy if sorted==false
% %TODO: encode completely reducible component crc in this array too!
% crc=ipdouble(zeros(1,m));%Id of completely reducible component node belongs to!
% cid=0;%Identity of current crc, aka disconnected subdigraphs

%The cycles attached to the initial node in the cycle in dfs explo. order
ncycle=cell(1,m);
%TODO: This is a waste It should only be a component-indexed array, the
%same as crc.

%Stacks are implicit: the valid stack is always stack(1:i)
%hence a pop is done with i=i-1.
%CAVEAT: DON'T use stack(end) for peeking the top!
oNodes=[];ni=0;%open Node stack and index
oReps=[];ri=0;%open Representative stack and index.
oCycles={};%open representative cycles stack of stacks. Coindexed with ri.
oForward={};%Forward links in component. Coindexed with ri.

%% VISITORS!
vis = struct();
if debug
    tvis= digraph.mk_tracing_visitors('dfs');
    
    if trace,
        bias=double('a')-1;
        stack_print_func = @(str) @(u,i)...
            fprintf('%s(%i): %s\n',str,i, sprintf('%s ',char(bias + u(1:i))));
        print_reps = stack_print_func('  oReps');
        print_nodes = stack_print_func('  oNodes');
        print_cycles = @(u)...
            fprintf('  cycle: %s\n',sprintf('%s ',char(bias+u)));
    end

end

%% initialize_vertex: This is invoked on every vertex of the graph before the start of the graph search.
%%% Unneeded, since we do the initialization above

%% start_vertex: This is invoked on the source vertex once before the start
%%of the search. 
%DO this every time a restart of the stack is done: a new root node.
%in M&S, this would be root(w)
    function c_start_vertex(w)
        if debug
            tvis.start_vertex(w);
            if trace, fprintf('  Starting CRC num. %i\n',w); end;
        end
        %Start a new scc
        count1=count1+1;components(w)=count1;
        %start a fresh crc
        cid=count1; crc(w)=cid;
          %TODO: manage [nS], the crc counter at dfs time!
        %stacks would be empty, but pushing is the same.
        ni=ni+1;oNodes(ni)=w;
        ri=ri+1;oReps(ri)=w;oCycles{ri}={};oForward{ri}=[];
%        return 1%if we returned 0 here, the algorithm would stop
    end
    vis.start_vertex=@c_start_vertex;
    
%% discover_vertex: This is invoked when a vertex is encountered for the
%%first time. 
% %%This is the dfsnumbering step, but not used in SCCS
%     function c_discover_vertex(u)
%         if debug, tvis.discover_vertex(u); end
%         dfsNum(u)=count1;count1=count1+1;
% %       return 1%if we returned 0 here, the algorithm would stop
%     end;
%     vis.discover_vertex = @c_discover_vertex;
    
%% tree_edge(ei,u,v). This is invoked on each edge as it becomes a member
%%of the edges that form the search tree.
%%Traversing a tree edge: in M&S this would be traverseTreeEdge(v,w) 
    function res = c_tree_edge(ei,v,w)
        %visiting a tree edge does NOT open a new crc, just enrolls the
        %visited node in the current crc.
        crc(w)=cid;
        %Mark as visited with dfsTime but still open.
        count1=count1+1;components(w)=count1;
        %Stacks should *not* be empty here.
        ni=ni+1;oNodes(ni)=w;
        ri=ri+1;oReps(ri)=w;oCycles{ri}={};oForward{ri}=[];
%        return 1%if we returned 0 here, the algorithm would stop
        if debug,
            tvis.tree_edge(ei,v,w);
            if trace
                print_reps(oReps,ri);
                print_nodes(oNodes,ni);
            end
        end
    end
    vis.tree_edge=@c_tree_edge;

%% A function to merge a new cycle with the previous cycles in the
%  component pointed to by ri
    function newcycles=merge_cycles(cprefix)
        %repi is the position of representative in cycles
        ocycles=oCycles{ri};%debug%oldcycles, local list of cycles
        %oForward{ri}%debug
        nC = size(ocycles,2);
%         %If the path prefix is already a cycle, then add it at the end
%         %This should be done somewhere else
%         if (cprefix(1)==cprefix(end))
%             newcycles={cprefix};
%             if debug && trace,
%                 %oCycles
%                 print_cycles(cprefix);
%             end
%         else
%             newcycles={};
%         end
        tails={};%list of tails previously explored
        newcycles={};%list of newly created cycles
%         %Substack of open nodes
%         TT=oNodes(find(finishTime(oNodes(1:ni))==0))

        %TODO: DEBUG THIS BELOW!!
        %This RECURSIVE function accumulates in newcycles
        function find_tail(P)%P for prefix
            %tails={};
            %P%debug
            endP=P(end);%Last node in prefix
            for cy=1:nC,
                thiscycle=ocycles{cy};%cycle being explored
                %Find continuation in current cycle but avoid cycle
                %restarts.
                pos=(endP==thiscycle(2:end));%debug
                %any(pos) || continue;%If endP not in cycle try next cycle
                if ~any(pos), continue; end
                %Find tail of continuation wrt endP
                tail=thiscycle(find(pos)+2:end);%debug
                st=size(tail,2);
                if st==0, continue; end%If empty tail, try next cycle
                %If the cycle-tail has any vertices on P, barring the end,
                %try next cycle
                if any(ismember(tail(1:end-1),P)), continue; end
                endCP=tail(end);
                %Check that the tail has not been visited already,
                %otherwise, try next cycle
                %TODO: use a trie to do this.
                notfound=true;
                t=size(tails,2);
                while notfound && (t > 0)
                    seentail=tails{t};%debug?
                    if (size(seentail,2)==st)
                        notfound=any(tail~=seentail);
                    end
                    t=t-1;
                end
%                 for t=1:size(tails,2)
%                     seentail=tails{t};
%                     if (size(seentail,2)==st) && ...
%                             all (tail==seentail)
%                             found=true;
%                             continue;
%                     end
%                 end
                if ~notfound, continue; end
                %otherwise store and explore.
                tails{end+1}=tail;
                %If end of tail open, cycle found
                if finishTime(endCP) == 0%endCPstill in stack
                    %tailTT=TT(find(TT==endCP))
                    %newcs=[tailTT P tail]
                    newcs=[P tail];%debug
                    newcycles=[newcycles newcs];
                else%If the end of the tail is closed, recurse
                    find_tail([P tail]);
                end
            end
        end%function find-tail
        
        %just find new cycles!
        find_tail(cprefix);
        %visit all cycles in component tryiing to complete
        %oCycles{ri}=cat(2,oCycles{ri},find_tail(cprefix));
        %oCycles{ri}=[oCycles{ri} newcycles];
        return%newcycles
    end
    
%% vis.back_edge(ei,u,v) 	void 	
%This is invoked on the back edges in the graph.
%IN M&S, this is traversing a non-tree edge: the only attention we pay is
%to back edges. 
%We don't need to guaranteee that it is a backnode! I.e.component(w) >0
%NOTE: this procedure MUST have added a cycle in this invocation be it
%because oReps(ri) == w or because it is a proper new cycle prefix
    function merge_components(w)
%         %Is it always the case that comp_w == w until closing the
%         %representative?, it looks like this is the case.
%         %this is the detection of the cycle, actually!
        comp_w = components(w);
        eri=ri;%Save last tentative components
        %1. Pop representatives, but delay cycle collection, etc.
        while comp_w < components(oReps(ri)), ri=ri-1; end
        %Put all cycles and F edges in the representative.
        %mergedc=horzcat(oCycles{ri:eri})
        %oCycles{ri}=horzcat(oCycles{ri:eri})%debug
        oCycles{ri}=[oCycles{ri:eri}];%save new cycle for component
        %oForward{ri}=horzcat(oForward{ri:eri});%debug
        oForward{ri}=[oForward{ri:eri}];%merge all pending forward edges
        %2.1 Find new cycle prefix
        %if w is not closed, it must be in the stack,hence cpath is a cycle
        % NOTE: closed node s has finishTime(s) > 0
        if finishTime(w)==0%path is a cycle
            %Find actual position of ending node in stack
            repi=find(oNodes==w);
            %Build new cycle.
            cycle=[oNodes(repi-1+find(finishTime(oNodes(repi:end))==0)) w];
            %newcycles=merge_cycles(cycle);
            newcycles={cycle};
        else%otherwise it is a proper cycle prefix path,
            %Find index of representative of component
            repi=find(oNodes==oReps(ri));
            %oNodes
            %nodes=repi-1+find(finishTime(oNodes(repi:end))==0)%Still open nodes
            %Build cyclic prefix
            cpath=[oNodes(repi-1+find(finishTime(oNodes(repi:end))==0)) w];
            %cpath=[w];
            %2.2 Find new cycles with the merging
            newcycles=merge_cycles(cpath);
        end
        %Add newly found cycles
        oCycles{ri}=[oCycles{ri} newcycles];
    end
    
    function res= c_back_edge(ei,v,w)        
        %visiting a back edge does NOT open a new crc, and does NOT enroll.
        % But it may merge several sccs, and their cycles.
        if debug, tvis.back_edge(ei,v,w); end
        merge_components(w);
    end
    vis.back_edge = @c_back_edge;

%% vis.forward_or_cross(ei,u,v) This is invoked on forward or cross edges.
%%The difference lies in that cross edges may fuse two crcs together but
%%forward edges don't.
    function res = c_forward_or_cross_edge(ei,u,v)
        if debug, tvis.forward_or_cross_edge(ei,u,v); end
        %check on crc number to find a fusion
        if crc(v) == cid
            if trace,
                fprintf('  Edge lies within CRC %i.\n',cid);
            end
            comp_v = components(v);
            % If v is open(positive), components(v)==dfsTime(v)
            % If v is clesed(negative), components(v)=sccs number.
            %Forward or cross?
            % if u is still open, so components(u)==dfsTime(u) > 0
            if components(u) < comp_v% - then v is still open: FORWARD
               if trace, fprintf('   It is a forward edge!\n');end
               %TODO:Check if both in same (cycle generated) or different (cycle
               %generation delayed) component.
               %store for future cycle detection on closing component
               oForward{ri}=[oForward{ri}; [u v]];
            else%v was visited before u
               %This may fuse two components together!
               if trace, fprintf('    It is a cross edge');end
               if comp_v > 0% - v still open: merge as in a BACKWARD link
                    if trace,
                        fprintf('... that MERGES some components!\n');
                    end
                    merge_components(v);
%                     vi=find(oNodes==v);%Place in node stack
%                     %pop representative to put in same sccs...
%                     while v < oReps(ri),
%                         ri=ri-1;
%                     end%Delay the pop
                    if debug && trace
                        %fprintf('cycle: ');disp(oReps(ri:end));
                        fprintf('FALSE '); print_cycles(oReps);
                        print_reps(oReps,ri);
                        print_nodes(oNodes,ni);
                    end
               else% - v is a closed component. Only establishes order.
                   if trace
                       fprintf('... towards CLOSED components!\n');
                   end
                   %TODO: Fill up component adjacency table.
               end
            end
        else%The crc of v is NOT the current: cross edge to closed crc
            if trace
                fprintf('  Cross edge merges CRC %i with  %i\n', crc(v), cid);
            end
            %Fuse crcs together: Why not use logical indexing?
%            crc(find(crc == cid))=crc(v);
            crc((crc == cid))=crc(v);
            cid=crc(v);%Attach to crc(v) until finishing exploration.
            %TODO: update crc count and cid informato accordingly.
        end
    end
    vis.forward_or_cross_edge = @c_forward_or_cross_edge;

%% vis.finish_vertex(u, g) 	void 	This is invoked on vertex u after
%%finish_vertex has been called for all the vertices in the DFS-tree
%%rooted at vertex u.
%%% In M&S this would be backtrack(*,v)
%     function shortcut_cycles(Flink)
%         ocycles=oCycles{ri};%oldcycles
%         nC = size(ocycles,2);
%         newcycles={};
%         sl=Flink(1);el=Flink(2);%start and end vertices
%         %invariant: dfsTime(sl) < dfsTime(el)
%         for c=1:nC
%             cc=ocycles{c};
%             possl=find(cc==sl);
%             if isempty(possl), continue; end
%             posel=find(cc==el);
%             if isempty(posel), continue; end
%             %theorem: possl < posel
%             newc=[cc(1:possl) cc(posel)];
%             newcycles=[newcycles []];
%         end    
%     end;
    function res= c_finish_vertex(v)
        if debug
            tvis.finish_vertex(v);
%             if trace
%                 fprintf('  On entering finish_vertex:\n');
%                 print_reps(oReps,ri);
%                 print_nodes(oNodes,ni);
%             end
        end

        % 2 When the vertex is a representative...
        if v == oReps(ri)
            if debug && trace
                fprintf('  Vertex %s is the rep. of SCS %i.\n',char(bias+v), -v);
            end
            %2.4 explore all pending forward edges and store cycles in
            %representative
            Flinks=oForward{ri};
            nF=size(Flinks,1);
            for f=1:nF
                %This needs to be stored in here!
                oCycles{ri}=[oCycles{ri} merge_cycles(Flinks(f,:))];
            end
            ncycle{v}=oCycles{ri};%May be empty, if disc. component
            % 2.1 Pop all nodes except rep. from node stack
            %niend=ni;
            while v ~= oNodes(ni), ni=ni-1; end
            %TODO: store in component indexed cellarray.
            %Components for SCC are in cycles and in this
           % 2.2. Mark component as closed...
            %components(oNodes(ni:niend))=-v%debug
            comps=logical(sparse(1,m));
            comps(v)=true;%At least finishing node
            thesecycles=oCycles{ri};
            nC=size(thesecycles,2);
            while nC > 0, comps(thesecycles{nC})=true;nC=nC-1;end
            components(comps)=-v;
            %Representative pop is done below
            %             w=oNodes(ni);
            %             ni=ni-1;%Pop last pending node.
            %             components(w)=-v;%set representative for node.
            %             while w ~= v%Pop all other nodes in component.
            %                 w=oNodes(ni);
            %                 ni=ni-1;
            %                 components(w)=-v;
            %             end
            %2.6 Pop representative.
            ri=ri-1;
            if debug && trace
                nc=size(ncycle{v},2);
                if nc==0
                    fprintf('  NO cycles!\n');
                else
                    for nci=1:nc,print_cycles(ncycle{v}{nci}); end
                end
            end
        end%Node is not a representative
        % 1 mark node as finished
        count2=count2+1;finishTime(v)=count2;
        % 2.3 Pop rep from stack
        ni=ni-1;%Pop v from pending nodes.
        if debug && trace
            print_reps(oReps,ri);
            print_nodes(oNodes,ni);
        end
    end
    vis.finish_vertex = @c_finish_vertex;

%% Do the actual call on ALL vertices: recipe from BGL toolkit
options.full = 1;%Do a full exploration, no need to sparsify
%old_options = set_matlab_bgl_default(options);%set new, save old options
depth_first_search(A,1,vis,options);%do computations on the new optiosn
%set_matlab_bgl_default(old_options);%Restore options
%[d dt ft pred]=dfs(A,2,options);%Only does visiting,  not tailored behav.
    
%% POST processing:
% 1. Detect completely reducible components crc
[crcs,crci,crcj]=unique(crc);
nS=size(crcs,2);%Count crcs.

%2. Initialize return variables adequately
subgraph=cell(1,nS);
order=cell(1,nS);
cycle=cell(1,nS);

%3. Go over crc collecting sccs and cycles
for s=1:nS
    %Hay que disponer components, para que acabe siendo positivo.
    %3.1 Select sccs of current crc
    gnodes=(crc==crcs(s));%obtain the global nodes in this subdigraph
    [comp_s,kk,compj]=unique(-components(gnodes));%obtain component numbers
    gnodes=find(gnodes);%transform global nodes into numbers
    %3.3.1 Order in decreasing finishing time: [si] is the useful info
    %here.
    %Funny tinkering on component numbers for ordering purposes
    %Remark: inverted comp. nos. are dfs rep. node startTimes
    [finishTime_s,si]=sort(finishTime(comp_s),'descend');
    
    %3.2 Initialize return variables for current crc
    nC_s=size(comp_s,2);%Count sccs for current crc
    compns=cell(1,nC_s);
    cyclens=cell(1,nC_s);
    orderns=logical(sparse(nC_s,nC_s));
    
    %3.3. visit each scc for current crc
    % 3.3.2. Go over sccs in crc#s
    for c=1:nC_s
        %3.3.2.1. Find nodes in component
        %startTime_s_c=comp_s(si(c));%Start time of current scc
        %nodes1=find(components==(-startTime_s_c));%Should look only into components
        %nodes=find(compj==si(c));
        nodes=gnodes(compj==si(c));
        compns{c}=nodes;%This forgets about the global names of nodes
        %on different completely reducible components!
        %compns{c}=comp_s(c);
        %3.3.2.2. Merge simple cycles
        %             %thesecy=cat(1,ncycle{nodes})
        %             %thesecy=~cellfun('isempty',ncycle{nodes})
        %             %thesecy=~cellfun('isempty',ncycle(nodes))
        %             thesecy=ncycle(nodes);%select CELLS with cycles in component
        %             %cyclens{c}=cat(1,thesecy(find(~cellfun('isempty',thesecy))))
        %             withcy=find(~cellfun('isempty',thesecy));
        %             for cy =1:size(withcy,2), cyclens{c}{cy}=thesecy(withcy(cy));end
        %             %numcy=sum(mask);
        %             %cyclens{c}=cell(1,numcy);
        %             %cyclens{c}=thesecy(mask);
        %THe next is a strange idiom to concatenate non-void cells
        cyclens{c}=cat(2,ncycle{nodes});
    end%For c=1:nC_s
    % 3.3.3. Calculate the adjacency matrix.
    for ci=1:nC_s,
        compsc=compns{ci};
        for cj=1:nC_s
            orderns(ci,cj)=any(any(A(compsc,compns{cj})));
        end
    end
    %             for cj = 1:nC_s
    %                 orderns(c,cj)=any(A())
    %                 % the >= is to make all sccs depend on themselves. This is not
    %                 % true if A is everywhere disconnected.
    % %                 orderns(c,cj)=...
    % %                     ((startTime_s_c < comp_s(si(cj))) && ...
    % %                     (finishTime_s_c >= finishTime_s(cj)));
    %             end
    %         finishTime_s = finishTime(comp_s);
    %         for c=1:nC_s
    %             startTime_s_c=comp_s(c);%Start time of current scc
    %             finishTime_s_c=finishTime_s(c);
    %             compns{c}=find(components==(-startTime_s_c));
    %             for cj = 1:nC_s
    %                 % the >= is to make all sccs depend on themselves. This is not
    %                 % true if A is everywhere disconnected.
    %                 orderns(c,cj)=...
    %                     ((startTime_s_c < comp_s(cj)) && ...
    %                     (finishTime_s_c >= finishTime_s(cj)));
    %             end
    %         end
    %         [scomps,si]=sort(finishTime(comp_s),'descend');%Order in decreasing finishing time. si is the useful info here.
    %         compns=compns(si);
    %         orderns=orderns(si,si);
    
    %     else%not sorted: just get components
    %         for c=1:nC_s
    %             compns{c}=find(components==(-comp_s(c)));
    %         end
    %     end%if sorted
    %3.4 Store result of current crc exploration
    subgraph{s}=compns;%This stores a cell array of sccs
    order{s}=orderns;
    %    whos cycle
    cycle{s}=cyclens;
end%for s=1:nS
% %%%TODO: include cycle information.
%% End of function
%    if debug && trace && sorted, disp(finishTime); end
    return%subgraph, order, components, vis
end
