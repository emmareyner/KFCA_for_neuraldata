classdef UFNF_0 < mmp.l.Spectrum.UFNF_cyclic
    % A class to represent the spectrum of a strongly connected matrix.
    properties
        Splus=sparse(0,0);
        % Normalized transitive closure of matrix when lambda is finite.
    end
    methods
        function [S]= UFNF_0(varargin)
            S = S@mmp.l.Spectrum.UFNF_cyclic(varargin{:});
        end
    end
    methods (Static)
        % To return the spectrum of a strongly connected matrix from its
        % value and its cycles.
        [spectrum] =of_digraph(A,mask,lcycles)
%         %To return a basis of eigenvectors from a spectrum list
%         [Levt,Ldiag,Rev,enodes,nodes]=basis(SSpp)
        %To return the left and right eigenvectors from a spectrum
        [Ut,Ldiag,V,Rdiag]=UtSV(S,allevs)
    end
%     methods (Static)
%         % A) ANALYSIS METHODS
%         %
%         %To return the left and right eigenvectors for a matrix, accepting
%         %UFN_3
%         [Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = of_digraph(A,rmask,cmask)
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
%         %
%         % B) SYNTHESIS METHODS
%         %
%         %To return all the left and right eigenvectors from a spectrum list
%         [U,Ldiag,V,Rdiag]=UtSV(S)
% %         %
%         % Z) OBSOLETE METHODS!
%         %
%         %WARNING: The following primitive is obsolete!
%         %To return the spectrum of a completely reducible maxminplus matrix
%         [SP] = of_completely_disconnected_digraph(A,comps)
%     end
end
