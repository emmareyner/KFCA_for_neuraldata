%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matrix examples from several papers.

%% An irreducible maxplus matrix whose Spectrum is known. Obtained from
%Akian,Bapat, Gaubert, 2006, Example 25.1.3
% This also serves as test for double (full) matrices.
M = [-Inf 11 8;
     2 5 7;
     2 6 4];
% tic
% mmp.l.trclosure(M)
% toc
ABG06a.M=M
% This matrix is irreducible, has rho_max = 20/3
ABG06a.Sp.lambdas=[20/3];
% The critical graph is (1,2)(2,3)(3,1)
% The single eigenvector is a multiple of: /3 -14/3]'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%A=sparse(M);
debugABG06a=false;
if debugABG06a
    %%% CLOSURES
    Inf(3) == mmp.l.trclosure(M)%All Infs
    %the definite closure of the matrix is:
    Mnorm=mmp.l.mrdivide(M,ABG06a.Sp.lambdas);
    Mplus = mmp.l.tclosure(Mnorm);
    %This is also the closure
    Mstar = mmp.l.trclosure(Mnorm);
    %Check some basic identities of stars
    all(all(Mplus == mmp.l.mtimes(Mnorm,Mstar)))
    all(all(mmp.l.mtimes(Mplus,Mnorm) == mmp.l.mtimes(Mnorm,Mplus)))
    all(all(mmp.l.mtimes(Mstar,Mnorm) == mmp.l.mtimes(Mnorm,Mstar)))
    % find cycles in double format
    [subgraph,order,cycle]=digraph.crc_scc_cycles(M);
    Mxp=mmp.x.Sparse(M);% find cycles in maxplus encoding
    [subgraph,order,cycle]=digraph.crc_scc_cycles(Mxp);
    Mnp=mmp.n.Sparse(M);% find cycles in minplus encoding
    [subgraph,order,cycle]=digraph.crc_scc_cycles(Mnp);
end

%% A reducible maxplus matrix whose Spectrum is known. Obtained 
% from Akian,  Bapat, Gaubert, 2006, Example 25.3.2.
%This matrix is reducible and has:
% - only one completely reducible component (connected subdigraph)
% - strongly connected components: C1 = {1}, C2={2,3,4},C3={5,6,7},C4={8}
% - lambdas = [0 2 1 -3] maxplus eigenvalues of the reducible matrices.
% So the total lambda is 2 and class C4 doesn't have an eigenvalue or an
% eigenspace, except in cmaxplus.
% - the basic classes are those s.t. (lambda(A(Ci,Ci)) = lambda(A)):
%     e.g. C2 in this case.
% - the critical subgraph for the whole matrix is
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M=-Inf(8,8);
M(1,1)=0;M(1,3)=0;M(1,5) = 7;
%M(2:4,1) = xp_zeros(1,3);
M(2,3:4)=[3 0];
M(3:4,2)=[1; 2];
%M(2:4,5:7)=xp_zeros(3,3); 
M(4,8) = 10;
%M(5:7,1:4)=xp_zeros(3,4);
M(5,5:6)=[1 0];
M(6,7)=0;
M(7,5:6)= [-1 2];
%M(5:7,5:7)=[1 mmp.x.one mmp.x.zero; mmp.x.zero mmp.x.zero 0; -1 2 mmp.x.zero]
M(7,8)=23;
%M(8,1:7)=mmp.x.zeros(1,7);
M(8,8)=-3;
%A=mmp.Double.sparse(M);

ABG06b.M=M%Akian, Bapat, Gaubert, 06
%Only one completely reducible Spectrum.
ABG06b.Sp={};
ABG06b.Sp{1}.sspectra=1;%size of spectra: Only one spectrum
ABG06b.Sp{1}.comps={[1] [2 3 4] [5 6 7] [8]};
ABG06b.Sp{1}.cnodes=[1 2 3 5 6 7 8];
ABG06b.Sp{1}.lambdas=[0 2 1 -3];
ABG06b.Sp{1}.ec_below=[0 0 0 1];
ABG06b.Sp{1}.ec_above=[1 0 0 0];
% % SOme of the right eigenvectors are:
% % $$$ revs{1} = mmp.x.eye(size(A,1),1);
% % $$$ revs{2} = [-3 0 -1 0 -Inf -Inf -Inf -Inf]'
% % $$$ revs{3} = [5 -Inf -Inf -Inf -1 0 1 -Inf;
% % $$$            6 -Inf -Inf -Inf 0 -3 -2 -Inf]';
%% 
clear A
debugABG06b = false;
if debugABG06b
    l=[0 2 1 -3];
    r = size(ABG06b.Sp{1}.comps,2);
    Sp = ABG06b.Sp{1};
    for c = 1:r
        nodes = Sp.comps{c};
        for k = 1:r
            A{c}{k}=M(nodes,Sp.comps{k});
        end
        Aplus{c}=mmp.l.tclosure(mmp.l.mldivide(l(c),A{c}{c}))
        enodes{c} = find(mmp.l.diag(Aplus{c})==mmp.l.ones);
        revs{c}=Aplus{c}(:,enodes{c})
        levs{c}=Aplus{c}(enodes{c},:)
        mmp.l.mtimes(A{c}{c},revs{c})==mmp.l.mtimes(revs{c},l(c))
        mmp.l.mtimes(levs{c},A{c}{c})==mmp.l.mtimes(levs{c},l(c))
        
   end
