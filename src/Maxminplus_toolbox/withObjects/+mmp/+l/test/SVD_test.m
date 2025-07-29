%% tests of SVD for FCA matrices!!
B = [1 1 1 1 1;
    1 1 0 0 0;
    1 1 1 1 1;
    0 1 1 1 1;
    0 1 0 0 0;
    1 1 1 1 1;
    1 1 1 1 1;
    0 1 1 1 0]
A = log(B);
A(A==0)=Inf;
Ax = mmp.u.mtimes(A,-A.');
Ay = mmp.u.mtimes(-A.',A);
[SSPP, subgraphs, orders] = mmp.l.Spectrum.of_digraph(Ay);
%[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
[Ut,Ldiag,V,cnodes,nodes,InfU,InfV]=mmp.l.Spectrum.all_evs(SSPP);
[kk,perm]=sort(nodes);%permutation on the whole set of nodes
[kk,cperm]=sort(cnodes);%permutation on the critical nodes
Sp = SSPP{1};
dV = double(V(perm,cperm))
dUt = double(Ut(cperm,perm))

