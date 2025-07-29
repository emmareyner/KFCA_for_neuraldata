%% tests for constructors for class p.sparse and subclasses
dum = [-Inf -Inf -Inf;
        0   1   2;
        Inf Inf Inf];
X = p.x.sparse(dum)
N = p.n.sparse(dum)
N2= p.n.sparse(N)
N3= p.n.sparse(X)

%% test for the equality
full(eq(X,N))
all(all(eq(X,N)))
%to see that the concrete syntax for equality works...
tic; all(all(X==N));toc

%% test for the equality of representations
X == N & N == N2 & N2 == N3 

%% test of maxplus addition
Y=N
Z=X + N
full( == N)

%% Tests for involutions
Xminus = -X
Xctranspose = X'
Xtranspose = X.'