end

%% Start debugging
% % Reorder left and reight eigenvectors for easier picturing.
% [kk cycs]=sort(allcycs);
% allrevs=allrevs(:,cycs);%Order to make evident zeros in diagonal
% alllevs=alllevs(cycs,:);
debugABG06b=false;
if debugABG06b
    %prelude for debugging specific irreducible submatrices.
    %For testing mmp.l.double rep
    %X=mmp.l.Double(M);
    %A=X;
    %For testing mmp.x.sparse rep
    %X=A;
    %The primitives one after the other
    [subgraphs,adjacencies,allcycles]=digraph.crc_scc_cycles(M);
    %this only has a disconnected subdigraph
    s=1;
    comps=subgraphs{s};
    adj=adjacencies{s};
    cycles=allcycles{s};
    %let's find its spectrum
    A=ABG06b.M;
    profile on
    Sp=mmp.l.Spectrum(A,comps,adj,cycles)
    %profile off
    profile viewer
    profile off
    %the first submatrix is completely reducible.
    c=1
    %pick up some stuff from subdigraph_spectrum
    lcycles=mlcycles
    S=M(comps{c},comps{c})
    [quasi_inverses{c},lambdas(c),ccindex] =...
        mmp.l.Spectrum.of_strongly_connected_digraph(A,lcycles)%OK for unitary class
    %the second submatrix is irreducible with nodes 5,6,7
    c=2
    %%% first process at ordered_subgraph_spectrum with
    %Then process the following
    lcycles=mlcycles;
    S=X(comps{c},comps{c})
    %%Then process at eigenspce_irreducible
    [quasi_inverses{c},Sp.lambdas(c),ccindex] =...
        of_strongly_connected_digraph(lcycles,S)
    lambda=2
    %[Sp] = ordered_subgraph_spectrum2(comps,order,cycles,A)
    %[subgraphs,orders,spectra]=spectra2(A)
    SpA = mmp.x.Sparse(A);
    %dosparse=true;
    profile on 
    if dosparse
        [SSPP,subgraphs,orders] = mmp.l.Spectrum.of_digraph(SpA);
    else
        [SSPP,subgraphs,orders] = mmp.l.Spectrum.of_digraph(A);
    end
%    Sp=mmp.l.Spectrum(A,comps,adj,cycles)
    %profile off
    profile viewer
    profile off
    [Ut,Ldiag,V,cnodes,nodes]=mmp.l.Spectrum.all_evs(SSPP)
    %SSpp=spectra;
    Sp=SSPP{1};
    %[Ut,Ldiag,V,cnodes]=mmp.l.Spectrum.UtSV(Sp)
    %The eigenvector equations
    (mmp.l.mtimes(Ut,A(Sp.nodes,Sp.nodes)) == mmp.l.mtimes(mmp.l.diag(Ldiag),Ut))
    (mmp.l.mtimes(A(Sp.nodes, Sp.nodes),V) == mmp.l.mtimes(V,mmp.l.diag(Ldiag)))
    % This is a scheme to obtain the eigenvalues with saturated support from a
    %matrix
    Aplus = mmp.l.tclosure(A);
    V=[];
    for i = 1:8
        if Aplus(i,i) ~= -Inf, V = [V mmp.l.stimes(Inf,Aplus(:,i))]; end
    end
    mmp.l.mtimes(A,V) == V %eigenvalue e = 0
    mmp.l.mtimes(A,V) == mmp.l.stimes(Inf,V) %also, eigenvalue Top
    mmp.l.mtimes(A,V) == mmp.l.stimes(1,V) %also any finite eigenvalue
    not(all(all(mmp.l.mtimes(A,V) == mmp.l.stimes(-Inf,V)))) %but not the bottom eigenvalue!
    
    AdjV = zeros(8,8);
    for i=1:8
        for j=1:8
            AdjV(i,j) = all(V(:,i) == V(:,j));
        end
    end
end%if debug

%% ABG06bdouble A Diagonal duplication of the above matrix to make the
%% graph  disconnected
M = -Inf(20);
M(1:8,1:8) = ABG06b.M;
M(11:18,11:18) = ABG06b.M;

ABG06bdouble.M = M;
%Two components. Each with the same lambdas as ABG06.b
ABG06bdouble.Sp{1} = ABG06b.Sp{1};
ABG06bdouble.Sp{2}.cnodes = ABG06b.Sp{1}.cnodes+10;
% for i = 1:size(ABG06bdouble.Sp{2}.comps,2)
%     ABG06bdouble.Sp{2}.comps{i} = ABG06b.Sp{1}.comps{i}+10;
% end

