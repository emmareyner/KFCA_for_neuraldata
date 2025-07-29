function [Ut,Ldiag,V,Rdiag]=UtSV(S,allevs)
% function [Ut,LDiag,V,RDiag]=mmp.l.Spectrum.UtSV(S,allevs)
%
% function [Ut,LDiag,V,RDiag]=mmp.l.Spectrum.UtSV(S,allevs)
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
% Eigenvectors will be columns of the following 
if S.lambdas < mmp.l.tops
    Aplus = S.Splus;
else
    n = length(S.nodes);
    Aplus = mmp.u.eye(n);%not really a trans. closure
end
% Eigenvectors for the top eigenvalue are all incomparable and part of the
% basis. 
if allevs || (S.lambdas == mmp.l.tops)
    lenodes = cell2mat(S.lenodes);
    renodes = cell2mat(S.renodes);
else%a single representative eigenvector
    lenodes=cellfun(@(c) c(1), S.ccycles);
    renodes=lenodes;
    %error('mmp:l:Spectrum:UFNF_0:UtSV','Basis selection not implemented');
end
nl = length(lenodes);
nr = length(renodes);
Ldiag=mmp.l.diag(repmat(S.lambdas,1,nl));
Rdiag=mmp.l.diag(repmat(S.lambdas,1,nr));
Ut = Aplus(lenodes,:);
V = Aplus(:,renodes);
return%Lt, Ldiag, R, cnodes

