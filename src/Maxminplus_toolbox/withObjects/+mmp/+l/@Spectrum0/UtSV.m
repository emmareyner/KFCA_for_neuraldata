function [Ut,Ldiag,V,lcnodes,rcnodes]=UtSV(S,allevs)
% function [Ut,LDiag,V,lcnodes,rcnodes]=mmp.l.Spectrum.UtSV(S,allevs)
%
% function [Ut,LDiag,V,lcnodes,rcnodes]=mmp.l.Spectrum.UtSV(S,allevs)
%
% A function to obtain the transposed left eigenvectors [Ut], possibly
% repeated eigenvalues [Ldiag] conindexed with them, right eigenvectors [V] and
% left and right critical nodes [lcnodes,rcnodes], of spectrum [S].
%
% Input:
% - [S]: a single spectrum structure.
% - [allevs]: an optional parameter demanding to obtain all eigenvectors if
% true and only a basis of eigenvectors for Sp if false. Default is true.
%
% Output:
% - [Ut] : transposed (row indexed) list of left eigenvectors, coindexed with Ldiag.
% If ~allevs, this is a basis for the left eigenspace.
% - [Ldiag]: a list of eigenvalues coindexed with the left and right
% eigenvectors, in descending value order.
% - [V] : column-indexed list of right eigenvectors.
% eigenvectors, coindexed with Ldiag.  If ~allevs, this is a basis for the
% left eigenspace.
% - [rcnodes]: the list of critical vectors referred to the original
% columns in A, generating each of the eigenvalues and
% eigenvectors when lambda is finite. [lcnodes] keeps the list of critical
% rows which may be different to [rcnodes] in case S.alpha == mmp.l.tops
%
% If lambda is the top, return the left and right eigennodes in different
% vars.
%
% The eigenequations are (where A is a matrix part of whose spectrum is Sp:
% let Lambda = mpm.l.diag(S);
% mmp.l.eq(mmp.l.mtimes(Ut,A(Sp.nodes,Sp.nodes)),mmp.l.mtimes(Lambda,Ut))
% mmp.l.eq(mmp.l.mtimes(A(Sp.nodes,Sp.nodes),V),mmp.l.mtimes(V,Lambda))
%
%
% FVA, Apr.-Jun. 2008, Sep. 2010
    
% check input values
%error(nargchk(1,2,nargin));%unnecessary for objects
if nargin < 2, allevs = true; end%By default produce all eigenvectors

lcnodes = S.lenodes;
rcnodes = S.enodes;

if allevs
        Ut = S.Splus(lcnodes,:);
        V = S.Splus(:,rcnodes);
        Ldiag=mmp.l.diag(repmat(S.lambda,1,length(lcnodes)));
else
    error('mmp:l:Spectrum0.UtSV','Basis selection not implemented');
end

return%Lt, Ldiag, R, cnodes