%% ABG06p Let's perturb the above matrix to obtain the top eigenvalue
%%Change ABG05a to an Infinity driven 
% Hay nuevo autovectores del autovalor Inf.
% Primero los autovalores de la clase Inf.
M = ABG06b.M;
S=M(2:4,2:4);S(1,2)=Inf;%S(1,3)=Inf;
M(2:4,2:4)=S;
ABG06p.M=M
%The matrix should still be reducible
ABG06p.Sp.lambdas=[0 Inf 1 -3];
debugABG06p = false;
if debugABG06p
    % NOT DEBUGGED 09/2010
    VS=[Inf 0 Inf; Inf Inf 0]'%Cannot use -Inf in the unspecified coordinate, since it
    %would not generate an eigenvector with full
    %support
    mmp.x.multi(S,VS)==mmp.x.multi(VS, Inf)
    VInf=mmp.x.zeros(size(M,1),size(VS,2));VInf(2:4,1:2)=VS
    mmp.x.multi(M,VInf)==mmp.x.multi(VInf,Inf)
    ABG06p.Sp.comps=ABG06b.Sp.comps;
    ABG06p.Sp.ec_below=ABG06b.Sp.ec_below;
    ABG06p.Sp.ec_above=ABG06b.Sp.ec_above;
end

% ev2=[mpm_zero mpm_zero mpm_zero mpm_zero mmp.x.zero mmp.x.zero mmp.x.zero mmp.x.zero]'
% mmp.x.multi(A,ev2)==mmp.x.multi(ev2,mpm_zero)

%A(5,5)=Inf;%Inf on class 3
% ev3=[mpm_zero mmp.x.zero mmp.x.zero mmp.x.zero mpm_zero mpm_zero mpm_zero mmp.x.zero]'
% mmp.x.multi(A,ev3)==mmp.x.multi(ev3,mpm_zero)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% A matrix from Chen et al. 90 mmp. 260
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=-Inf(7);
A(1,[2 7])=[1 3];
A(2,[1 3])=[3 1];
A(3,4)=4;
A(4,[5 6])=[2 2];
A(5,3)=3;
A(6,7)=2;
A(7,6)=2;
CHEN90.M=A
%%-1 independent component
%%-3 strongly connected components, mu=[2 4 2]
CHEN90.Sp.lambdas=[2 3 2];
CHEN90.Sp.comps={[1 2] [3 4 5] [6 7]};
%%- class order:
CHEN90.Sp.order=...
   exp( [0 0 0;
     -Inf 0 0;
     -Inf -Inf 0]);

% C1 is eclipsed from above by C2 but not C3
% C3 is eclipsed from below by C2 but not C1
CHEN90.Sp.ec_above = [0 0 1];
CHEN90.Sp.ec_below = [1 0 0];
%This matrix has the peculiarity that:
%- since nodes 3 can be reached from 5 by an arc of weight mcm(C2)==3, they generate 1 single
%(l,r)-eigenvector.
%- since nodes 6 can be reached from 7 by an arc of weight mcm(C3)==2, they
%generate 1 single (l,r)-eigenvector.
%CHEN90

% allrevs =
% 
%      0    -1    -4    -3    -4   Inf   Inf
%      1     0    -2    -1    -2   Inf   Inf
%   -Inf  -Inf     0     1     0   Inf   Inf
%   -Inf  -Inf    -1     0    -1   Inf   Inf
%   -Inf  -Inf     0     1     0   Inf   Inf
%   -Inf  -Inf  -Inf  -Inf  -Inf     0     0
%   -Inf  -Inf  -Inf  -Inf  -Inf     0     0
% 
% allrevs =
% 
%      0    -1    -4    -3    -4   Inf   Inf
%      1     0    -2    -1    -2   Inf   Inf
%   -Inf  -Inf     0     1     0   Inf   Inf
%   -Inf  -Inf    -1     0    -1   Inf   Inf
%   -Inf  -Inf     0     1     0   Inf   Inf
%   -Inf  -Inf  -Inf  -Inf  -Inf     0     0
%   -Inf  -Inf  -Inf  -Inf  -Inf     0     0

%% Gaubert, These, mmp. 136.
%%-1 subgraph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=4;
A=[   1 -Inf -Inf -Inf;
      0    0    4 -Inf;
   -Inf    6 -Inf -Inf;
      0 -Inf -Inf    4];
GAU92a.M=A
GAU92a.Sp.ldiag=[5 5 4 1];
GAU92a.Sp.cnodes=[2 3 4 1];
GAU92a.Sp.Ut=...
    [-5     0    -1  -Inf;
    -4     1     0  -Inf;
    -4  -Inf  -Inf     0;
     0  -Inf  -Inf  -Inf];
GAU92a.Sp.V =...
    [-Inf  -Inf  -Inf     0,
        0    -1  -Inf   Inf;
        1     0  -Inf   Inf;
     -Inf  -Inf     0   Inf];

%% Another Matrix from Gaubert's thesis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M=-Inf(6);
M(1,2)=2;
M(2,1)=4;M(2,3)=mmp.l.ones(1);
M(3,2)=mmp.l.ones(1);M(3,3)=3;
M(4,5)=1;
M(5,2)=mmp.l.ones(1);M(5,4)=3;
M(6,2)=4;M(6,5)=3;
GAU92b.M=mmp.x.Sparse(M)
all(all(double(GAU92b.M) == M));

