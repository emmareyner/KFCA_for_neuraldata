function S = of_digraph(A,mask,allcycles,orders,subdigraphs)
% function  S = of_digraph(A,mask)
%
% A function to calculate the left and right lower spectra, i.e. eigenvalues
% and the bases of their left and right eigenspaces for a possibly
% maxplus-reducible square matrix of real coeficients, [A] with many
% completely reducible subdigraphs. 
%
% CAVEAT: Not requesting the transitive closure results in a substantial
% reduction of time.
%
% [A] may not have any null rows or columns (see of_digraph_no_zero_lines).
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
% See also: mmp.l.spectra, mmp.l.of_digraph_no_zero_lines,
% mmp.l.of_connected_digraph, of_strongly_connected_digraph,
% digraph/crc_scc_cycles
%
% Author: fva Feb, 2009
% Doc:    fva 09/02/08
% OO adaptation: fva 13/04/2009
% Moved to OO UFNF_classes 04/2011
error(nargchk(5,5,nargin));

%% 1. Component analysis of A
% - subdigraphs is the set of subdigraphs of G(A) as arrays of components!
% - order is the *condensation graph* of G(A), for *all possible
% components*.
% - cycles is the set of cycles of A for each crc component.
[subdigraphs,orders,allcycles]=digraph.crc_scc_cycles(A(mask,mask));
S = mmp.l.Spectrum.UFNF_2(A,mask,allcycles,orders,subdigraphs);

%% 2.Go over subdigraphs finding spectra.
nS=size(subdigraphs,2);
S.spectra=cell(1,nS);
for s=1:nS
    S.spectra{s}=mmp.l.Spectrum.UFNF_1.of_digraph(A,subdigraphs{s},allcycles{s},orders{s});
end
return%S
  
