% xp_plus_test.m
% Script para probar casos de xp_plus

%% Full, finite matrices
A=[10 20 30; 40 50 60; 70 80 90]
B=[ 1 2 3; 4 5 6; 7 8 9]

%full matrices
all(all(xp_plus(A,B)==A))

% Test scalar operations
xp_plus(Inf,B)%==np_zeros(3)
xp_plus(A,Inf)%==np_zeros(3)

xp_plus(-Inf,B)%==xp_zeros(3)
xp_plus(A,-Inf)%==xp_zeros(3)

xp_plus(5.5,B)%==xp_zeros(3)
xp_plus(A,55)%==xp_zeros(3)

%% Full and sparse-encoded matrices with INf, -Inf
%A=[-Inf -Inf 0; Inf  0 -Inf; 0 Inf -Inf]
A=[0 -Inf -Inf; Inf 2 -Inf; Inf Inf 0]
Axpsp=xp_sparse(A);
Anpsp=np_sparse(A);

%B with INf, -Inf
B=A'
Bxpsp=xp_sparse(B);
Bnpsp=np_sparse(B);

%A full, B sparse
all(all(xnp_isequal(xp_plus(A,Bxpsp),np_eye(size(A,1)))))%The heaviest
all(all(xnp_isequal(xp_plus(A,Bnpsp),np_eye(size(A,1)))))%The heaviest

%A sparse, B full
all(all(xnp_isequal(xp_plus(Axpsp,B),np_eye(size(A,1)))))
all(all(xnp_isequal(xp_plus(Anpsp,B),np_eye(size(A,1)))))

%These should all return the diagonal matrix in npsp
xp_plus(Axpsp,Bxpsp)%The heaviest
xp_plus(Anpsp,Bnpsp)
xp_plus(Axpsp,Bnpsp)
xp_plus(Anpsp,Bxpsp)
