%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% A maxplus matrix whose right spectrum is known. Obtained from Akian, Bapat,
%Gaubert, 2006
% This has some code to find matrices of (possibly related, sibling)
% right and left eigenvectors.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load matrix examples
cd ~/src/matlab/Maxminplus_toolbox/withObjects/examples;
matrices;%load all matrices
cd ..;

%% A=ABG06b. Irreducible. Finite eigenvalue.
%Detects a precision bug when testing equality to 0.0 <= eps. Changed to
%eps(16)
A=ABG06a.M;%Akian, Bapat, Gaubert, 05
TestSp=ABG06a.Sp

%% A=ABG06b. Reducible. Finite eigenvalues. Classes eclipsed from above and
%%below. Some eigenvectors strictly in cmaxplus
A=ABG06b.M;%Akian, Bapat, Gaubert, 05
%A=sparsemp(ABG06b.M)
TestSp=ABG06b.Sp{1}

%% Perturbed ABG06b. REducible. Infinite eigenvalue. Classes eclipsed from
%%above and below. Some eigenvectors strictly in cmaxplus. Eigenvectors
%%for infinite eigenvalue.
A=ABG06bp.M
TestSp=ABG06bp.Sp

S=A(2:4,2:4)%Select infinite block
Srowmax=max(S,[],2)
Srowmin=min(S,[],2)
Scolmax=max(S)
Scolmin=min(S)
cols=find(Srowmax~=mpm_zero)'%Indices of cols with Supports to be saturated
%FInd all finite supports to be saturated:
tosat={};%tosat{j} stores de supports of cols with supports to be saturated.
for j=1:size(cols,2)
    tosat{j}=find(S(:,cols(j))~=mp_zero);
end
%%mp_multi(S,Srowmax)==mp_multi(Srowmax,Inf)%Hypothesis
%%Vamos a ver qué supone poner un Inf en cada fila del egv
%%Lo hacemos con los supports.
supp=(S~=mp_zero);%Constant
saturated=false(p);%Accumulates candidate eigenvectors.
for i=1:p
    vk=supp(:,i);%Start with support in single
    while any(saturated(:,i)~=vk)
        saturated(:,i)=vk;
        vk=any([vk supp(:,saturated(:,i))],2)
    end
end
%% CHEN90
A=CHEN90.M
TestSp=CHEN90.Sp


%% MGD05. El diagrama de clases es lineal y tiene clases eclipsadas por
%%% arriba y debajo.
A=MGD05.M;
TestSp=MGD05.Sp;

%% Prueba de  BGCG07: dos subgrafos.
A=BGCG07.M;

%% To make things a little bit more difficult, let's shuffle the matrix
% perm=randperm(m)
% A=A(perm,perm)
%In the process of building the spectrum, somehow this permutation or its
%inverse have to be found.

%%%%%%% TESTED SO FAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 0 test calculating components and cycles
[subgraphs,orders,allcycles]=crc_scc_cycles(A)
    s=1%inspect a particular component
    comps=subgraphs{s};
    order=orders{s};

%% 1 Find the spectra of all disconnected components as a list
fprintf('We want to obtain its RIGHT and LEFT spectrum...');
[g m] = size(A.reg);
%profile clear
%profile on
[subgraphs,orders,spectra] = mp_spectra2(A);
fprintf('Done!\n');

sspectra=size(spectra,2);
if  sspectra==1
    warning('matriz A sólo tiene 1 subgrafo')
else
    warning('There are %i completely reducible components.\n',sspectra);
end
if sspectra ~= TestSp.sspectra, error('Too many components!\n'); end

%% Visualization of results
for s=1:sspectra
    %% Set up
    fprintf('Analyzing CRC %i:\n',s);
    Sp=spectra{s};
    comps=subgraphs{s};
    order=orders{s};
%profile off
%profile viewer
%%% Build an index to reorder matrices in the new order
% $$$ neworder=zeros(
% $$$ for i=1:size(comps,2)

%% Sort and check the lambdas
    [slambdas,li]=sort(Sp.lambdas,'descend')
    [tlambdas,ti]=sort(TestSp.lambdas,'descend')
    fprintf('%s','See if the lambdas are OK...');
    lambdasOK = mp_isequal(slambdas, tlambdas);
    lambdasOK=arrayfun(@mp_isequal,slambdas,tlambdas);
    if all(lambdasOK)
        fprintf('YES!\n');
    else
        fprintf('NO!\n The following lambdas are not OK: %i \n',...
            Sp.lambdas(li(~lambdasOK)));
    end

%% Check whether the rho_max is OK
    test_rho_max = max(TestSp.lambdas);
    fprintf('The rho_max(A) should be %f...',test_rho_max);
    rho_max = max(Sp.lambdas);
    if mp_isequal(rho_max, test_rho_max)
        fprintf('YES!\n');
    else
       fprintf('NO! rho_max is: %f\n',rho_max);
    end
%% 
end

%% Check whether the eigenvalues are really such A * evs = lambda * evs
fprintf('About to check the eigenvectors...\n');

% Let's do all this in a more compact way by using a primitive
% Note that the eigenvectors shown here are *effective* eigenvectors, (q.v.
% mp_UtLV(Sp)
%[Ut,ldiag,V,cnodes]=mp_UtLV(Sp)%this is for single subgraph spectra.
[Levst,ldiag,Revs,cnodes,nodes]=mp_all_evs(spectra)%this is for multiple subgraph spectra
fprintf('About to check the eigenvectors...\n');
% The eigenvalue equations
Lambda = mp_diag(ldiag);
% mp_isequal(mp_multi(Ut,A(nodes,nodes)),mp_multi(Lambda,Ut))
% mp_isequal(mp_multi(A(nodes,nodes),V), mp_multi(V,Lambda))
if ~(mp_isequal(mp_multi(A(nodes,nodes),Revs), mp_multi(Revs,Lambda)))
    warning(sprintf('The right evs of A are not right!'));
    for  f= find(any(mp_multi(A,Revs) ~=  mp_multi(Revs,Lambda)))
        fprintf('  The right eigenvector %i for lambda=%f is not right!\n', f,Lambda(f,f));        
    end
end
if ~(mp_isequal(mp_multi(Levst,A(nodes,nodes)),mp_multi(Lambda,Levst)))
    warning(sprintf('The left evs of A are not right!'));
    %faulty=any(mp_multi(Ut,A) ~= mp_multi(Lambda,Ut),2);
    for f=find(any(mp_multi(Levst,A) ~= mp_multi(Lambda,Levst),2))'
        fprintf('  The left eigenvector %i for lambda=%f is not right!\n', f,Lambda(f,f));
    end
end
fprintf('Done!\n');


%% Check that they have actually be done right.
[kk snodes]=sort(nodes);
% all(all(allrevs==V(snodes,:)))|| warning('Right eigenvectors not right!');
if ~(mp_isequal(mp_multi(A,Revs(snodes,:)), mp_multi(Revs(snodes,:),Lambda)))
    warning('Right eigenvectors not right!');
end
% all(all(alllevs==Ut(:,snodes))) || warning('Left eigenvectors not right!');
if ~(mp_isequal(mp_multi(Levst(:,snodes),A),mp_multi(Lambda,Levst(:,snodes))))
    warning('Left eigenvectors not right!');
end


