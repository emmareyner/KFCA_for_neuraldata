classdef UFNF_1 < mmp.l.Spectrum.UFNF_cyclic
    % A class to represent the spectrum of a connected component in a
    % maxplus matrix.
    properties
        spectra0={};
%         zcols=logical(sparse(0,0));%sparse logical zero columns: non-null value declares a matrix as with zero lines
%         zrows=logical(sparse(0,0));%sparse logical zero columns: non-null value declares a matrix as with zero lines
%         embedded={};%cell list of spectra: null value declares matrix as irreducible
        % if UFNF0: dimension 1 x 1
        % if UFNF1: dimension r x r, r > 1, non-diagonal
        % if UFNF2: dimension k x k, k > 1, diagonal
        % if UFNF3: dimension 0 x 0,
        order = sparse(0,0);%order relation between components.
        % Describes the order between classes in each spectrum
        comps = {};%components
%         cycles = {};%cycles for each component. Maybe only crit. cycles
%         %global indexes for 
%         nodes = [];%Nodes in the global order
%         g2l=[];%global to local order 
%         g2ml=[];%global to micro local order
        ec_below=logical([]);%wheter sccs it is eclipsed in the right spectrum
        ec_above=logical([]);%wheter sccs it is eclipsed the left spectrum
%         lambdas=[];%cycle means
%         ccycles={};%indices of critical cycles in array cycles
%         enodes={};%right eigen-nodes
%         lenodes={};%left eigen-nodes
%         levs={};%left eigenvectors
%         revs={};%right eigenvectors
    end
    methods
        function S= UFNF_1(A,comps,adj,cycles)
            if nargin < 4
                error('mmp:l:Spectrum:UFNF_1','missing parameters in constructor');%S.order = adj;
            elseif not(any(any(adj)))%empty adjacency. Completely disconnected subdigraph. Do not process here!
                error('mmp:l:Spectrum:UFNF_1','completely disconnected digraph');%S.order = adj;
            elseif any(any(tril(adj,-1)))%Sanity check: The graph is not in (upper) Frobenius normal form.
                error('mmp:l:Spectrum:UFNF_1','not a component in UFNF_1');
            elseif not(all(diag(adj)))%some component has no cycle
                error('mmp:l:Spectrum:UFNF_1','some of the components are not strongly connected');
            end
            maskperm = cell2mat(comps);
            S=S@mmp.l.Spectrum.UFNF_cyclic(A,maskperm,cycles);
            S.order = my.logical.tclosure(adj);%Store *logical* order tclosure
            %DO not use trclosure OR spureous reflexive dependencies
            %will appear
            S.comps = comps;%Store blocks or classes
            %The information of whether one component is eclipsed or
            %not has to be supplied later.
        end
    end
    methods (Static)
        % A) ANALYSIS METHODS
        %
        %To return the left and right eigenvectors for a matrix, accepting
        %UFN_3
        [S] = of_digraph(A,comps,adj,cycles)
%         %
%         %to return the spectra of matrices with no zero lines accepting
%         %UFNF_2
%         [spectra,subgraphs,adjs,Aplus] = of_digraph_no_zero_lines(A)
%         %
%         %to return the spectrum of a possibly reducible (but not completely
%         %reducible) maxminplus  matrix, accepting UFNF_1
%         [Sp,Aplus] = of_connected_digraph(A,comps,adj,cycles)
%         %
%         % To return the spectral radius (lambda), critical vertices index
%         % and eigenmatrix of an irreducible maxminplus matrix, UFNF_0
%         [Slplus,lambda,ccindex] = of_strongly_connected_digraph(S,lcycles)
%         %
%         %To produce the eigennodes and FEVs of the top eigenvalue of a
%         %strongly connected matrix.
%         [Len,Ren,Lev,Rev]=top_FEVs(A)
%         %
%         [spectrum,Aplus]=of_UFNF_3(A)
%         %
%         [spectra,Aplus]=of_UFNF_2(A)
%         %
%         [spectrum,Aplus] = of_UFNF_1(A,comps,adj,cycles)
%         %
%         [lambda,nSplus,ccindex] =of_UFNF_0(S,lcycles)
%         %
        % B) SYNTHESIS METHODS
        %
%         %To return all the left and right eigenvectors from a spectrum list
%         [U,Ldiag,V,enodes,nodes,InfU,InfV]=all_evs(SSpp)
%         %To return a basis of eigenvectors from a spectrum list
%         [Levt,Ldiag,Rev,enodes,nodes]=basis(SSpp)
%         %To return the left and right eigenvectors from a spectrum
        [Ut,Ldiag,V,Rdiag]=UtSV(Sp,allevs)
        %
    end
end