%% Butkovic, Gaubert, Cuninghame-Green 2009 mmp.7, p. 1419
% Actually a block matrix with two subgraphs. The actual values are ours
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=6;
lambdas = [ 3 3 2 5 3 2];
A = mmp.l.diag(lambdas);
A(1,4)= 0;
A(2,[3,4])=[0 0];
A(3,4)=0;
A(5,6)=0;
BGCG09a.M=A
BGCG09a.Sp.ldiag = sort(lambdas,'descend');
BGCG09a.Sp.lambdas = lambdas;
BGCG09a.Sp.ec_above = [0 0 1 0 0 1];
BGCG09a.Sp.ec_below = [1 1 1 0 0 0];

%% Butkovic, Gaubert, Cuninghame-Green 2009, p.1421
%many classes. Only eigenvalues are known and whether they are spectral or
%not. Reducible but not completely reducible
n = 14;
%A = mmp.l.zeros(n);
lambdas = [5, 9, 3, 4, 6, 8, 3,12, 7,2,13,10,8,8];
A = mmp.l.diag(lambdas);
A(1,[3,4])=0;
A(2,5)=0;
A(3,6)=0;
A(4,[5,6,7])=0;
A(5,[7,8])=0;
A(6,[9,10])=0;
A(7,10)=0;
A(8,[11,12])=0;
A(9,13)=0;
A(10,14)=0;

BGCG09b.M=mmp.x.Sparse(A)%Put into a structure
%[sorted idx]=sort(lambdas,2,'descend');
BGCG09b.Sp.ldiag = lambdas;
BGCG09b.Sp.comps = num2cell(1:n);

%% Butkovic 2010, ex. 4.3.7 p. 81
A=[7 9 5 5 3 7;
    7 5 2 7 0 4;
    8 0 3 3 8 0;
    7 2 5 7 9 5;
    4 2 6 6 8 8;
    3 0 5 7 1 2]
rho=8
normA = mmp.l.mldivide(rho,A)
normAplus = mmp.l.tclosure(normA)
mmp.l.mtimes(A,normAplus)==mmp.l.mtimes(normAplus,rho)
%The lattice is isomorphic to 1+2^2+1

%% Butkovic 2010, ex. 4.3.8 on p.81
A=-Inf(4);
%The three components
A(1:2,1:2)=[0 3; 1 -1];% K =1
A(3,3)=2;%K=2
A(4,4)=1%K=3
K=3;
%Create the different spectra
SSPP={};
%SSPP=repmat(mmp.l.Spectrum(),1,K);%Doesn't work properly
for k=1:K
    SSPP{k}=mmp.l.Spectrum();
%   SSPP(1,k)=mmp.l.Spectrum();
end
% The overall spectrum
RealS = mmp.l.Spectrum();
%individual lambdas and whole set
SSPP{1}.lambdas=[2];
SSPP{2}.lambdas=[2];
SSPP{3}.lambdas=[1];
%To do the processing of every spectra!
RealS.lambdas=sort(unique(cell2mat(cellfun(@(s) s.lambdas,SSPP,'UniformOutput',false))),'descend');
%Eigenvectors and eigenvalues have to be combined as in a product of
%domains!

%% Cuninghame-Green, 1979, p. 189
%This example is wrongly analyzed in CG79. There are three critical nodes
% 1 - 2 - 1, 3-3 and 1-3-2-1
% IMPORTANT!
% The longer circuit engulfs the othe two so that there is a single class
% in the critical digraph!!
B = [-1 -3 -1 -2;
        3 -2 -5 0;
        -6 -2 0 -3;
        -5 -5 -4 -2]
CG79_p189.M = B;
 
%% Ma, Gao, Dai et al, 05. mmp. 3
% This matrix rather belongs in the completed maxplus semiring.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=8;
A=mmp.l.zeros(n);
A(1:2,1:4)=...
    [2 8 3 6;
     20 5 2 5];
A(3:4,3:4)=[0 4; 10 12];
A(1:4,5:6)=ones(4,2);%Maybe some other values are needed.
A(5:6,5:6)=[2 4; 10 5];
A(7:8,1:6)=ones(2,6);
A(7:8,7:8)=[3 0; 6 3];
MGD05.M=A;
MGD05.Sp.comps={[7 8]  [1 2]  [3 4]  [5 6]};
MGD05.Sp.ec_below=[0 0 1 1];
MGD05.Sp.ec_above=[1 0 0 0];
MGD05.Sp.nodes=[7 8 1 2 3 4 5 6];
MGD05.Sp.lambdas=[3 14 12 7];
%S=A(7:8,7:8)
MGD05.Sp.cnodes=[1 2 4 5 6 7 8];
% The following are ALL the eigenvectors for the critical nodes, not just
% the independent ones.
MGD05.Sp.Ut=...
 [-Inf  -Inf     0    -6   -11    -8   -13   -13;
  -Inf  -Inf     6     0    -5    -2    -7    -7;
  -Inf  -Inf  -Inf  -Inf    -2     0   -11   -11;
  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf     0    -3;
  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf     3     0;
     0    -3   Inf   Inf   Inf   Inf   Inf   Inf;
     3     0   Inf   Inf   Inf   Inf   Inf   Inf];

