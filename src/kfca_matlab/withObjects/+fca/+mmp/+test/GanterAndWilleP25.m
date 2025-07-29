%% Test the mmp primitives on contexts injected from logical contexts
clear all
fca.test.contexts
%

%% Now transform one of the contexts into mmp.
% TODO: transform this into a constructor for mmp.Context
fprintf('Getting maxplus context...')
thisK = K{4};
thisK = fca.mmp.Context(thisK.I);
fprintf('Done!\n')

%% Now obtain all intents and all extents from gamma
objs = toMaxplus(logical(eye(thisK.g,2)))
thisK.intent(0,objs)
[a_from_gamma,b_from_gamma]=thisK.gamma_concept(0,objs)

%the extents are the rows
real_a_gamma = [...
    1 0 0 0 0;
    1 1 0 0 0;
    1 0 1 0 0;
    1 1 1 1 1;
    1 0 1 0 1];
%the intents are the columns
real_b_gamma = [
    1 1 0 0 0;
    1 1 1 1 1;
    1 0 1 0 1;
    1 0 1 0 0];
%[real_a_gamma toLogical(a_from_gamma)]

all(all(real_a_gamma == toLogical(a_from_gamma)))


[real_b_gamma toLogical(b_from_gamma)]

real_b_gamma == toLogical(b_from_gamma)

%% do the same from mu
[a_from_mu,b_from_mu]= thisK.mu_concept(0,double(mmp.l.eye(thisK.m)))


a_from_gamma == a_from_mu

toLogical(a_from_gamma)