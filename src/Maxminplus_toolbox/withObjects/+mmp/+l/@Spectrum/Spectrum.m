classdef Spectrum
    % A class to represent the spectrum of a connected component in a
    % maxplus matrix.
    properties
        zcols=logical(sparse(0,0));%sparse logical zero columns: non-null value declares a matrix as with zero lines
        zrows=logical(sparse(0,0));%sparse logical zero columns: non-null value declares a matrix as with zero lines
        embedded={};%cell list of spectra: null value declares matrix as irreducible
        % if UFNF0: dimension 1 x 1
        % if UFNF1: dimension r x r, r > 1, non-diagonal
        % if UFNF2: dimension k x k, k > 1, diagonal
        % if UFNF3: dimension 0 x 0,
        order = sparse(0,0);%order relation between components.
        % Describes the order between classes in each spectrum
        comps = {};%components
        cycles = {};%cycles for each component. Maybe only crit. cycles
        %global indexes for 
        nodes = [];%Nodes in the global order
        g2l=[];%global to local order 
        g2ml=[];%global to micro local order
        ec_below=logical([]);%wheter sccs it is eclipsed in the right spectrum
        ec_above=logical([]);%wheter sccs it is eclipsed the left spectrum
        lambdas=[];%cycle means
        ccycles={};%indices of critical cycles in array cycles
        enodes={};%right eigen-nodes
        lenodes={};%left eigen-nodes
        levs={};%left eigenvectors
        revs={};%right eigenvectors
    end
    methods
        function [Sp]= Spectrum(A,comps,adj,cycles)
            if nargin == 0%totally void constructor
                return%early termination
%             elseif nargin == 1% Only matrix is supplied
%                 %find comps, cycles, lcycles, etc.
            elseif nargin == 4% Matrix + components + adjacencies + cycles
                Sp=mmp.l.Spectrum.of_connected_digraph(A,comps,adj,cycles);
            else
                error('mmp:l:Spectrum','Invalid constructor pattern');
            end
        end
    end
    methods (Static)
        % A) ANALYSIS METHODS
        %
        %To return the left and right eigenvectors for a matrix, accepting
        %UFN_3
        [Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = of_digraph(A,rmask,cmask)
        %
        %to return the spectra of matrices with no zero lines accepting
        %UFNF_2
        [spectra,subgraphs,adjs,Aplus] = of_digraph_no_zero_lines(A)
        %
        %to return the spectrum of a possibly reducible (but not completely
        %reducible) maxminplus  matrix, accepting UFNF_1
        [Sp,Aplus] = of_connected_digraph(A,comps,adj,cycles)
        %
        % To return the spectral radius (lambda), critical vertices index
        % and eigenmatrix of an irreducible maxminplus matrix, UFNF_0
        [Slplus,lambda,ccindex] = of_strongly_connected_digraph(S,lcycles)
        %
        %To produce the eigennodes and FEVs of the top eigenvalue of a
        %strongly connected matrix.
        [Len,Ren,Lev,Rev]=top_FEVs(A)
        %
        [spectrum,Aplus]=of_UFNF_3(A)
        %
        [spectra,Aplus]=of_UFNF_2(A)
        %
        [spectrum,Aplus] = of_UFNF_1(A,comps,adj,cycles)
        %
        [lambda,nSplus,ccindex] =of_UFNF_0(S,lcycles)
        %
        % B) SYNTHESIS METHODS
        %
        %To return all the left and right eigenvectors from a spectrum list
        [U,Ldiag,V,enodes,nodes,InfU,InfV]=all_evs(SSpp)
        %To return a basis of eigenvectors from a spectrum list
        [Levt,Ldiag,Rev,enodes,nodes]=basis(SSpp)
        %To return the left and right eigenvectors from a spectrum
        [Ut,Ldiag,V,cnodes]=UtSV(Sp,allevs)
        %
        % Z) OBSOLETE METHODS!
        %
        %WARNING: The following primitive is obsolete!
        %To return the spectrum of a completely reducible maxminplus matrix
        [SP] = of_completely_disconnected_digraph(A,comps)
    end
end