MGD05.Sp.V=...
  [ -7   -13   Inf   Inf   Inf     0    -3;
    -7   -13   Inf   Inf   Inf     3     0;
     0    -6   Inf   Inf   Inf  -Inf  -Inf;
     6     0   Inf   Inf   Inf  -Inf  -Inf;
  -Inf  -Inf    -8   Inf   Inf  -Inf  -Inf;
  -Inf  -Inf     0   Inf   Inf  -Inf  -Inf;
  -Inf  -Inf  -Inf     0    -3  -Inf  -Inf;
  -Inf  -Inf  -Inf     3     0  -Inf  -Inf];

MGD05.Sp.Ldiag=[14 14 12 7 7 3 3];
% A=double(MGD05.M);
% profile on
% [SSPP,subgraphs,orders] = mmp.l.Spectrum.of_digraph(A);
% [Ut,Ldiag,V,cnodes,nodes]=mmp.l.Spectrum.all_evs(SSPP);
% profile viewer
% profile off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Heidergott, Olsder and ver der Woude, 2006
%A=mmp_l_zeros(10);%Accepts an UFNF3!
A=mmp.l.zeros(10);
A(1,2)=0;
A(2,3)=-3;
A(3,2)=4;A(3,4)=0;
A(4,1)=0;
A(5,2)=16;A(5,6)=-5;
A(6,7)=0;
A(7,5)=9;
A(8,7)=1/2;
A(9,6)=6;
A(10,1)=9;
A=A';%Matrices for HOW are in transposed form.
HOW06.M=A;

%% A matrix with infinite perturbations.
A=mmp_l_zeros(4); A(1,2)=1;A(2,3)=2;A(3,4)=3;A(4,1)=4;
Exa4.M=A;
A(1,2)=Inf;
Exa4.M=A;

%% A max TIMES matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mt= [0.5 1 0.3 0.4 0.2;
    1 0.2 0 0 0.3;
    1 0 0 1 0;
    0.2 1 1 0.3 0.2;
    0 0.4 1 0 1];
%\mu(B)=1 in Maxtimes! It is irreducible
M=log(Mt);
TEST01.M=M
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=6;
A=-Inf(n);
A(1,2)=2;
A(2,1)=4;A(2,3)=mmp.l.ones(1);
A(3,2)=mmp.l.ones(1);A(3,3)=3;
A(4,5)=1;
A(5,2)=mmp.l.ones(1);A(5,4)=3;
A(6,2)=4;A(6,5)=3;
G1=A;
%%%%
% 1 subgraph
% 3 connected components
ldiag = [3 3 3 2 2 mmp.l.zeros(1)]
cnodes = [1 2 3 4 5 6]
%%%% critical cyles {{[1 2][3]}{[4 5]}{[6]}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matrix to test connected components: Mehlhorn 1987, Fig. 4., mmp. 22
n=5;
A=zeros(n,n);
A(1,3)=1;A(1,4)=1;A(1,5)=1;%a -> c,d,e
A(2,3)=1;%b -> c
A(3,4)=1;% c -> d
A(4,5)=1;% d -> e
A(5,1)=1;% e -> a
M87_4.M=mmp.x.Sparse(A);
% Call dfs as:
options = struct();
options.full = 1;
%depth_first_search(A,1,vis,options);
%[subgraph,order,components,crc,vis,finishTime] = mmp.x.con_components2(A,false)
% 1 crc, 2 scc {a,c,d,e},{b}
% 2 forward edges (1,4),(1,5)
%   cycle: acdea 
%   cycle: adea 
%   cycle: aea 
if false
    [subgraph,order,cycle,components,crc,vis,finishTime,ncycle] = digraph.crc_scc_cycles(M87_4.M,true);
end

%% Matrix to test connected components: and whether cross links merge
%%% components.
%%% Mehlhorn and Sanders, mmp. 181
n=9;
A=sparse(n,n);
%A=zeros(n)
A(2,3)=1;%b to c
A(3,1)=1;A(3,4)=1;A(3,6)=1;%c -> a,d,f
A(4,3)=1;A(4,5)=1;%d -> c,e
A(5,1)=1;%e -> a
A(6,7)=1;%f->g
A(7,4)=1;A(7,8)=1;A(7,9)=1;%g -> d,h,i
A(8,6)=1;%h->f
%This matrix is boolean encoded, hence it should be maxplus transformed
X=log(A);
%[subgraph,order,components,crc,vis,finishTime] = mmp.x.con_components2(A,true)
if false
  [subgraph,order,cycle,components,crc,vis,finishTime,ncycle] = digraph.crc_scc_cycles(X,true)
end

%% Matrix to test connected components: and whether cross links merge
%%% Mehlhorn, 1987. Fig 8, mmp.26. 
n=9;
A=sparse(n,n);
A(2,3)=1;%b to c
A(3,1)=1;A(3,4)=1;A(3,6)=1;%c -> a,d,f
A(4,3)=1;A(4,5)=1;%d -> c,e
A(5,1)=1;%e -> a
A(6,7)=1;A(6,8)=1;%f->g,h
A(7,6)=1;%g -> f
A(8,4)=1;A(8,5)=1;A(8,9)=1;%h->d,e
M87_8=A;
%This matrix is boolean encoded, hence it should be maxplus transformed
X=log(A);
%[subgraph,order,components,crc,vis,finishTime] = mmp.x.con_components2(A,true)
if false
    [subgraph,order,cycle,components,crc,vis,finishTime,ncycle] = digraph.crc_scc_cycles(X,true)
    %crc=1,sccs={a}{b}{e}{i}{c,d,f,g,h}
    %cycles={{cdc},{fgf},{cfhdc}}
    % A) Short way using definite_metrix_matrices, id. the A+ operator
    %%% Improve using spfun
    torder=sparse(mmp.x.definite_metric_matrix(mmp.x.sparse(log(0+order{1})))==eps)
