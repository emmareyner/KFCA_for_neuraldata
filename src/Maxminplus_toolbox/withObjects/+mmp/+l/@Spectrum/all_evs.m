function [Lev,Ldiag,Rev,enodes,nodes,InfLev,InfRev]=all_evs(SSpp,Infevs)
% function [U,Ldiag,V,enodes,nodes]=mmp.l.Spectrum.all_evs(Sp)
%
% A function to obtain all possible left (U) and right
% (V) eigenvectors of a list of spectra belonging to the same matrix, and
% its correlative [nodes] and eigennodes [enodes]. 
% 
%  function [U,Ldiag,V,enodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(Sp)
% If InfU or InfV are requested, then spureous eigenvectors for the top
% eigenvalue are also returned.
%
% Inputs:
% - [SSPP], the list of spectra whose eigenvalues are to be extracted.
%
% Outputs:
% - [Ldiag] is the main diagonal with the eigenvalues correlated to the left
% and right eigenvectors, hence if Lambda = mmp.l.diag(Ldiag):
% 
% mmp.l.mtimes(Ut,A(Sp.nodes,Sp.nodes)) == mmp.l.mtimes(Lambda,Ut)
% mmp.l.mtimes(A(Sp.nodes,Sp.nodes),V) == mmp.l.mtimes(V,Lambda)
%
% See also: mmp.l.Spectrum.of_digraph
% 
% Author: FVA, 2008-2009
%error(nargchk(0,7,nargout));%unnecessary for objects
if nargin < 2
    Infevs = nargout;
end

nS = size(SSpp,2);%Number of spectra
% Get all possible nodes
%nodes=cell2mat(cellfun(@(s) s.nodes, SSpp))%Doesn't work
switch nS
    case 0
        error('mmp:l:Spectrum:all_evs','Empty spectrum list');        
    case 1%quick exit
        nodes=SSpp{nS}.nodes;
        [Lev,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS},true);
    otherwise%The Lt and V matrices are going to be really sparse
        Levs = cell(1,nS);%Stores all  left evs. by spectrum
        Revs=cell(1,nS);%Stores all right evs. by spectrum
        Ldiags=cell(1,nS);%Stores all eigenvalues by spectrum
        enodess=cell(1,nS);%Stores all eigennodes by spectrum
        nodess=cell(1,nS);%stores all nodes by spectrum
        for s=1:nS,
            [Levs{s},Ldiags{s},Revs{s},enodess{s}]=mmp.l.Spectrum.UtSV(SSpp{s},true);
            nodess{s} = SSpp{s}.nodes;
        end

        %enodes=[];ldiag=[];
        Ldiag=cell2mat(Ldiags);
        enodes=cell2mat(enodess);
        nodes=cell2mat(nodess);

        %Now put together right and left eigenvectors
        senodes=size(enodes,2);
        snodes=size(nodes,2);
        %Lev=[Levs{S}];
        Rev=mmp.l.zeros(snodes,senodes);
        Lev=mmp.l.zeros(senodes,snodes);
        rr=0;rc=0;%Right eigenvectors accumulated row and column
        lr=0;lc=0;%Left eigenvectors accumulated row and column
        for s=1:nS
            [scr,scc]=size(Revs{s});
            Rev(rr+(1:scr),rc+(1:scc))=Revs{s};
            rr=rr+scr;
            rc=rc+scc;
            %sr=size(enodess{s},2);sc=size(Sp.nodes{s},2);
            [sr,sc]=size(Levs{s});
            Lev(lr+(1:sr),lc+(1:sc))=Levs{s};
            lr=lr+sr;
            lc=lc+sc;
        end
end
%if the trivial eigenvectors of eigenvalue INf are requested:
if Infevs
    InfRev = mmp.l.mtimes(Inf,Rev);
    [un,idx]=unique(double(InfRev)','rows');
    InfRev = InfRev(:,idx');
    InfLev = mmp.l.mtimes(Inf,Lev);
    [un,idx]=unique(double(InfLev),'rows');
    InfLev = InfLev(idx,:);
end
return
