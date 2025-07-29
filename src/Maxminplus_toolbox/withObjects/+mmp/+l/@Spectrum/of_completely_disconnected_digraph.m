function [Sp] = of_completely_disconnected_digraph(A, comps)
% [SP] = of_completely_reducible_digraph(A,comps)
% returns the spectrum of a completely reducible maxminplus
% submatrix of A described by the nodes in comps (unitary classes)
%
% - [A] is the matrix being analyzed
%
% - [comps] is a cell array of disconnected components to be joined into a
% single lambda == -Inf class
%
% warning: "THIS method is obsolete". mmp.l.spectrum.of_digraph no longer
% needs it!. Use at your own risk!
%Initialize spectrum
warning('mmp:l:Spectrum:of_completely_disconnected_digraph',...
    'THIS method is obsolete! mmp.l.spectrum.of_digraph no longer needs it!. Use at your own risk!');
nCs = cellfun(@(c) size(c,2), comps);
nC = sum(nCs);
if nC == 0
    error('mmp:l:Spectrum:of_completely_disconnected_digraph','No disconnected component')
end
%Create empty spectrum and fill up following convention
Sp=mmp.l.Spectrum();%Everythings is empty by default
Sp.comps = comps;%Gathered completely reducible components
Sp.nodes=cell2mat(comps);%Gathered nodes
%Sp.order = cell(1,nC);
for i=find(nCs > 1)
    %sCi = size(comps{i},2);
    %if nCs(i) > 1
        warning('mmp:l:Spectrum:of_completely_disconnected_digraph',...
            'Completely reducible component %i has %i nodes!',i,nCs(i));
    %end
end
Sp.order=sparse(nC,nC);
%Sp.order=arrayfun(@(nCi) false(nCi),nCs,'UniformOutput',false);%only one class and totally disconnected
%No cycles with these nodes
Sp.cycles={};

%find global to local inverse order
[snodes,isupp]=sort(Sp.nodes);%sort nodes
m=size(A,1);%number of global nodes
n = size(Sp.nodes,2);
Sp.g2l=sparse(1,m);
Sp.g2l(snodes)=isupp;
Sp.g2ml=ones(1,n);

%Spectral information
Sp.lambdas=double(mmp.l.zeros(1,nC));%Single eigenvalue -Inf
Sp.ec_below=false(1,nC);
Sp.ec_above=false(1,nC);
Sp.ccycles=Sp.cycles;%all critical cycles
Sp.enodes=cellfun(@(n) {{n}},comps);%All are eigennodes
if isa(A,'mmp.Sparse')
    Sp.levs = cellfun(@(n) {{n}}, mat2cell(mmp.l.eye(n), nCs, n));%Decompose eye into levs
    Sp.revs = cellfun(@(n) {{n}}, mat2cell(mmp.l.eye(n), n, nCs));%Decompose eye into levs    
else%it must be a double
    Sp.levs = cellfun(@(n) {{n}}, mat2cell(mmp.l.diag(zeros(1,n)), n, nCs));%Decompose diag into levs
    Sp.revs = cellfun(@(n) {{n}}, mat2cell(mmp.l.diag(zeros(1,n)), nCs, n));%Decompose diag into levs
end
%Sp.revs = Sp.levs;%Why not transpose?
return