end

%% Matrix to test connected components and cycles: Weinblatt 1972, Fig. 1
n=8;
A=sparse(n,n);
A(1,2)=1;%a -> b
A(2,3)=1;A(2,5)=1;%b -> c,e
A(3,4)=1;%c -> d
A(4,2)=1;A(4,7)=1;% d -> b,g
A(5,6)=1;% e -> f
A(6,3)=1;A(6,7)=1;% f -> c,g
A(7,5)=1;A(7,8)=1;%g -> e,h
X=log(A);
%[subgraph,order,components,crc,vis,finishTime] = mmp.x.con_components2(A)
if false
    [subgraph,order,cycle,components,crc,vis,finishTime,ncycle] = crc_scc_cycles(X,true)
    
    % Call dfs as:
    options = struct();
    options.full = 1;
    vis=mk_tracing_visitors('dfs');
    depth_first_search(A,1,vis,options);
    [subgraph,order,components,crc,vis] = mmp.x.con_components2(A,true)
end

%% An irreducible of order n with a single distinctive eigenvector.
n=3;
p = -2*ones(1,n);%This is the cycle
ran = 1:n; 
shift = [ran(2:end) ran(1)];
vals=p(ran)
A = -Inf(n,n);
A(sub2ind(size(A),ran,shift)) = vals;
VP10_11.M = A;
VP10_11.Sp.lambdas=mean(p);
nFEVs = length(unique(cumsum(vals - mean(vals))))
VP10_11.Sp.nFEVs = nFEVs;

%% An irreducible matrix with (lambda = Inf),
%only one eigenvector.
p = [0  Inf];
n = length(p);
ran = 1:n;
shift = [ran(2:end) ran(1)];
vals=p(ran)
A = -Inf(n,n);
A(sub2ind(size(A),ran,shift)) = vals;
VP10_22.M = A;
VP10_22.Sp.lambdas=mean(p);
if ~any(vals==Inf)
    nFEVs = length(unique(cumsum(vals - mean(vals))))
else
    nFEVs = 1
end
VP10_22.Sp.nFEVs = nFEVs;

%% An irreducible matrix of order n with two different eigenvectors
p = [0  4 0 4];
n = length(p);
ran = 1:n;
shift = [ran(2:end) ran(1)];
vals=p(ran)
A = -Inf(n,n);
A(sub2ind(size(A),ran,shift)) = vals;
VP10_33.M = A;
VP10_33.Sp.lambdas=mean(p);
nFEVs = length(unique(cumsum(vals - mean(vals))))
VP10_33.Sp.nFEVs = nFEVs;

%% An irreducible matrix of order n with two different eigenvectors
p = [0  Inf 0 Inf];
n = length(p);
ran = 1:n;
shift = [ran(2:end) ran(1)];
vals=p(ran)
A = -Inf(n,n);
A(sub2ind(size(A),ran,shift)) = vals;
VP10_33p.M = A;
VP10_33p.Sp.lambdas=mean(p);
nFEVs = length(unique(cumsum(vals - mean(vals))))
VP10_33p.Sp.nFEVs = nFEVs;

%% An irreducible matrix with two disjoint critical cycles
% three eigenvectors
% p = [0  Inf];
% n = length(p);
% ran = 1:n;
% shift = [ran(2:end) ran(1)];
% vals=p(ran)
% A = -Inf(n,n);
% A(sub2ind(size(A),ran,shift)) = vals;
cycles{1} = [3 1];
cycles{2} = [2];
ncycles=size(cycles,2);
n=sum(cellfun('length', cycles))
A = [-Inf 3 1;
        1 -Inf -Inf;
        -Inf 0.5 2];
VP10_44.M = A;
VP10_44.Sp.lambdas=mean(p);
nFEVs = 0;
for c = 1:ncycles
    vals=cycles{c};
    if ~any(vals==Inf)
        nFEVs = nFEVs+length(unique(cumsum(vals - mean(vals))));
    else
        nFEVs = nFEVs + 1;
    end
end
nFEVs
VP10_44.Sp.nFEVs = nFEVs;

%% An irreducible matrix of orden n with n different eigenvectors
n=3;
p = -primes(n^2);
ran = 1:n;
shift = [ran(2:end) ran(1)];
vals=p(ran)%Get the first n primes
A = -Inf(n,n);
A(sub2ind(size(A),ran,shift)) = vals;
%clear VP10d
VP10_55.M = A;
VP10_55.Sp.lambdas=mean(p);
nFEVs = length(unique(cumsum(vals - mean(vals))))
VP10_55.Sp.nFEVs = nFEVs;

