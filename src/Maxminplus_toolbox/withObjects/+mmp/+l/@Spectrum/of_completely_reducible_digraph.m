function [Sp] = of_completely_reducible_digraph(A, comps)
% [SP] = of_completely_reducible_digraph(A,comps)
%To return the spectrum of a completely reducible maxminplus matrix
    Sp=mmp.l.Spectrum();%Everythings is empty by default
    Sp.order=false;%only one class and totally disconnected
    Sp.nodes=cell2mat(comps);
    Sp.comps = {Sp.nodes};
    %Sp.cycles={};%No cycles with these nodes
    %find global to local inverse order
    [snodes,isupp]=sort(Sp.nodes);%sort nodes
    m=size(A,1);%number of global nodes
    n = size(Sp.nodes,2);
    Sp.g2l=sparse(1,m);
    Sp.g2l(snodes)=isupp;
    Sp.g2ml=ones(1,n);
    Sp.ec_below=false;
    Sp.ec_above=false;
    %Spectral information
    Sp.lambdas=mmp.l.zeros;%Single eigenvalue -Inf
    %Sp.ccycles={};%no critical cycles
    Sp.enodes=Sp.nodes;%All are eigennodes
    if isa(A,'mmp.Sparse')
        Sp.levs = mmp.l.eye(n);
        Sp.revs = mmp.l.eye(n);
    else%it must be a double
        Sp.levs = mmp.l.diag(zeros(1,n));
        Sp.revs = Sp.levs;
    end
return
