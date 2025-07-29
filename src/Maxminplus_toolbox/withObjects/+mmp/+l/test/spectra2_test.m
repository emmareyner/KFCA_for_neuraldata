%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% A maxplus matrix whose right spectrum is known. Obtained from Akian, Bapat,
%Gaubert, 2006
% This has some code to find matrices of (possibly related, sibling)
% right and left eigenvectors.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load matrix examples
%clc
cd ~/src/matlab/Maxminplus_toolbox/withObjects/examples;
matrices;
cd ..;

%% A=ABG06a. Irreducible. Finite eigenvalue.
%Detects a precision bug when testing equality to 0.0 <= eps. Changed to
%eps(16)
A=ABG06a.M;%Akian, Bapat, Gaubert, 05
str = 'ABG6a';
[Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = mmp.l.spectra(A,str)
%This spectrum has stability problems with eigenvectors (actually with
%transitive closures)
S = mmp.l.Spectrum.of_UFNF_2(A)


%this visualization uses the biograph toolbox!!
%bg = biograph(A)%It is really NOT suited to maxplus networks!
%h = view(bg)
%network.Vizgraph(A)
%TestSp=ABG06a.Sp
%Compare this spectrum to TestSp.

%% A=ABG06b. Reducible. Finite eigenvalues. Classes eclipsed from above and
%%below. Some eigenvectors strictly in cmaxplus
A=ABG06b.M;%Akian, Bapat, Gaubert, 06, modified
str = 'ABG6b';
[Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = mmp.l.spectra(A,str)

% mmp.l.mtimes(ABG06b.M,V(perm,:)) == mmp.l.mtimes(V(perm,:),mmp.l.diag(Ldiag))
% mmp.l.mtimes(Ut(:,perm),ABG06b.M) == mmp.l.mtimes(mmp.l.diag(Ldiag),Ut(:,perm))
% v_4 = Ut(7,perm)
% v_1 = Ut(6,perm)
% mmp.l.mtimes([0 Inf Inf Inf Inf Inf Inf Inf],ABG06b.M)

%% ABG06bdouble. Completely reducible. With reducible subdigraphs. Classes
% eclipsed from below and above. Bottom eigenvalue in several coordinates!
%profile on
A=ABG06bdouble.M;
str = 'ABG6bdouble'
[Lev,Llamb,Len,Rev,Rlamb,Ren,P3,Aplus] = mmp.l.spectra(A,str)

%% Perturbed ABG06p. REducible. Infinite eigenvalue. Classes eclipsed from
%%above and below. Some eigenvectors strictly in cmaxplus. Eigenvectors
%%for infinite eigenvalue.
A=ABG06p.M;%Akian, Bapat, Gaubert, 06, modified
% 1. Frist draw graph
%drawNetwork(ABG06p.M > -Inf)
[SSPP, subgraphs, orders] = mmp.l.Spectrum.of_digraph(A);
%[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
[Ut,Ldiag,V,cnodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(SSPP);
[kk,perm]=sort(nodes);%permutation on the whole set of nodes
[kk,cperm]=sort(cnodes);%permutation on the critical nodes
Sp = SSPP{1};
dV = double(V(perm,cperm))
dUt = double(Ut(cperm,perm))
str = 'ABG6p';
if ~all(all(mmp.l.mtimes(A,V(perm,cperm)) == mmp.l.mtimes(V(perm,cperm),mmp.l.diag(Ldiag(cperm)))))
    error('Right eigenvectors NOT correct for %s',str)
else
    fprintf('Right eigenvectors CORRECT for  %s\n',str);
end
if ~all(all(mmp.l.mtimes(Ut(cperm,perm),A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),Ut(cperm,perm))))
    error('Left eigenvectors NOT correct for  %s',str)
else
    fprintf('Left eigenvectors CORRECT for  %s\n',str);
end

%For instance a right eigenvector and value of the new Spectrum that does no
%belong to the old spectrum
% lambda = -3
% v_4 = Inf(8,1);v_4(8)=0
% mmp.l.mtimes(ABG06p.M, v_4) == mmp.l.mtimes(v_4,-3)
%For instance, a right eigenvector that belongs to the Inf eigenvalue.

%% CHEN90
A=CHEN90.M
str = 'CHEN90';
[Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = mmp.l.spectra(A,str)

TestSp=CHEN90.Sp;
% [SSPP, subgraphs, orders] = mmp.l.Spectrum.of_digraph(A);
% %[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
% [Ut,Ldiag,V,cnodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(SSPP);
% [kk,perm]=sort(nodes);%permutation on the whole set of nodes
% [kk,cperm]=sort(cnodes);%permutation on the critical nodes
% Sp = SSPP{1};
% dV = double(V(perm,cperm))
% dUt = double(Ut(cperm,perm))
% if ~all(all(mmp.l.mtimes(A,V(perm,cperm)) == mmp.l.mtimes(V(perm,cperm),mmp.l.diag(Ldiag(cperm)))))
%     error('Right eigenvectors NOT correct for %s',str)
% else
%     fprintf('Right eigenvectors CORRECT for  %s\n',str);
% end
% if ~all(all(mmp.l.mtimes(Ut(cperm,perm),A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),Ut(cperm,perm))))
%     error('Left eigenvectors NOT correct for  %s',str)
% else
%     fprintf('Left eigenvectors CORRECT for  %s\n',str);
% end


%% HOW06 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=HOW06.M;
str = 'HOW06';
%render in UFN3
%[P,Q,zrows,zcols] = mmp.l.paq(A);%Pati's decomposition in SIAM
% [zrows,zcols] = findzeros(A);
% iota=zrows&zcols;
% alpha=zcols&~iota;
% omega=zrows&~iota;
% beta=~(zrows|zcols);
% P3=[find(iota) find(alpha) find(beta) find(omega)];
[Lev,Llamb,Len,Rev,Rlamb,Ren,P3,Aplus] = mmp.l.spectra(A,str)
A=A(P3,P3);
%emptycols: v1 ||v2||v3
%C1: 1 2 3 4
%C2: 5 6 7
%Va = {8,9,10}
%Vw = {} = Vi
%C2(1,33) < C1(0,5). Class C1 dominated, C2 dominating 
%C1: V5 > v6
%C2: V8 > v9 > v9
TestSp=MGD05.Sp;

%% MGD05. El diagrama de clases es lineal y tiene clases eclipsadas por
%%% arriba y debajo.
A=MGD05.M;
str = 'MGD05';
[Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = mmp.l.spectra(A,str)

TestSp=MGD05.Sp;
% [SSPP, subgraphs, orders] = mmp.l.Spectrum.of_digraph(A);
% %[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
% [Ut,Ldiag,V,cnodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(SSPP);
% [kk,perm]=sort(nodes);%permutation on the whole set of nodes
% [kk,cperm]=sort(cnodes);%permutation on the critical nodes
% Sp = SSPP{1};
% dV = double(V(perm,cperm))
% dUt = double(Ut(cperm,perm))
% if ~all(all(mmp.l.mtimes(A,V(perm,cperm)) == mmp.l.mtimes(V(perm,cperm),mmp.l.diag(Ldiag(cperm)))))
%     error('Right eigenvectors NOT correct for %s',str)
% else
%     fprintf('Right eigenvectors CORRECT for  %s\n',str);
% end
% if ~all(all(mmp.l.mtimes(Ut(cperm,perm),A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),Ut(cperm,perm))))
%     error('Left eigenvectors NOT correct for  %s',str)
% else
%     fprintf('Left eigenvectors CORRECT for  %s\n',str);
% end

%% Prueba de  BGCG09a: dos subgrafos.
A=BGCG09a.M;
n = size(A,1)
TestSp=BGCG09a.Sp
[SSPP, subgraphs, orders] = mmp.l.Spectrum.of_digraph(A);
%[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
[Ut,Ldiag,V,cnodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(SSPP);
[kk,perm]=sort(nodes);%permutation on the whole set of nodes
[kk,cperm]=sort(cnodes);%permutation on the critical nodes
Sp = SSPP{1};
dV = double(V(perm,cperm))
dUt = double(Ut(cperm,perm))
str = 'BGCG09a';
if ~all(all(mmp.l.mtimes(A,V(perm,cperm)) == mmp.l.mtimes(V(perm,cperm),mmp.l.diag(Ldiag(cperm)))))
    error('Right eigenvectors NOT correct for %s',str)
else
    fprintf('Right eigenvectors CORRECT for  %s\n',str);
end
if ~all(all(mmp.l.mtimes(Ut(cperm,perm),A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),Ut(cperm,perm))))
    error('Left eigenvectors NOT correct for  %s',str)
else
    fprintf('Left eigenvectors CORRECT for  %s\n',str);
end
% debugBGCG09a = true
% if debugBGCG09a
%     % find cycles in double format
%     [subgraph,order,cycle]=digraph.crc_scc_cycles(BGCG09a.M);
% end
% [SSPP,subgraphs,orders] = mmp.l.Spectrum.of_digraph(A);
% Sp1 = SSPP{1}
% Sp2 = SSPP{2}%WRONG! Does NOT return the original nodes!

%% EXamples from Butkovic, Cunninghame-Green, Gaubert, 2010
A = BGCG09b.M%Block disconnected matrix
%This takes a loooong time! Profil
[SSPP, subgraphs, orders] = mmp.l.Spectrum.of_digraph(A);
%[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
[Ut,Ldiag,V,cnodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(SSPP);
[kk,perm]=sort(nodes);%permutation on the whole set of nodes
[kk,cperm]=sort(cnodes);%permutation on the critical nodes
Sp = SSPP{1};
dV = double(V(perm,cperm))
dUt = double(Ut(cperm,perm))
str = 'BGCG09b';
if ~all(all(mmp.l.mtimes(A,dV) == mmp.l.mtimes(dV,mmp.l.diag(Ldiag(cperm)))))
    error('Right eigenvectors NOT correct for %s',str)
else
    fprintf('Right eigenvectors CORRECT for  %s\n',str);
end
if ~all(all(mmp.l.mtimes(dUt,A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),dUt)))
    error('Left eigenvectors NOT correct for  %s',str)
else
    fprintf('Left eigenvectors CORRECT for  %s\n',str);
end
 %TODO: Perturb this matrix to include a lambda == Inf

%% The corrections needed for the previous spectrum
v_14 = dV(:,14);
[mmp.l.mtimes(double(A),v_14)  8+v_14]'
v_14bis = v_14;
v_14bis(1)=Inf;
v_14bis(3)=Inf;
v_14bis(4)=Inf;
v_14bis(6)=Inf;
v_14'
v_14bis'
[mmp.l.mtimes(double(A),v_14bis) 8+v_14bis]'

%Compare the orders and the eclipsing..
%Sp=SSPP{1};
Sp.nodes(perm)
full(Sp.order(perm,perm))
full(Sp.ec_above(perm))%OK
full(Sp.ec_below(perm))%OK
 
 %% Some investigations into failing eigenvectors
%dUt = double(Ut(cperm,perm))
u_2 = dUt(2,:)
u_2bis = u_2;
u_2bis(7)=Inf;
u_2bis(10)=Inf;
u_2bis(14)=Inf;
u_2bis

[mmp.l.mtimes(u_2,A);
    mmp.l.mtimes(9, u_2)]
[mmp.l.mtimes(u_2bis,A);
    mmp.l.mtimes(9, u_2bis)]
%%
A_11 = 1; A_11s = Inf;A_11p=Inf;
A_12 = [-8 -Inf -Inf];
A_22 = [-2 -8 -Inf; -Inf -5 -8; -Inf -Inf -6];
A_22p = mmp.l.finite_tclosure(A_22);
A_22s = double(mmp.l.plus(mmp.l.eye(3),A_22p));
A_12p = mmp.l.mtimes(A_11s,mmp.l.mtimes(A_12,A_22s))
A_23 = [-Inf -Inf -8]';
A_33 = 0; A_33s = 0;
A_13 = -Inf
A_13p = mmp.l.mtimes(A_11s,mmp.l.mtimes(mmp.l.plus(mmp.l.mtimes(A_12,mmp.l.mtimes(A_22s,A_23)),A_13), A_33s))
A_23p = mmp.l.mtimes(A_22s,mmp.l.mtimes(A_23,A_33s))

%%% The problems generated by previous eigenvectors come from the wrong
%%% interpretation of the saturation support: 
%%% - dominating classes will be saturated, but not the classes depending
%%% on those!!
lambdas=Sp.lambdas(perm);
o = full(Sp.order(perm,perm));
class = 14;
ust = o(:,class)'
lambda=lambdas(class)
rsat =(lambdas > lambda) & ust%The upstream dominating classes
nodom_ust = ust & ~rsat
B = double(A(nodom_ust,nodom_ust))
Bs = mmp.l.finite_tclosure(B-lambda)
%mmp.l.mtimes(B,Bs(:,9)) == mmp.l.mtimes(8,Bs(:,9))
As = mmp.l.trclosure(double(A)-8)
mmp.l.mtimes(A,As(:,14)) == mmp.l.mtimes(8,As(:,14))

class = 2;
dst = o(class,:)
lambda=lambdas(class)
lsat = (lambdas > lambda) & dst
nodom_dst = dst & ~lsat
C = double(A(nodom_dst,nodom_dst));
Cs = mmp.l.finite_tclosure(C-lambda)
u_2 = -inf(1,14);
u_2(lsat)=Inf;
u_2(nodom_dst) = Cs(1,:)
mmp.l.mtimes(u_2,A) == mmp.l.mtimes(u_2,lambda)

%%obtain the eigenvector by brute force
As = mmp.l.trclosure(double(A)-lambda)
As(class,:)==u_2

% %TODO: Perturb this matrix to include a lambda == Inf

%% Some matrix calculations at the end
A=ABG06b.M
A11 = A(2:4,2:4)
A22 = A(8,8)
A12=A(2:4,8)
A11s = Inf(3,3)
mmp.l.mtimes(A11s,A12)
A22s = mmp.l.finite_tclosure(mmp.l.mrdivide(A22,-3))
mmp.l.mtimes(A12,A22s)

%% An irreducible of order n with a single distinctive eigenvector.
A = VP10_11.M%Block disconnected matrix
%This takes a loooong time! Profil
[SSPP, subgraphs, orders] = mmp.l.Spectrum.of_digraph(A);
%[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
[Ut,Ldiag,V,cnodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(SSPP);
[kk,perm]=sort(nodes);%permutation on the whole set of nodes
[kk,cperm]=sort(cnodes);%permutation on the critical nodes
Sp = SSPP{1};
dV = double(V(perm,cperm))
dUt = double(Ut(cperm,perm))
str = 'VP10_11';
if ~all(all(mmp.l.mtimes(A,dV) == mmp.l.mtimes(dV,mmp.l.diag(Ldiag(cperm)))))
    error('Right eigenvectors NOT correct for %s',str)
else
    fprintf('Right eigenvectors CORRECT for  %s\n',str);
end
if ~all(all(mmp.l.mtimes(dUt,A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),dUt)))
    error('Left eigenvectors NOT correct for  %s',str)
else
    fprintf('Left eigenvectors CORRECT for  %s\n',str);
end

%% An irreducible of order n with two distinctive eigenvectors.
A = VP10_22.M%Block disconnected matrix
%This takes a loooong time! Profil
[SSPP, subgraphs, orders] = mmp.l.Spectrum.of_digraph(A);
%[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
[Ut,Ldiag,V,cnodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(SSPP);
[kk,perm]=sort(nodes);%permutation on the whole set of nodes
[kk,cperm]=sort(cnodes);%permutation on the critical nodes
Sp = SSPP{1};
dV = double(V(perm,cperm))
dUt = double(Ut(cperm,perm))
str = 'VP10_22';
if ~all(all(mmp.l.mtimes(A,dV) == mmp.l.mtimes(dV,mmp.l.diag(Ldiag(cperm)))))
    error('Right eigenvectors NOT correct for %s',str)
else
    fprintf('Right eigenvectors CORRECT for  %s\n',str);
end
if ~all(all(mmp.l.mtimes(dUt,A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),dUt)))
    error('Left eigenvectors NOT correct for  %s',str)
else
    fprintf('Left eigenvectors CORRECT for  %s\n',str);
end

%% An irreducible of order n with two distinctive eigenvectors.
A = VP10_33.M%Block disconnected matrix
%This takes a loooong time! Profil
[SSPP, subgraphs, orders] = mmp.l.Spectrum.of_digraph(A);
%[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
[Ut,Ldiag,V,cnodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(SSPP);
[kk,perm]=sort(nodes);%permutation on the whole set of nodes
[kk,cperm]=sort(cnodes);%permutation on the critical nodes
Sp = SSPP{1};
dV = double(V(perm,cperm))
dUt = double(Ut(cperm,perm))
str = 'VP10_33';
if ~all(all(mmp.l.mtimes(A,dV) == mmp.l.mtimes(dV,mmp.l.diag(Ldiag(cperm)))))
    error('Right eigenvectors NOT correct for %s',str)
else
    fprintf('Right eigenvectors CORRECT for  %s\n',str);
end
if ~all(all(mmp.l.mtimes(dUt,A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),dUt)))
    error('Left eigenvectors NOT correct for  %s',str)
else
    fprintf('Left eigenvectors CORRECT for  %s\n',str);
end

%% An irreducible of order n with rho = top two distinctive eigenvectors.
A = VP10_33p.M%Block disconnected matrix
%This takes a loooong time! Profil
[SSPP, subgraphs, orders] = mmp.l.Spectrum.of_digraph(A);
%[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
[Ut,Ldiag,V,cnodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(SSPP);
[kk,perm]=sort(nodes);%permutation on the whole set of nodes
[kk,cperm]=sort(cnodes);%permutation on the critical nodes
Sp = SSPP{1};
dV = double(V(perm,cperm))
dUt = double(Ut(cperm,perm))
str = 'VP10_33p';
if ~all(all(mmp.l.mtimes(A,dV) == mmp.l.mtimes(dV,mmp.l.diag(Ldiag(cperm)))))
    error('Right eigenvectors NOT correct for %s',str)
else
    fprintf('Right eigenvectors CORRECT for  %s\n',str);
end
if ~all(all(mmp.l.mtimes(dUt,A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),dUt)))
    error('Left eigenvectors NOT correct for  %s',str)
else
    fprintf('Left eigenvectors CORRECT for  %s\n',str);
end
%Not the whole picture! Change the code to accommodate the following!
infcols = find(any(A==mmp.l.tops));
dV = Inf(n,length(infcols));
for i=1:length(infcols)
    dV(infcols(i),i)=mmp.l.ones;
end
if ~all(all(mmp.l.mtimes(A,dV) == mmp.l.mtimes(dV,mmp.l.diag(Ldiag(infcols)))))
    error('Right eigenvectors NOT correct for %s',str)
else
    fprintf('Right eigenvectors CORRECT for  %s\n',str);
end
infrows = find(any(A==mmp.l.tops,2));
dU = Inf(length(infcols),n);
for i=1:length(infrows)
    dU(i,infrows(i))=mmp.l.ones;
end
if ~all(all(mmp.l.mtimes(dUt,A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),dUt)))
    error('Left eigenvectors NOT correct for  %s',str)
else
    fprintf('Left eigenvectors CORRECT for  %s\n',str);
end

%% An irreducible of order n with two distinctive eigenvectors.
A = VP10_44.M%Block disconnected matrix
%This takes a loooong time! Profil
%[SSPP, subgraphs, orders] 
[Lev,Llamb,Len,Rev,Rlamb,Ren,nodes]= mmp.l.Spectrum.of_digraph(A);
%[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
[Ut,Ldiag,V,cnodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(SSPP);
[kk,perm]=sort(nodes);%permutation on the whole set of nodes
[kk,cperm]=sort(cnodes);%permutation on the critical nodes
Sp = SSPP{1};
dV = double(V(perm,cperm))
dUt = double(Ut(cperm,perm))
str = 'VP10_44';
if ~all(all(mmp.l.mtimes(A,dV) == mmp.l.mtimes(dV,mmp.l.diag(Ldiag(cperm)))))
    error('Right eigenvectors NOT correct for %s',str)
else
    fprintf('Right eigenvectors CORRECT for  %s\n',str);
end
if ~all(all(mmp.l.mtimes(dUt,A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),dUt)))
    error('Left eigenvectors NOT correct for  %s',str)
else
    fprintf('Left eigenvectors CORRECT for  %s\n',str);
end

%% An irreducible of order n with two distinctive eigenvectors.
A = VP10_55.M%Block disconnected matrix
%This takes a loooong time! Profil
[SSPP, subgraphs, orders] = mmp.l.Spectrum.of_digraph(A);
%[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
[Ut,Ldiag,V,cnodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(SSPP);
[kk,perm]=sort(nodes);%permutation on the whole set of nodes
[kk,cperm]=sort(cnodes);%permutation on the critical nodes
Sp = SSPP{1};
dV = double(V(perm,cperm))
dUt = double(Ut(cperm,perm))
str = 'VP10_55';
if ~all(all(mmp.l.mtimes(A,dV) == mmp.l.mtimes(dV,mmp.l.diag(Ldiag(cperm)))))
    error('Right eigenvectors NOT correct for %s',str)
else
    fprintf('Right eigenvectors CORRECT for  %s\n',str);
end
if ~all(all(mmp.l.mtimes(dUt,A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),dUt)))
    error('Left eigenvectors NOT correct for  %s',str)
else
    fprintf('Left eigenvectors CORRECT for  %s\n',str);
end

%% A matrix with two top FEVs from different critical cycles.
A = VP10_99.M%Block disconnected matrix
%[SSPP, subgraphs, orders] 
[Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = mmp.l.spectra(A);
str = 'VP10_99';
if ~all(all(mmp.l.mtimes(A,dV) == mmp.l.mtimes(dV,mmp.l.diag(Ldiag(cperm)))))
    error('Right eigenvectors NOT correct for %s',str)
else
    fprintf('Right eigenvectors CORRECT for  %s\n',str);
end
if ~all(all(mmp.l.mtimes(dUt,A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),dUt)))
    error('Left eigenvectors NOT correct for  %s',str)
else
    fprintf('Left eigenvectors CORRECT for  %s\n',str);
end

%% Create a generic matrix with all sorts of problems:
Vi = 1:2;Ni=length(Vi);
Va = 3:4;Na=length(Va);
Vb = 5:10;Nb=length(Vb);
Vw = 11:12;Nw=length(Vw);
n = max([max(Vi),max(Va),max(Vb),max(Vw)])
A=mmp.l.zeros(n,n);
A(Va,Vb)=mmp.l.eye(Na,Nb);
A(Vb,Vb)=[ABG06a.M-20/3 mmp.l.zeros(3);
                 mmp.l.zeros(3) ABG06a.M]
A(Vb,Vw)=mmp.l.eye(Nb,Nw);
A(Va,Vw)=mmp.l.eye(Na,Nw);
double(A)
%Brute force!!
Astar = mmp.l.tclosure(A);
V = Astar(:,Vw);
dV=double(V)
[mmp.l.mtimes(A,V) mmp.l.mtimes(V,mmp.l.eye(Nw))]
mmp.l.mtimes(A,V) == mmp.l.mtimes(V,mmp.l.eye(Nw))

%% now build eigenvector of final nodes
V=mmp.l.zeros(n,Nw);
AbPlus = mmp.l.tclosure(A(Vb,Vb));
AbStar = mmp.l.rclosure(AbPlus);
V(Va,:)=mmp.l.plus(mmp.l.mtimes(A(Va,Vb),mmp.l.mtimes(AbStar,A(Vb,Vw))),A(Va,Vw));
V(Vb,:)=mmp.l.mtimes(AbPlus,A(Vb,Vw));
%Select those that fulfill the inequalities:
mask = all([V(Va,:) >= A(Va,Vw);
                   V(Vb,:)  >= mmp.l.eye(Nb,Nw)])
mmp.l.mtimes(A,V(:,mask)) == mmp.l.mtimes(V(:,mask),mmp.l.eye(Nw,sum(mask)))

%% An irreducible of order n with two distinctive eigenvectors.
A = VP10.M%Block disconnected matrix
str='VP10'
[Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = mmp.l.spectra(A,str)
% %This takes a loooong time! Profile
% [SSPP, subgraphs, orders] = mmp.l.Spectrum.of_digraph(A);
% %[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
% [Ut,Ldiag,V,cnodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(SSPP);
% [kk,perm]=sort(nodes);%permutation on the whole set of nodes
% [kk,cperm]=sort(cnodes);%permutation on the critical nodes
% Sp = SSPP{1};
% dV = double(V(perm,cperm))
% dUt = double(Ut(cperm,perm))
% str = 'VP10';
% if ~all(all(mmp.l.mtimes(A,dV) == mmp.l.mtimes(dV,mmp.l.diag(Ldiag(cperm)))))
%     error('Right eigenvectors NOT correct for %s',str)
% else
%     fprintf('Right eigenvectors CORRECT for  %s\n',str);
% end
% if ~all(all(mmp.l.mtimes(dUt,A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),dUt)))
%     error('Left eigenvectors NOT correct for  %s',str)
% else
%     fprintf('Left eigenvectors CORRECT for  %s\n',str);
% end

%% Reachability analysis
B_A = ~(A==mmp.l.zeros)%Associated relation
%[i,j]=find(~(full(B_A) == ~(double(A)==mmp.l.zeros)))
%my.logical.tclosure(E & ~E.')
B_Aplus = full(my.logical.tclosure(B_A));
B_Astar = my.logical.rclosure(B_Aplus);
%related = B_Aplus & B_Aplus.'
%Eplus & ~Eplus.'
Gamma_A = full(my.logical.sclosure(B_A & ~(logical(eye(23)))));
Gamma_Aplus = full(my.logical.tclosure(Gamma_A));
%Iplus = my.logical.tclosure(I)
sources = ~(my.logical.mtimes(B_A.',true(size(B_A,2),1)));
sinks = ~(my.logical.mtimes(B_A,true(size(B_A,1),1)));
%This is the reflexive part
reflexive = diag(B_Aplus);
Initial = sources & ~reflexive;%irreflexive closure
Terminal = sinks & ~reflexive;%irreflexive closure
%Another way to calculate Terminal nodes
%C_A = B_Aplus &  my.logical.mtimes(true(n,1),sources')
C_A =  B_Astar &  my.logical.mtimes(sinks,true(1,n))';
my.logical.mtimes(B_Aplus,C_A) == C_A
my.logical.mtimes(C_A,C_A) == C_A
my.logical.mtimes(B_A,C_A) == (C_A & ~(logical(eye(n))))
Terminal == any(C_A)'
%Reachability node partition!
Vi = Initial & Terminal
Va = Initial & ~Terminal
Vw = ~Initial & Terminal
Vb = ~Initial & ~Terminal
double(A(Vb,Vb))
%The symmetric closure of B_Aplus restricted to the non-zero lines obtains
%% the connected componets
Connected = my.logical.sclosure(B_Aplus & my.logical.mtimes(reflexive,reflexive'));
[kk,idx] = unique(Connected(reflexive,:),'rows');
comps=Connected(idx(1),:);
K=1;
n=size(Connected,2);
for i = idx(2:end)
    Y = Connected(i,:);
    manyY = my.logical.mtimes(true(K,1),Y);
    subsets = all(comps | ~manyY,2);
    if any(subsets)
        comps=comps(~subsets,:)
        K=size(comps,1);
    end
    comps=[comps;Connected(i,:)];
    K=K+1
    overlapping=any(comps & manyY,2);
    if any(overlapping)
        comps(overlapping,:)=comps(overlapping,:) | manyY(overlapping,:);
    end
%     else
%         warning('spectra2_test','Empty row found unexpectedly at %i',i)
%     end
end
%% no zero lines in Abb
full(all(A(Vb,Vb)==-Inf))
full(all(A(Vb,Vb)==-Inf,2))


%% A matrix with top eigenvalues
this_n=6;
B = double(mmp.l.eye(this_n));
B(1,1)=mmp.l.tops;
B(min(3,this_n),min(3,this_n))=mmp.l.tops;
B=B(:,[this_n 1:(this_n-1)])%bring into cyclical normal form
[i,j,k]=find(B~=mmp.l.zeros)
cycle=B(sub2ind(size(B),i,j))
aretops = (cycle==mmp.l.tops)
V = double(mmp.u.eye(6))
V=V(:,aretops)
mmp.l.mtimes(B,V)==mmp.l.mtimes(V,mmp.l.diag(cycle(aretops)))

%% An irreducible of order n with rho = top two distinctive eigenvectors.
A = CG79_p189.M%Block disconnected matrix
str = 'CG79_p189';
%[Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = mmp.l.spectra(A,str);
[enodes,V]=mmp_l_top_right_FEVs(A)%The enodes are really those corresponding to lines with 
double(mmp.l.mtimes(A,V))==double(mmp.l.mtimes(V,mmp.l.diag(mmp.l.tops(size(enodes)))))

% %This takes a loooong time! Profil
% [SSPP, subgraphs, orders] = mmp.l.Spectrum.of_digraph(A);
% %[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
% [Ut,Ldiag,V,cnodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(SSPP);
% [kk,perm]=sort(nodes);%permutation on the whole set of nodes
% [kk,cperm]=sort(cnodes);%permutation on the critical nodes
% Sp = SSPP{1};
% dV = double(V(perm,cperm))
% dUt = double(Ut(cperm,perm))
% if ~all(all(mmp.l.mtimes(A,dV) == mmp.l.mtimes(dV,mmp.l.diag(Ldiag(cperm)))))
%     error('Right eigenvectors NOT correct for %s',str)
% else
%     fprintf('Right eigenvectors CORRECT for  %s\n',str);
% end
% if ~all(all(mmp.l.mtimes(dUt,A) == mmp.l.mtimes(mmp.l.diag(Ldiag(cperm)),dUt)))
%     error('Left eigenvectors NOT correct for  %s',str)
% else
%     fprintf('Left eigenvectors CORRECT for  %s\n',str);
% end

%% A matrix with two critical cycles sharing some vertices
A = mmp.l.zeros(5);
A(1,2)=1.25;A(2,3)=1.75;A(3,4)=3;A(4,1)=2;%cycle 1
A(4,5)=2;A(5,1)=2;%cycle 2
A(2,2)=2;%Cycle 3
str = 'embedded cycles';
[Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = mmp.l.spectra(A,str);

%% An irreducible matrix with a top eigenvalue
A = VP10_33p.M
[renodes,V]=mmp_l_top_right_FEVs(A)%The enodes are really those corresponding to lines with 
double(mmp.l.mtimes(A,V))==double(mmp.l.mtimes(V,mmp.l.diag(mmp.l.tops(size(renodes)))))
%its transpose and the top left fundamental eigenvectors
[lenodes,U]=mmp_l_top_right_FEVs(A.')%The enodes are really those corresponding to lines with 
double(mmp.l.mtimes(U.',A))==double(mmp.l.mtimes(mmp.l.diag(mmp.l.tops(size(lenodes))),U.'))