%% An irreducible,dominated matrix of order n with two different eigenvectors
%p = [0  5 0 5];
p=2.5;
n = length(p);
ran = 1:n;
shift = [ran(2:end) ran(1)];
vals=p(ran)
A = -Inf(n,n);
A(sub2ind(size(A),ran,shift)) = vals;
VP10_66.M = A;
VP10_66.Sp.lambdas=mean(p);
nFEVs = length(unique(cumsum(vals - mean(vals))))
VP10_66.Sp.nFEVs = nFEVs;

%% A generic matrix for the SIAM journal
% - has null eigenvalue and its eigenvectors
% - initial and final classes which are not reflexive
% - two disconnected subdigraphs
% - infinite eigenvalue and its eigenvectors
% - dominated classes and their eigenvalues.
Vi = 1;Ni=length(Vi);%A single null-column, null-row eigenvector
% one node into the first class one into the second and one into both
Va=max(Vi)+(1:3);Na = length(Va);%Several
%Now the block diagonal blocks
Ab{1}=VP10_11.M;
Ab{2}=VP10_22.M;
Ab{3}=VP10_33.M;
Ab{4}=VP10_44.M;
Ab{5}=VP10_55.M;
Ab{6}=VP10_66.M;
K = 2;
Kc(1)=4;%number of classes in component 1
Kc(2)=2;%number of classes in component 2
C=sum(Kc);%num total de classes
Vb = max(Va);
Nb = 0;
for c = 1:C
    Nbb{c}=length(Ab{c});
    Vbb{c}=Vb+(1:Nbb{c});
    Nb = Nb + Nbb{c};
    Vb = Vb + Nbb{c};
end
%Nb = sum(cellfun('length',Ab));
Vb = [Vbb{:}];
% Now the classes which are terminal
%One with Aaw infinite!
Vw = max(Vb) + (1:3);
Nw=length(Vw);
%Now introduce the classes
n = sum([Ni Na Nb Nw]);
A = mmp.l.zeros(n);
for c = 1:C
    A(Vbb{c},Vbb{c})=Ab{c};
end
%connect the irreducible classes inblock 1
A(Vbb{1}(1),Vbb{2}(1))=2-1;
A(Vbb{1}(1),Vbb{3}(1))=3-1;
A(Vbb{1}(1),Vbb{4}(1))=4-1;
A(Vbb{2}(1),Vbb{3}(1))=3-2;
%Connect the irreducible classes in block 2
A(Vbb{5}(1),Vbb{6}(1))=6-5;

% Connect  the initial classes
% 1. Aaw
A(Va(1),Vw(1))=Inf;
A(Va(2),Vw(2))=-100;
% 2. Aab
A(Va(1),Vbb{2}(1))=1;
A(Va(2),Vbb{6}(1))=4;
A(Va(3),Vbb{1}(1))=2;
A(Va(3),Vbb{5}(1))=3;
%Connect the terminal classes
% Abw
A(Vbb{4}(2),Vw(1))=1;
A(Vbb{3}(2),Vw(2))=2;
A(Vbb{3}(1),Vw(3))=3;
A(Vbb{6}(1),Vw(3))=4;
% now store as a matrix to be used
VP10.M = A;
VP10.Sp.lambdas=...
    [-Inf(1,Ni+Na)...
    VP10_11.Sp.lambdas*ones(1,VP10_11.Sp.nFEVs)...
    VP10_22.Sp.lambdas*ones(1,VP10_22.Sp.nFEVs)...
    VP10_33.Sp.lambdas*ones(1,VP10_33.Sp.nFEVs)...
    VP10_44.Sp.lambdas*ones(1,VP10_44.Sp.nFEVs)...
    VP10_55.Sp.lambdas*ones(1,VP10_55.Sp.nFEVs)...
    VP10_66.Sp.lambdas*ones(1,VP10_66.Sp.nFEVs)...
    zeros(1,Nw)];
VP10.Sp.nFEVs =... 
    sum([Ni Na VP10_11.Sp.nFEVs VP10_22.Sp.nFEVs VP10_33.Sp.nFEVs VP10_44.Sp.nFEVs VP10_55.Sp.nFEVs VP10_66.Sp.nFEVs Nw]);
FEVs = mmp.l.zeros(n,VP10.Sp.nFEVs);
FEVs(:,1:(Ni+Na))=mmp.l.eye(23,Ni+Na);
all(all(mmp.l.mtimes(A,FEVs) == mmp.l.mtimes(FEVs,mmp.l.diag(VP10.Sp.lambdas))))
% NOw check that the only empty cols are Vi and Va
empty_cols=zeros(1,n);empty_cols([Vi Va])=true;
all(all(double(A)==-Inf) == empty_cols)%1 means OK

