classdef Spectrum
    % A class to represent the spectrum of a connected component in a
    % maxplus matrix.
    properties
        cycles = {};%cycles for each component. Maybe only crit. cycles
        %global indexes for 
        nodes = [];%Nodes in the global order
        g2l=[];%global to local order 
        g2ml=[];%global to micro local order
        ccycles={};%indices of critical cycles in array cycles
        enodes={};%right eigen-nodes
        lenodes={};%left eigen-nodes
    end
    methods
        function [Sp]= Spectrum(A)
            if nargin == 0%totally void constructor
                return%early termination
%             elseif nargin == 1% Only matrix is supplied
%                 %find comps, cycles, lcycles, etc.
            elseif nargin == 4% Matrix + components + adjacencies + cycles
                Sp=mmp.l.Spectrum.of_connected_digraph(A);
            else
                error('mmp:Spectrum','Invalid constructor pattern');
            end
        end
    end
end
