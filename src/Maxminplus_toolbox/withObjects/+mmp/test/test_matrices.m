%% Definiciones
A=[10 20 30;
    40 50 60; 
    70 80 90]
%Bshould have infinite entries and different nos. of rows and cols
B=[ 1 2 3; 4 5 6; 7 8 9]
C=[0 -Inf -Inf -Inf;
    Inf 1 -Inf -Inf;
    Inf Inf 2 -Inf];
D=[-Inf -Inf -Inf -Inf -Inf;
    Inf -Inf Inf Inf -Inf;
   0   1   2  Inf -Inf;
   Inf Inf Inf Inf Inf];

%% maxplus encoding
Ax = mmp.x.Sparse(A);
Bx =mmp.x.Sparse(B);
Cx=mmp.x.Sparse(C);
Dx = mmp.x.Sparse(D);

%% minplus encoding
An = mmp.n.Sparse(A);
Bn =mmp.n.Sparse(B);
Cn=mmp.n.Sparse(C);
Dn = mmp.n.Sparse(D);

%% invert matrices
Ainv = mmp.inv(A);
Binv = mmp.inv(B);
Cinv= mmp.inv(C);
Dinv = mmp.inv(D)

Axinv = mmp.inv(Ax);
Bxinv = mmp.inv(Bx);
Cxinv= mmp.inv(Cx);
Dxinv = mmp.inv(Dx)

Aninv = mmp.inv(An);
Bninv = mmp.inv(Bn);
Cninv= mmp.inv(Cn);
Dninv = mmp.inv(Dn)

%% Matrices from CuninghameGreen's book
Ap207 = ...
    [1 2 -Inf 6;
     1 3 -Inf -Inf;
     1 -Inf 1 -Inf;
     -Inf -Inf 2 2]
 mmp.l.tclosure(Ap207)
 
 
 %% matrices from Chapter25
 %%condensation with A_23 = Top
perturbed = [ 0 0 0 -Inf;
              -Inf Inf -Inf 0;
              -Inf -Inf 0 0;
              -Inf -Inf -Inf 0];
mmp.l.tclosure(perturbed);