empty_rows=zeros(1,n);empty_rows([Vi Vw])=true;
%all(all(double(A)==-Inf,2)' == empty_rows)%1 means OK
if any(xor(all(double(A)==-Inf,2)' ,empty_rows))
    error('Some rows are not null that should or some rows are not null but should be.')
end
%To see the spectrum for this matrix, consult spectra2_test.m

%% An irreducible matrix of orden n with tops in disjoint critical cycles
n=4;
p = -primes(n^2);
ran = 1:n;
shift = [ran(2:end) ran(1)];
vals=p(ran)%Get the first n primes
A = -Inf(n,n);
A(sub2ind(size(A),ran,shift)) = vals;
% Place tops strategically
sshift = [shift(2:end) shift(1)]
A(sub2ind(size(A),ran,sshift)) = mmp.l.tops();
%clear VP10d
VP10_77.M = A;
VP10_77.Sp.lambdas=Inf;
%the normalization is traumatic
normA = mmp.u.mtimes(A,mmp.u.tops())
normAstar = mmp.l.tclosure(normA)
% number of different eigenvalues:
nFEVs = size(unique(normAstar','rows'),1)
VP10_77.Sp.nFEVs = nFEVs;
%los autovalores fundamentales sólo comparten el patron de Inf con los
%reales.
% clear v
% v(:,1)= [Inf 0 Inf 0]'
% v(:,2) = [0 Inf 0 Inf]'
% mmp.l.mtimes(A,v) == mmp.l.stimes(mmp.l.tops,v)
[enodes,V]=mmp_l_top_right_FEVs(A);
all(all(mmp.l.mtimes(A,V)==mmp.l.mtimes(V,mmp.l.tops)))


%% An irreducible matrix of orden n with tops in two disjoint critical cycles
n=4;
p = -primes(n^2);%to make it irreducible
ran = 1:n;
shift = [ran(2:end) ran(1)];
vals=p(ran)%Get the first n primes
vals([1,3])=mmp.l.tops
ccycle=[1 3 4]
A = -Inf(n,n);
A(sub2ind(size(A),ran,shift)) = vals;
VP10_88.M = A;
VP10_88.Sp.lambdas=mean(vals);
% normA = mmp.l.mrdivide(A,mean(vals))
% if mean(vals) < mmp.l.tops
%     %the normalization is traumatic
%     nFEVs = length(unique(cumsum(vals - mean(vals))))
%     VP10_88.Sp.nFEVs = nFEVs;
%     normAstar = mmp.l.tclosure(normA)
%     % number of different eigenvalues:
%     nFEVs == size(unique(normAstar','rows'),1)
%     mmp.l.mtimes(A,normAstar(:,1)) == mmp.l.stimes(mmp.l.tops,normAstar(:,1))
% else
%     %Find all coordinates that fo to Inf for each cycle!
%     v_cycle = mmp.l.ones(n,1);
%     v_cycle(ccycle)=mmp.l.tops
%     mmp.l.mtimes(A,v_cycle) == mmp.l.stimes(mmp.l.tops,v_cycle)
% end
%v(:,1)=[Inf 0 0 0]'
[enodes,V]=mmp_l_top_right_FEVs(A);
all(all(mmp.l.mtimes(A,V)==mmp.l.mtimes(V,mmp.l.tops)))

%% An irreducible matrix of orden n with tops in two disjoint critical cycles
n=4;
p = -primes(n^2);%to make it irreducible
ran = 1:n;
shift = [ran(2:end) ran(1)];
vals=p(ran)%Get the first n primes
A = -Inf(n,n);
A(sub2ind(size(A),ran,shift)) = vals
A(1,3)=mmp.l.tops;A(3,1)=0.25;
A(2,4)=mmp.l.tops;A(4,2)=0.33;
% Place tops strategically
% sshift = [shift(2:end) shift(1)]
% A(sub2ind(size(A),ran,sshift)) = mmp.l.tops();
%clear VP10d
VP10_99.M = A
VP10_99.Sp.lambdas=Inf;
% normA = mmp.l.mrdivide(A,mean(vals))
% if mean(vals) < mmp.l.tops
%     %the normalization is traumatic
%     nFEVs = length(unique(cumsum(vals - mean(vals))))
%     VP10_88.Sp.nFEVs = nFEVs;
%     normAstar = mmp.l.tclosure(normA)
%     % number of different eigenvalues:
%     nFEVs == size(unique(normAstar','rows'),1)
%     mmp.l.mtimes(A,normAstar(:,1)) == mmp.l.stimes(mmp.l.tops,normAstar(:,1))
% else
%     %Find all coordinates that fo to Inf for each cycle!
%     v_cycle = mmp.l.ones(n,1);
%     v_cycle(ccycle)=mmp.l.tops
%     mmp.l.mtimes(A,v_cycle) == mmp.l.stimes(mmp.l.tops,v_cycle)
% end
% v(:,1)= [0 Inf Inf Inf]';
% v(:,2) = [Inf 0 Inf Inf]';
% v(:,3)= [Inf Inf 0  Inf]';
% v(:,4)=[Inf Inf Inf 0 ]';
% v(:,5)=[Inf Inf 0 0]'
% mmp.l.mtimes(A,v) == mmp.l.stimes(mmp.l.tops,v)
%mmp.l.mtimes(A,mmp.l.ones(n)) == mmp.l.stimes(mmp.l.tops,v)

%TRACE THE FOLLOWING FOR PROBLEMS WITH THE mmp.n.representation

% All elements with support 1 have to be picked up
[enodes,V]=mmp_l_top_right_FEVs(A);
%test that the eigenvectors are really so.
all(all(mmp.l.mtimes(A,V)==mmp.l.mtimes(V,mmp.l.tops)))

