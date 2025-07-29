function [Levt,Ldiag,Rev,enodes,nodes]=all_evs(SSpp,allevs)
% function [Lt,Ldiag,V,enodes,nodes]=mmp.l.Spectrum.all_evs(Sp,allevs)
%
% A function to obtain all possible left (transposed) (Levt) and right
% (Rev) eigenvectors of a list of spectra belonging to the same matrix, and
% its correlative [nodes] and eigennodes [enodes]. 
%
% [Ldiag] is the main diagonal with the eigenvalues correlated to the left
% and right eigenvectors, hence if Lambda = mmp.l.diag(Ldiag)
%
% mmp.l.mtimes(Ut,A(Sp.nodes,Sp.nodes)) == mmp.l.mtimes(Lambda,Ut)
% mmp.l.mtimes(A(Sp.nodes,Sp.nodes),V) == mmp.l.mtimes(V,Lambda)
%
% See also: mmp.l.Spectrum.of_digraph
% 
% Author: FVA, 2008-2009
error(nargchk(1,2,nargin));%unnecessary for objects
if nargin < 2, allevs = true; end%By default produce all eigenvectors


nS = size(SSpp,2);%Number of spectra
if (nS <= 0),
    error('mmp:l:Spectrum:all_evs','Empty spectrum list');
end

% Get all possible nodes
%nodes=cell2mat(cellfun(@(s) s.nodes, SSpp))%Doesn't work
switch nS
    case 1%quick exit
        nodes=SSpp{nS}.nodes;
        [Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS},allevs);
    otherwise%The Lt and V matrices are really going to be sparse
        Levts = cell(1,nS);%Stores all TRANSPOSED left evs. by spectrum
        Revs=cell(1,nS);%Stores all right evs. by spectrum
        Ldiags=cell(1,nS);%Stores all eigenvalues by spectrum
        enodess=cell(1,nS);%Stores all eigennodes by spectrum
        nodess=cell(1,nS);%stores all nodes by spectrum
        for s=1:nS,
            [Levts{s},Ldiags{s},Revs{s},enodess{s}]=mmp.l.Spectrum.UtSV(SSpp{s},allevs);
            nodess{s} = SSpp{s}.nodes;
        end

        %enodes=[];ldiag=[];
        Ldiag=cell2mat(Ldiags);
        enodes=cell2mat(enodess);
        nodes=cell2mat(nodess);

        %Now put together right and left eigenvectors
        senodes=size(enodes,2);
        snodes=size(nodes,2);
        %Levt=[Levts{S}];
        Levt=mmp.l.zeros(senodes,snodes);
        Rev=mmp.l.zeros(snodes,senodes);
        rr=0;rc=0; 
        cr=0;cc=0;
        for s=1:nS,
            [sr,sc]=size(Levts{s});
            %sr=size(enodess{s},2);sc=size(Sp.nodes{s},2);
            Levt(rr+(1:sr),rc+(1:sc))=Levts{s};
            [scr,scc]=size(Revs{s});
            Rev(rr+(1:scr),rc+(1:scc))=Revs{s};
            rr=rr+sr;rc=rc+sc;
            cr=cr+scr;cc=cc+scc;
        end
end
return
