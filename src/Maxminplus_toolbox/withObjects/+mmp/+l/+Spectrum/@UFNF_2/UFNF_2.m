classdef UFNF_2 < mmp.l.Spectrum.UFNF_cyclic
    % A class to represent the spectrum of a connected component in a
    % maxplus matrix.
    properties
%         zcols=logical(sparse(0,0));%sparse logical zero columns: non-null value declares a matrix as with zero lines
%         zrows=logical(sparse(0,0));%sparse logical zero columns: non-null value declares a matrix as with zero lines
%         embedded={};%cell list of spectra: null value declares matrix as irreducible
        % if UFNF0: dimension 1 x 1
        % if UFNF1: dimension r x r, r > 1, non-diagonal
        % if UFNF2: dimension k x k, k > 1, diagonal
        % if UFNF3: dimension 0 x 0,
%         order = {};%order relation between components.
        % Describes the order between classes in each spectrum
        blocks = {};%Nodes in each component block
        spectra1 = {};%A cell array of spectra of type UFN_1
%         cycles = {};%cycles for each component. Maybe only crit. cycles
%         %global indexes for 
%         nodes = [];%Nodes in the global order
%         g2l=[];%global to local order 
%         g2ml=[];%global to micro local order
%         ec_below=logical([]);%wheter sccs it is eclipsed in the right spectrum
%         ec_above=logical([]);%wheter sccs it is eclipsed the left spectrum
%         lambdas=[];%cycle means
%         ccycles={};%indices of critical cycles in array cycles
%         enodes={};%right eigen-nodes
%         lenodes={};%left eigen-nodes
%         levs={};%left eigenvectors
%         revs={};%right eigenvectors
    end
    methods
        function [S]= UFNF_2(varargin)%A,mask,cycles,orders,subdigraphs
            S = S@mmp.l.Spectrum.UFNF_cyclic(varargin{:});
            if length(varargin) < 5
                error('mmp:l:Spectrum:UFNF_2','missing parameters in constructor');
                % Sanity check! check input values
                % If matrix is completely reducible, then give an error.
            elseif isempty(varargin{4})%nocycles entails completely reducible
                error('mmp:l:Spectrum:UFNF_2:of_digraph','empty matrix in UFNF_2');
                %Check that all are connected!
            elseif ~all(cell2mat(cellfun(@(order) any(any(order)),varargin{4})))
                error('mmp:l:Spectrum:UFNF_2:of_digraph','disconnected components at UFNF_2');
            else
                S.blocks = varargin{5};
            end
        end
    end
    methods (Static)
        % A) ANALYSIS METHODS
        %
        %To return the left and right eigenvectors for a matrix, accepting
        %UFN_3
        [S] = of_digraph(A,mask,cycles)
        %
        % B) SYNTHESIS METHODS
        %
        %To return the left and right eigenvectors from a spectrum
        [Ut,Ldiag,V,Rdiag]=UtSV(Sp,allevs)
    end
end
