classdef UFNF_3 < mmp.l.Spectrum.UFNF
    % A class to represent the spectrum of a connected component in a
    % maxplus matrix.
    properties
        zcols=logical(sparse(1,0));%sparse logical zero columns: non-null value declares a matrix as with zero lines
        zrows=logical(sparse(1,0));%sparse logical zero columns: non-null value declares a matrix as with zero lines
        embedded={};%cell list of spectra
        % if it is of UFNF_3 type, the embedded spectrum has zero-lines
        % if it is of type UFNF_2, the embedded spectrum has no zero-lines
    end
    methods
        function [S]= UFNF_3(A,maskperm)
            switch nargin
                case 1
                    [m,n]=size(A);
                    if m~=n
                        error('mmp:l:Spectrum:UFNF_3','not a square matrix');
                    elseif n == 0
                        error('mmp:l:Spectrum:UFNF_3','empty matrix');
                    end%m~=n
                    maskperm=true(1,n);
                case 2
                otherwise
                    error(nargchk(1,2,nargin))
            end
            [zrows,zcols]=findzeros(A(maskperm,maskperm));
            %Process null-lines: these generate boolean masks
            Vi = zrows & zcols;%isolated nodes
            Va = zcols & ~zrows;%initial nodes
            Vw = zrows & ~zcols;%terminal nodes
            Vb = ~(zrows | zcols);%all the rest            
            %The global permutation to render in UFNF_3 becomes
            newmaskperm=[find(Vi) find(Va) find(Vb) find(Vw)];
            S = S@mmp.l.Spectrum.UFNF(A,newmaskperm);
            %fill in zero rows and cols in local form
            S.zrows = zrows;
            S.zcols = zcols;
        end%UFNF_3
    end%methods
    methods (Static)
        % A) ANALYSIS METHODS
        %
        % To return the UFNF3 spectrum of a matrix in general form
        [S]=of_digraph(A,maskperm)
        % To return the eigenvectors of a spectrum in UFNF_3
        %To return the left and right eigenvectors from a spectrum ready to
        %comply with the eigenequation
        [Ut,Ldiag,V,Rdiag]=UtSV(S,allevs)        
%         %To return the left and right eigenvectors for a matrix, accepting
%         %UFN_3
%         [Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = of_digraph(A)
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
%         % B) SYNTHESIS METHODS
%         %
%         %To return all the left and right eigenvectors from a spectrum list
%         [U,Ldiag,V,enodes,nodes,InfU,InfV]=all_evs(SSpp)
%         %To return a basis of eigenvectors from a spectrum list
%         [Levt,Ldiag,Rev,enodes,nodes]=basis(SSpp)
%         %To return the left and right eigenvectors from a spectrum
%         [Ut,Ldiag,V,cnodes]=UtSV(Sp,allevs)
%         %
%         % Z) OBSOLETE METHODS!
%         %
%         %WARNING: The following primitive is obsolete!
%         %To return the spectrum of a completely reducible maxminplus matrix
%         [SP] = of_completely_disconnected_digraph(A,comps)
    end
end
