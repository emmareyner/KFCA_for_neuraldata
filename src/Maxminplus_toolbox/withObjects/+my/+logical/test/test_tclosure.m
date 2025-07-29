X = ((random('unid',2,6,4)>1));
Y =  (random('unid',2,4,3)>1);
Z = my.logical.mtimes(X,Y)

Xs = (sparse(logical(X)));
Ys =  (sparse(logical(Y)));
Zs = my.logical.mtimes(Xs,Ys)
all(all(Z==full(Zs)))


%% Generate a sample matrix
X = (random('unid',2,5,3)>1);
%use multiplication on logicals
Xsq = X * X';

%% test how the the tclosure grows
N=100;
times = zeros(1,N);
params.alg = 'iterative';
fprintf('Creating and calculation transitive closure for');
for n = 2:N
    fprintf(' n=%i\n',n);
    A = my.Boolean(random('unid',3,n)>2);
    tic;
    %Aplus = tclosure(A,params);
    Aplus = tclosure(A);
    times(n)=toc;
end
fprintf('\n');
plot(1:N,times,'-b');

%% test how the the tclosure of sparse matrices grows
N=100;
stimes = zeros(1,N);
params.alg = 'iterative';
fprintf('Creating and calculation transitive closure for');
for n = 2:N
    fprintf(' n=%i\n',n);
    A = my.Boolean(sparse(random('unid',3,n)>2));
    tic;
    %Aplus = tclosure(A,params);
    Aplus = tclosure(A);
    stimes(n)=toc;
end
fprintf('\n');
hold on;
plot(1:N,stimes,'-r');
hold off;

%% TEST which type of algorithm looks more promising on SPARSE matrices
N=100;
rank=1:N;
%params.alg = 'iterative';
fprintf('Creating and calculation transitive closure for');
rank=[1,5,10,50,100,150,200];
N=length(rank);
stimes = zeros(3,N);
for n = 1:N
    fprintf(' n=%i\n',rank(n));
    A = sparse(random('unid',3,rank(n))>2);
    tic;
    %Aplus = tclosure(A,params);
    Aplusi = my.logical.tclosure(A,struct('alg','iterative'));%really costly
    stimes(1,n)=toc;
    tic;
    Aplusl = my.logical.tclosure(A,struct('alg','logarithmic'));
    stimes(2,n)=toc;
    tic;
    Aplusp = my.logical.tclosure(A,struct('alg','mpower'));
    stimes(3,n)=toc;
end
fprintf('\n');
%hold on;
plot(rank,stimes(1,:),'-b',rank,stimes(2,:),'-r',rank,stimes(3,:),'-g');
hold off;
