function [Ut,Ldiag,V,cnodes]=UtSV(Sp,allevs)
% function [Ut,LDiag,V,cnodes]=mmp.l.Spectrum.UtSV(Sp,allevs)
%
% function [Ut,LDiag,V,lcnodes,rcnodes]=mmp.l.Spectrum.UtSV(Sp,allevs)
%
% A function to obtain the transposed left eigenvectors [Ut], possibly
% repeated eigenvalues [Ldiag] conindexed with them, right eigenvectors [V] and
% left and right critical nodes [lcnodes,rcnodes], of spectrum [Sp].
%
% Input:
% - [Sp]: a single spectrum structure.
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
% - [cnodes]: the list of critical vectors referred to the original
% columns in A, generating each of the eigenvalues and
% eigenvectors when lambda is finite. Consult Sp.nodes.
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
error(nargchk(1,2,nargin));%unnecessary for objects
if nargin < 2, allevs = true; end%By default produce all eigenvectors

% $$$   %Make excess space for levs and revs
% $$$   dim=size(Sp.nodes,2);%dimension of  matrix analized in Sp.
% $$$   Ut=mp_zeros(dim,dim);%left eigenvectors
% $$$   V=mp_zeros(dim,dim);%right eigenvectors
% $$$   Ldiag=mp_zeros(1,dim);%repeated eigenvalues (diagonal of \Lambda)

%% Count classes and stablish decreasing lambda order for canonical form
%Would It be better to check on the number of classes, to do away with
%the very simple irreducible case?
%nC = size(Sp.lambdas,2);
%[kk classes]=sort(Sp.lambdas,'descend');%FVA: do not change order here: do
%it out of this function. Just collect information as per the Upper FNF
m=size(Sp.comps,2);%number of classes
classes = 1:m;

% 1. FIND ALL critical EIGENNODES
if allevs%By default choose all eigenvectors...
    nnodes = cellfun(@(com) cell2mat(com),Sp.enodes,'UniformOutput',false);
else%choose only one eigennode and value for each critical circuit, ie. n indep. eigennodes
    nnodes = cellfun(...
         @(com) cell2mat(cellfun(@(cycle) cycle(1,1), com, 'UniformOutput',false)),...
         Sp.enodes,'UniformOutput',false);
end
cnodes = cell2mat(nnodes);

% 2. Build the diagonal of the Lambda matrix with eigenvalue multiplicities
% either for a basis or for all eigenvectors
nclasses = (arrayfun(@(cl) arrayfun(@(n) cl, nnodes{cl}), classes, 'UniformOutput',false));
Ldiag = Sp.lambdas(cell2mat(nclasses));


ncnodes=size(cnodes,2);%number of chosen fundamental eigenvectors
dim=size(Sp.nodes,2);%Length of eigenvectors
%This should be made sparse or full depending on the original matrix!
%if issparse(Sp.levs{1}{1})
if isa(Sp.levs{1}{1},'mmp.Sparse')
    V = mmp.l.zeros(dim,ncnodes);
    Ut = mmp.l.zeros(ncnodes,dim);
else
    V=-Inf(dim,ncnodes);
    Ut=-Inf(ncnodes,dim);
end
% V = cell2mat(...
%     arrayfun(@(cl)...
%         cellfun(@(cy) cy(:,1),Sp.revs{cl},'UniformOutput',false),...
%         classes,'UniformOutput',false));

%% Go over classes collecting eigenvectors
nevs=0;%counter for chosen eigenvectors
for c=classes
    revs=Sp.revs{c};
    levs=Sp.levs{c};
    for list=1:size(revs,2)%Same as size(levs,2)
        if allevs%to obtain all evs do
            incr = size(revs{list},2);
            %V(:,nevs+(1:incr))=revs{list};
        else
            incr = 1;
        end
        V(:,nevs+(1:incr))=revs{list}(:,1:incr);
        Ut(nevs+(1:incr),:)=levs{list}(1:incr,:);
        nevs = nevs + incr;
    end
end
% for c=classes
%     these_levs=cell2mat(Sp.levs{c}');%Left evs
%     these_revs=cell2mat(Sp.revs{c});%Right evs
% %    if isproperty(Sp,'cnodes')
%         ecnodes=cell2mat(Sp.cnodes{c});%This Class' Critical NODES
% %    else%We actually have to obtain them
% %         %Any eigenvector for this class may be repeated!
% %         %- Select unique cnodes
% %         [unique_cnodes,Iuni]=unique(Sp.nodes{c});
% %         %- Select cnodes that may generate different eigenvectors.
% %         %- Test the proportional factor (distance) of other chosen revs
% %         %to that of the candidate.
% %         suni=size(Iuni,2);
% %         ecnodes=false(1,suni);%Index on unique, effective critical nodes
% %         %for cnode=find(~ecnodes)
% %         for cnode=1:suni
% %             ecnodes(cnode)=...
% %                 all(these_revs(unique_cnodes(ecnodes),cnode)~=0);
% %         end
% %         ecnodes=find(ecnodes);
% %     end
% 
%     %Now store only those eigenvectors related to effective nodes
%     ncnodes=length(ecnodes);%At least one
%     range=nevs+1:ncnodes;%This range is at least of length one.
%     nevs=nevs+ncnodes;%update no. of effective eigenvectors.
%     %cnodes=[cnodes ecnodes];%effective overal critical nodes
%     V(:,range)=these_revs;%Effective right evs.
%     Ut(range,:)=these_levs;%Effective left evs.
%     Ldiag(1,range)=Sp.lambdas(c);%This class' eigenvalue.
% end%for c=classes

return%Lt, Ldiag, R, cnodes

