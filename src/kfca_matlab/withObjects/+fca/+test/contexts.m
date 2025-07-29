%% All sort of  context to do tests on fca and kfca
% Define a well-known incidence and create a context
incidences={};
names={};

%% An inventory of incidences: add here following the pattern
% Easy cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=1
incidences{n} = true(2,3);
names{n}='AllOnes_2x3';
%just one concept
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=n+1
incidences{n} = false(3,2);
names{n} ='AllZeros_2x3';
%two concepts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%N5, one of the funny lattices
n=n+1
incidences{n} = logical(...
    [1 1 1 1 1;
     1 1 0 0 0;
     1 1 1 1 1;
     0 1 1 1 1;
     0 1 0 0 0;
     1 1 1 1 1;
     1 1 1 1 1;
     0 1 1 1 0]);
%spI = sparse(I);
names{n}= 'Ganter&Wille_p25';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Contex similar to clarified previous one
n=n+1
incidences{n} = logical(...
    [...
     1 1 1 1;
     1 1 0 0;
     0 1 1 1;
     0 1 0 0;
     0 1 1 0]);
%spI = sparse(I);
names{n}= 'Ganter&Wille_p25_clarified';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Contex similar to reduced previous one
n=n+1
incidences{n} = logical(...
    [1 0 0;
     0 1 1;
     0 1 0]);
%spI = sparse(I);
names{n}= 'Ganter&Wille_p25_reduced';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=n+1
incidences{n} = logical(...
    [1 0; 1 0]);
%spI = sparse(I);
names{n}= 'lattice_2';

%this is a big random context to be generated every time 
n=n+1;
th = 0.5;%Threshold
incidences{n}=unifrnd(0,1,10,20) > th;
names{n}=sprintf('uniform_randon_th_%f',th);

%% Analyze a medium-sized context
[A,lb]=IntersectionExtents(incidences{n})


%% Obtain all contexts and their sparse versions
K={1,n};
spK={1,n};
for n=1:length(incidences)
    I=incidences{n};name=names{n};
    K{n} = fca.Context(I,name);
    spK{n}=fca.Context(sparse(I),sprintf('sparse_%s',name));
end

