%%%A script to test macro and microaveraging
%% parameters
m=200;n=30;
k=10;%numnber of random results
a = random('unid',k,m,n);
%asp = sparse(a);
b = random('unid',k,m,n);
%bsp = sparse(b);

%% Obtain micro and macro averaging and put them in 
points=floor(100/k);
MP=zeros(points-1,n);
MR=zeros(points-1,n);
mP=zeros(points-1,1); mR=zeros(points-1,1);
for i=2:points
    ai=(a < i);
    bi=(b < i);
    [MP(i,:),MR(i,:),mP(i),mR(i)]=micro_macro_averagedPR(ai,bi);
end

%Now plot the graphs
