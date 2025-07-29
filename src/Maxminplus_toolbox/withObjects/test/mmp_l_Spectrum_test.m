%% Test of mmp.l.Spectrum primives
load "matrices";

%First test the spectrum on a normal matrix.
A=ABG06b.M;
[SSPP,subgraphs,orders] = mmp.l.Spectrum.graph_spectra(A);
Sp=SSPP{1};
[Ut,Ldiag,V,cnodes]=mmp.l.Spectrum.all_evs(SSPP);
(mmp.l.mtimes(Ut,A(Sp.nodes,Sp.nodes)) == mmp.l.mtimes(mmp.l.diag(Ldiag),Ut))
(mmp.l.mtimes(A(Sp.nodes, Sp.nodes),V) == mmp.l.mtimes(V,mmp.l.diag(Ldiag)))

%Then test the spectrum on a sparse matrix
SpA = mmp_l_sparse(A);
[SSPPsp,subgraphs,orders] = mmp.l.Spectrum.graph_spectra(SpA);%sparse
SpSp=SSPPsp{1};
%let's compare spectra
mmp_l_eq(Sp.levs{1}{1},mmp_l_full(SpSp.levs{1}{1}))
mmp_l_eq(Sp.levs{2}{1},mmp_l_full(SpSp.levs{2}{1}))
mmp_l_eq(Sp.levs{2}{2},mmp_l_full(SpSp.levs{2}{2}))
mmp_l_eq(Sp.levs{3}{1},mmp_l_full(SpSp.levs{3}{1}))
mmp_l_eq(Sp.levs{4}{1},mmp_l_full(SpSp.levs{4}{1}))


[Utsp,Ldiagsp,Vsp,cnodessp]=mmp.l.Spectrum.all_evs(SSPPsp);
mmp_l_eq(Ut,mmp_l_full(Utsp))
mmp_l_eq(V,mmp_l_full(Vsp))
full(mmp_l_eq(mmp.l.mtimes(Utsp,SpA(SpSp.nodes,SpSp.nodes)), mmp.l.mtimes(mmp.l.diag(Ldiagsp),Utsp)))
full(mmp_l_eq(mmp.l.mtimes(SpA(SpSp.nodes, SpSp.nodes),Vsp), mmp.l.mtimes(Vsp,mmp.l.diag(Ldiagsp))))
