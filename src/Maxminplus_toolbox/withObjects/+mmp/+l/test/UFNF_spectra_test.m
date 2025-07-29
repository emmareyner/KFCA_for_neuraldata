%% Load matrix examples
%clc
cd ~/src/matlab/Maxminplus_toolbox/withObjects/examples;
matrices;
cd ..;

%% Test for matrices in UFNF: NULL MATRIX
A=mmp.l.zeros(2);
%S=mmp.l.Spectrum.UFNF_3(A);
S= mmp.l.Spectrum.UFNF_3.of_digraph(A);
[Ut,LDiag,V,RDiag]=mmp.l.Spectrum.UFNF_3.UtSV(S);
all(all(full(mmp.l.mtimes(A,V)==mmp.l.mtimes(V,RDiag))))

%% Matrix with no cycles
A=mmp.l.zeros(4);
A(1,2:4)=[0 0 0];
A(2,3:4)=[0 0];
A(3,4)=0;
S= mmp.l.Spectrum.UFNF_3.of_digraph(A);
[Ut,LDiag,V,RDiag]=mmp.l.Spectrum.UFNF_3.UtSV(S);
mmp.eq(mmp.l.mtimes(A,V),mmp.l.mtimes(V,RDiag))

%% A=ABG06a. Irreducible. Finite eigenvalue.
%Detects a precision bug when testing equality to 0.0 <= eps. Changed to
%eps(16)
A=ABG06a.M;%Akian, Bapat, Gaubert, 05
str = 'ABG6a';
[subdigraphs,orders,allcycles]=digraph.crc_scc_cycles(A);
n=size(A,1);
S=mmp.l.Spectrum.UFNF_0.of_digraph(A,1:3,allcycles{1}{1});
[Ut,LDiag,V,RDiag]=mmp.l.Spectrum.UFNF_0.UtSV(S);
mmp.eq(mmp.l.mtimes(A,V),mmp.l.mtimes(V,RDiag))
mmp.eq(mmp.l.mtimes(Ut,A),mmp.l.mtimes(LDiag,Ut))
% mmp.l.eq(mmp.l.mtimes(Ut,A(Sp.nodes,Sp.nodes)),mmp.l.mtimes(Lambda,Ut))
% mmp.l.eq(mmp.l.mtimes(A(Sp.nodes,Sp.nodes),V),mmp.l.mtimes(V,Lambda))

%% %% An irreducible matrix of orden n with tops in disjoint critical cycles
A = VP10_77.M;

[subdigraphs,orders,allcycles]=digraph.crc_scc_cycles(A);
n=size(A,1);
S=mmp.l.Spectrum.UFNF_0.of_digraph(A,1:n,allcycles{1}{1});
[Ut,LDiag,V,RDiag]=mmp.l.Spectrum.UFNF_0.UtSV(S);
all(all(mmp.eq(mmp.l.mtimes(A,V),mmp.l.mtimes(V,RDiag))))
all(all(mmp.eq(mmp.l.mtimes(Ut,A),mmp.l.mtimes(LDiag,Ut))))

%% A reducible matrix with just one connected component, i. e. admitting a
% UFNF1
A = [1  0;
    -Inf 2]
[subdigraphs,orders,allcycles]=digraph.crc_scc_cycles(A);
n=size(A,1);
S=mmp.l.Spectrum.UFNF_1.of_digraph(A,subdigraphs{1},orders{1},allcycles{1});

