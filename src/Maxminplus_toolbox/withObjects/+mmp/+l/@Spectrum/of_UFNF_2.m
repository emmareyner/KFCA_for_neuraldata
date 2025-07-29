function [spectra,Aplus] = of_UFNF_2(A)
% function [spectra,subdigraphs,orders,Aplus] = mmp.l.Spectrum.of_UFNF_2(A)
% function [spectra,subdigraphs,orders] = mmp.l.Spectrum.of_UFNF_2(A)
%
% A function to calculate the left and right lower spectra, i.e. eigenvalues
% and the bases of their left and right eigenspaces for a possibly
% maxplus-reducible square matrix of real coeficients, [A] with many
% completely reducible subdigraphs. 
%
% CAVEAT: Not requesting the transitive closure results in a substantial
% reduction of time.
%
% [A] may not have any null rows or columns (see of_UFNF_2).
%
% FVA: 2005-2011
%
% Input:
% - [A] a non-empty (n x n) square maxplus matrix with possibly multiple
% subdigraphs.
%
% Output:
% - subdigraphs: a 1 x nS cell array of subdigraphs. comps = subdigraphs{s} is
% a 1 x nCs cell array of components. comps{c} is a row vector with the
% list of vertices in component comps{c}, also called a *class* of A.
%
% - [orders]: is an 1 x nS cell array of matrix of
% booleans. order_s=orders{s} is a nCs x nCs boolean matrix where
% order_s(ci,cj) says whether ci is *upstream* from class cj in the
% subgraph's class diagram. In fact, for each block,i, the i-th row of
% this matrix is describing the support of block i in terms of other
% blocks. Consult subdigraphs{s} to find the actual nodes in each block.
%
% - [spectra] : a 1 x nS cell array of spectra as defined in
% mmp.l.subgraph_spectrum2.%
%
% - When [Aplus] is requested, the transitive closure of [A] is calculated
% and returned; otherwise, it is not.
%
% See also: mmp.l.spectra, mmp.l.of_UFNF_2,
% mmp.l.of_UFNF_1, of_strongly_connected_digraph,
% digraph/crc_scc_cycles
%
% Author: fva Feb, 2009
% Doc:    fva 09/02/08
% OO adaptation: fva 13/04/2009
  
%-------------------------------------------------------------------
% check input values
% Check for rows and columns with mmp.l.zero only?
%-------------------------------------------------------------------
error(nargchk(1,1,nargin));
%m = test_square(A);
spA = issparse(A);%general flag to avoid multiple calls
if isa(A,'double')
    if spA
        error('mmp:l:Spectrum:of_UFNF_2','Direct sparse input not allowed to prevent formatting confusions. Use mmp.x.Sparse, etc.');
    else
        %A = mmp_x_sparse(A);%Full matrices transformed into sparse ones!
        A = mmp.x.Sparse(A);
    end
elseif isa(A,'mmp.x.Sparse')%Do nothing
    %A = A.Reg;%MX sparse encoding
else
    error('mmp:l:Spectrum:subdigraph_spectrum','Wrong input class');
end
Aplusrequested = nargout > 3;

%% 1. Component analysis of A
% - subdigraphs is the set of subdigraphs of G(A) as arrays of components!
% - order is the *condensation graph* of G(A), for *all possible
% components*.
% - cycles is the set of cycles of A for each crc component.
[subdigraphs,orders,allcycles]=digraph.crc_scc_cycles(A);
%nS=number of disconnected subdigraphs (also number of connected digraphs
%that are inside the graph!)
nS=size(subdigraphs,2);
%Check that all are connected!
for s = 1:nS
    if ~any(any(orders{s})),
        error('mmp:l:Spectrum:of_UFNF_2','Disconnected components! Some rows or columns are null!');
    end
end

%% 2.Go over subdigraphs finding spectra.
%%2.1. Process connected components (in general not strongly connected)
%nCS = sum(+is_connected);%number of connected components
%nCS = nS;
spectra=cell(1,nS);
%con=find(is_connected);%indices of connected digraphs
if Aplusrequested
    Aplus=cell(1,nS);
    for s=1:nS
        [spectra{s},Aplus{s}]=mmp.l.Spectrum.of_UFNF_1(A,subdigraphs{s},orders{s},allcycles{s});
    end
else%Aplus not requested
    for s=1:nS
        spectra{s}=mmp.l.Spectrum.of_UFNF_1(A,subdigraphs{s},orders{s},allcycles{s});
    end
end
% %% 2.2 Coalesce disconnected components and append
% %TODO: make a primitive with just the components.
% %Spectrum.of_completely_disconnected_digraph.
% if ~all(is_connected)%If any non-connected componets are left
%     ncon=find(~is_connected);%list of non-connected subdigraphs~
%     Sp = mmp.l.Spectrum.of_completely_disconnected_digraph(A,[subdigraphs{~is_connected}]);
%     %Finally, append to list of spectra
%     spectra{nCS+1}=Sp;
% end
return%[spectra,subdigraphs,orders,Aplus]
  
