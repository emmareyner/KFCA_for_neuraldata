X = my.Boolean((random('unid',2,6,4)>1));
Y =  my.Boolean(random('unid',2,4,3)>1);
Z = mtimes(X,Y)

Xs = my.Boolean(sparse(logical(X)));
Ys =  my.Boolean(sparse(logical(Y)));
Zs = mtimes(Xs,Ys)
all(all(Z==full(Zs))


%% Generate a sample matrix
X = my.Boolean(random('unid',2,5,3)>1);
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
N=10;
times = zeros(N,3);
%params.alg = 'iterative';
fprintf('Creating and calculation transitive closure for');
for n = 2:N
    fprintf(' n=%i\n',n);
    A = my.Boolean(random('unid',3,n)>2);
    tic;
    %Aplus = tclosure(A,params);
    Aplusi = tclosure(A,struct('alg','iterative'));
    stimes(1,n)=toc;
    tic;
    Aplusl = tclosure(A,struct('alg','logarithmic'));
    stimes(2,n)=toc;
    tic;
    Aplusp = tclosure(A,struct('alg','mpower'));
    times(n,3)=toc;
end
fprintf('\n');
hold on;
plot(stimes);
hold off;

%% TEST which type of algorithm looks more promising on SPARSE matrices
N=10;
stimes = zeros(3,N);
params.alg = 'iterative';
fprintf('Creating and calculation transitive closure for');
for n = 2:N
    fprintf(' n=%i\n',n);
    A = my.Boolean(sparse(random('unid',3,n)>2));
    tic;
    %Aplus = tclosure(A,params);
    Aplusl = tclosure(A,struct('alg','logarithmic'));
    stimes(1,n)=toc;
    tic;
    Aplusi = tclosure(A,struct('alg','iterative'));
    stimes(2,n)=toc;
    tic;
    Aplusp = tclosure(A,struct('alg','mpower'));
    stimes(3,n)=toc;
end
fprintf('\n');
hold on;
plot(1:N,stimes,'-rgb');
hold off;
