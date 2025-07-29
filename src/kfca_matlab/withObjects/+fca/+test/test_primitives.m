%% Test for FCA primitives implemented in +fca/@Context

%% Test of primitives on typical contexts
contexts;


%% obtain the extents and the intents
%test for full matrices
%profile on
REPS = 10; %repetitons
minTime = Inf; nsum = 10;
tic;
for i=1:REPS
    tstart = tic;
    [A,lb]=IntersectionExtents(I);%returns system of extents
    telapsed = toc(tstart);
    minTime = min(telapsed,minTime);
end
averageTime = toc/REPS;
fprintf('Intersection of extents: min time %f, average time %f', minTime,averageTime)
%[minTime,averageTime]
%profile viewer

%% Do it for sparse matrices
%test for sparse matrices
% tic
% [Asp,lb]=IntersectionExtents(spI)
% toc
% all(all(A == full(Asp)))

%[B,lb]=IntersectionExtents(Kc.I(Kc.iG,Kc.iM))
%[A,la]=IntersectionExtents((Kc.I(Kc.iG,Kc.iM))')
%[B,lb]=IntersectionIntents(I)

%% Clarify it
Kc = clarify(K);
%mat2csv(Kc,'.');

cI=Kc.I(Kc.iG,Kc.iM);
[Al,lal]=IntersectionExtents(cI);
BlfromAl=intent(cI,Al)
[Bl,lbl]=IntersectionIntents(cI);
AlfromBl=extent(cI,Bl);
%you have to reorder Al and AlfromBl to compare

%% obtain the concepts from a logical matrix
fprintf('About to obtain the extents and intents...');
tic;
[A,B]=concepts(cI)
toc;
fprintf('Done!\n');
%check that they are concepts
nc=size(A,2);%number of concepts
fprintf('Voy a evaluar los conceptos. If nothing is printed, this is good news!...');
for c=1:nc
    if ~all(A(:,c)==extent(cI,B(:,c))) ||...
            ~all(B(:,c)==intent(cI,A(:,c)))
        warning('fca:test:test_primitives','concept %i is wrong',c);
    end
end
fprintf('Done!\n');

%% Get concepts and reduced labelling
fprintf('About to obtain the extents, intents and labellings...');
tic;
[A,B,lobj,latt]=concepts(cI)
toc;
fprintf('Done!\n');

%%About to obtain concept from standard context
[A,B]=concepts(Kc);
[A,B,lobj,latt]=concepts(Kc)
cI=Kc.I(Kc.iG,Kc.iM)
% 
% %% try to do it again with Rmax,plus-FCA
% I_K=mmp.n.Sparse(log2(+K.I));
% [sY,sX]=size(I_K);
% Y=mmp.x.Sparse.eye(sY);
% inv(Y)==Y'
% X=mmp.u.eye(sX)
% %find the polars
% these_intents_normal = mmp.u.mtimes(inv(I_K),Y)

return
