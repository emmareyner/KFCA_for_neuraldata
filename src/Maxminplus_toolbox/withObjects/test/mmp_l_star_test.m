%% THis is a script to test p-stable elements of matrices!!
%function []=mmp_l_star_test(A)
% Find the lambda, whatever it is!
%generate a random matrix
for m=3:2:15
%     Generate values from the uniform distribution on the interval [a, b].
%     r = a + (b-a).*rand(100,1);
    R = (-1 +2*rand(m));
    %Another type of matrix with a percent of -Infs
    zp=0.5;%0 < zp < 1, proportion of zeros
    zp=max(0,min(zp,1))
    R=rand(m);R(R<)=0;
    range=-pi:pi/100:pi;
    plot(range,tan(range))
    -realmax/2:(realmax/100):realmax/2
    r2=[Inf (-realmax('double')/2:(realmax('double')/98):realmax('double')/2) Inf]
    plot(r2,atan(r2))
    [spectra,subgraphs,adjs] = mmp.l.Spectrum.graph_spectra(R);
    %usually this generates a single spectrum with just one lambda
    l = max(spectra{1}.lambdas);
    if l > 0, definite = false; else definite = true; end
    if definite
        fprintf('R is definite\n');
    else
        fprintf('R is NOT definite\n');
    end
    %R = log10(rand(m,m));
    %R=mmp.l.mrdivide(R,max(max(R)));%Normalize in the max.
    Rstar = mmp.l.trclosure(R);
    Rplus = mmp.l.tclosure(R);
    Rplus2 = mmp_l_finite_tclosure(R);
    %some identities on plus and Rstars.
    fprintf('Tamaño de matriz: %i\n',m)
    Eq1 = mmp_l_eq(mmp.l.mtimes(R,Rstar),Rplus);%definition of stars
    if any(any(~Eq1)), fprintf('Formula 1 no se cumple\n');end
    Eq2 = mmp_l_eq(Rstar,mmp.l.rclosure(Rplus));
    if any(any(~Eq2)), fprintf('Formula 2 no se cumple\n');end
    % equal closures
    Eq3 = mmp_l_eq(Rplus,Rplus2);
    if any(any(~Eq3)),
        fprintf('Rplus y Rfiniteplus son diferentes ');
        if ~definite%nondefinite
            fprintf('como tiene que ser!\n');
        else%(l <= 0)
            fprintf('erróneamente!\n');
        end
    end
            
end
%% Seems to work on finite closures for definite matrices.