classdef UFNF_cyclic < mmp.l.Spectrum.UFNF
    % An abstract class to represent the spectrum of matrices with cycles,
    % that is of types UFNF_2, _1 and _0
    properties
        cycles = {};%cycles for each component. Maybe only crit. cycles
        ccycles={};%indices of critical cycles in [cycles]: last level of indirection are the indices. 
    end
    methods
        function [S]= UFNF_cyclic(A,maskperm,cycles)%A,maskperm,cycles
            if nargin < 3
                error('mmp:l:Spectrum:UFNF_cyclic:of_digraph','missing parameters in constructor');
                % Sanity check! check input values
                % If matrix is completely reducible, then give an error.
            elseif isempty(cycles)%nocycles entails completely reducible
                 error('mmp:l:Spectrum:UFNF_cyclic:of_digraph','component with no cycles');
            end
            S = S@mmp.l.Spectrum.UFNF(A,maskperm);
            %This should be changed into the local nodes by using S.g2l
            %and S.nodes
            S.cycles = cycles;
        end%UFNF_3
    end
    methods (Abstract,Static)
        % A) ANALYSIS METHODS
        %
        %To return the spectrum of a matrix with cycles
        %UFN_3
        [Sp] = of_digraph(A,maskperm,lcycles)
        % B) SYNTHESIS METHODS
        %
        %To return all the left and right eigenvectors from a spectrum list
        [U,Ldiag,V,Rdiag]=UtSV(S,allevs)
    end
end
