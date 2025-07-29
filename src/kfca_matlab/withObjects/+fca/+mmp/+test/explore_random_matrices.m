%% Random confusion matrix exploration
function [hSimpSynth,hTriSynth,hTriSplit] = explore_random_matrices()
% This application is fca.mmp.test.explore_random_matrices. It is design to
% test the concept exploration of random matrices ranging from uniform to
% diagonal
% TODO: transform it into a function!!!
% The parameters are:
% - lambdas (0<= lambdas <= 1), the interpolation coefficients for the
% uniform and the diagonal confusion matrix.
% - m: number of objects
% - g: number of attributes
% - doprofiling (false): a switch between profiling and no profiling
% - maxtrials (g*m*10): the number of iterated experiments to generate the random
% matrices by sampling
% - exp(1): number of experiments to average over.
%
% BUGS: problem with ticks in concept count figures
% TODO: switch to express concept counts either logarithmically or
% linearly.
% TODO: draw average MI in the concept count plots.

cd ~/05experimentos/confusion_matrices/random
outdirbase='test_sweeping_phi';

doprofiling = false;
%doprofiling=true;
%sweep = true,
sweep = false;

%% start the profiler
if doprofiling
    profile on
end

%% Dimension experiments
%g=50;
%g=36;%morsecodes dimension
g=16;%Consonants in Miller and Nicely experiments
%g=10;%Segmented digits
%g = 7;
% g=5;
%g=4;
m=g;%No of attributes
if g < 1 || m < 1
    error('fca:mmp:test:explore_random_matrices','void contexts');
end

%% Have a sufficiently important population of trials
MillerNicely = true;
average = true;
if MillerNicely
    maxtrials=4000;%Miller and Nicely
elseif average %#ok<UNRCH>
    maxtrials=g*m*10;%on average, 10 trials per joint event
else
    maxtrials=1000;%No of possible trials.
end
%maxtrials=4000;%number of trials in Miller and Nicely
if (maxtrials < 11)
    error('No possible estimation!');
end

%% Demand number of stochastic experiments
%nexp=10;
%nexp=5;
%nexp=3;
nexp=1;
if (nexp < 1)
    error('No experiments requested!');
end

%% Generate the combination coefficients
%%Lambda combination values:
% l=0.0 => uniform distribution
% l=1.0 => diagonal distribution
%lambdas=0.0:0.5:1.0;
lambdas=0.0:1/11:1.0;
%lambdas=lambdas.^2;%accentuate things close to lambda = 0
%lambdas=0.0:0.20:1.0;
%lambdas=log10(1:9/7:10);%seven values, to compare with M&N
%lambdas = 1-10.^(0:-1:-10);
%lambdas=0.0:0.2:1.0;
%lambdas=0.0:
nlambdas=size(lambdas,2);
%reprangecnt=n*n;%potential number of different phi values

%% Generate the grid of counts of concepts with same reprange of values
%npoints=51;
npoints=101;
 
%% Pre-store for exploration results
nc=cell(nexp,nlambdas);%stores vector of concept counts for each exp
phis=cell(nexp,nlambdas);%stores phi values
ccounti=zeros(nexp,nlambdas,npoints);%will store concept count for each exp and lambda AFTER interpolation


%% iterate over experiments
for e=1:nexp%iterate over experiments

%     % distribute these randomly! in n bins
%     % a) uniformly distributed
%     count_cm = random('unid',m,n)
%     % b) Diagonally distributed
%     count_cm = diag(random('unid',m,1))
    %%1 Generate a prior count on emitted symbol frequencies
    %cprior=random('unid',maxtrials,g,1);
    %p=ones(1,g);p(:)=1/g;%the count priors
    p = ones(1,g)/g;%repmat(1/g,1,g);%the uniform count priors
    cprior=(mnrnd(maxtrials,p))';%Distribute the trials among the bins with the multinomial

    %Generate uniformly random posteriors for the received symbols' frequencies
    %FVAQ: why use the posteriors to normalize here? Because mnrnd below
    %needs rows of "posterior" to add to 1. Otherwise it would generate
    %NaN.!
    %rndposterior=random('unid',m^2,g,m);
    %rndposterior=random('unid',maxtrials,g,m);
    %rndposterior=inv(diag(sum(rndposterior,2)))*rndposterior;%normalization
    %rndposterior=zeros(g,m);rndposterior(:)=1/m;%This 
    rndposterior=ones(g,m)/m;%repmat(1/m,g,m);
    
    %Generate diagonal delta distributions to be interpolated
    dposterior=eye(g,m);%delta functions in the diagonal places!
    %dposterior=diag(cprior);%delta functions in the diagonal places!
    %dprior=diag(random('unid',maxtrials,max(g,m),1));%This does not
    %row-add to one!
    %dposterior = dprior/sum(diag(dprior));%A slightly more unbalanced diagonal prior
    H_Pxy = zeros(nlambdas,1);
    H_Px = zeros(nlambdas,1);
    H_Py = zeros(nlambdas,1);
    MI_Pxy = zeros(nlambdas,1);
    
    %%Generate mixtures of both distributions
    h = figure(1);
    for l=1:nlambdas
        fprintf('Experimento %i, lambda: %f\n',e,lambdas(l));
        
        %interpolate distributions
        %%lambda(1) = 0.0 is for the random posterior
        %%lambda(10)= 1.0 is for the diagonal posterior
        posterior=lambdas(l)*dposterior+(1-lambdas(l))*rndposterior;
        
        %%Generate a confusion matrix of multinomial counts same model for
        %%each emitted symbol
        %posterior needs to row-add to 1.
        count_cm= mnrnd(cprior,posterior);
         %Postcond: all(sum(posterior,2)-1<=eps)
         if any(any(isnan(count_cm)))
             error('fca:mmp:test:explore_random_matrices','posterior distributions where not stochastic!');
         end
%         while any(any(isnan(count_cm)))%iterate so that no nan is generated!!
%             count_cm = mnrnd(cprior,posterior);
%         end
% %         mycm= mnrnd(cprior,posterior)
% %         while not(any(any(isnan(mycm)))), mycm = mnrnd(cprior,posterior); end

        % Work out the Pointwise mutual information and the counts
        %[conf_mat,Pc] = pmi(count_cm);
        %the following also provides information about the distribution of
        %PMI
        %[conf_mat,Pc] = explore_pmi(count_cm,h,nlambdas,l,'normalize');
        [conf_mat,Pc] = explore_pmi(count_cm,h,nlambdas,l);
        [H_Pxy(l),H_Px(l),H_Py(l),MI_Pxy(l)] = entropies(Pc);
        
%         %% Normalize in the mean! 
%         % FVA: What is this for?
%         avg=sum(sum(conf_mat(nz)))/size(nz,1);
%         conf_mat=conf_mat-avg;%TODO: write in maxplus terms!

        %%Create a context to sweep
        name=sprintf('rnd_%i_%i_exp_%i_lmbd_%f',g,m,e,lambdas(l));
        K=fca.mmp.Context(conf_mat,name);

        %%Carry out sweeping
        if sweep
            %         ignoreperfect=false;
            %         perfectmask=eye(size(conf_mat));%A sample mask!
            %%% We should not have to invoke sweep in phi with the mask if
            %%ignoreperfect is false!!
            %        Kout = mpfca_explore_in_phi(K,outdirbase,ignoreperfect,perfectmask);
            Kout = explore_in_phi(K,outdirbase);
            
            %the number of concepts for phi = Inf is always 1
            %the number of concepts for phi = -Inf is always 2
            nc{e}{l}=[1; Kout.nc;2];
            phis{e}{l}=[-Inf; Kout.Phis; Inf];
            %[ccounti(e,l,:) reprange streprange]=interpolate_counts(Kout,npoints,'atanh');
            [ccounti(e,l,:) reprange streprange]=interpolate_counts(Kout,npoints,'logit');
        end
    end
end
hold off%Stop drawing in the same figure
%profile viewer
%% Visualize
N=g;M=m;
H_Ux = log2(N);
H_Uy = log2(M); %same size for all
hSimpSynth = explore_entropies(H_Ux,H_Uy,H_Pxy,H_Px,H_Py,MI_Pxy,'tags','*');
%set(hSimpSynth,'MarkerSize', 12);%This cannot be done on figures, but on
%plots!
%explore_entropies(Hmax,H_Pxy,H_Px,H_Py,MI_Pxy,h3D,'*k');%normalized, 3D, non-Mairesse projected
hTriSynth = explore_entropies(H_Ux,H_Uy,H_Pxy,H_Px,H_Py,MI_Pxy,'triangle','*');%entropy triangle, fraction tags
% = explore_entropies(Hmax,H_Pxy,H_Px,H_Py,MI_Pxy,hMai,'triangle','*k');%normalized, 3D, Mairesse projected
%explore_entropies(Hmax,H_Pxy,H_Px,H_Py,MI_Pxy,h3D);
%set(hTriSynth,'markerSize',12);
hTriSplit = explore_entropies(H_Ux,H_Uy,H_Pxy,H_Px,H_Py,MI_Pxy,'split','b');%entropy triangle, fraction tags
return

%% Exploring the classifiers, human vs. machine!
h = figure(6);%same one as in Miller and Nicely!
N=g;M=m;
title('Human vs. Random classifiers');
plot(H_Pxy-MI_Pxy,log2(N)+log2(M) - H_Px - H_Py,':*');
legend('Miller and Nicely, 1955','Random interpolation');
%% view the 

% %% 1.- Generate interpolating grid for the compression function
% %There might be some phi=Inf!! Hence we have to compress the reprange through
% %something like the sigmoid!
% %iplate='sigmoid';
% iplate='atanh';
% % Either sigmoi, atanh
% switch iplate
%     case 'logit'
%     % a) The desired reprange
%     reprange=0:0.02:1;
%     reprangei=logit(reprange);
%     case 'atanh'
%      % b) pass trough function to decompress
%     reprange=-1:0.02:1;
%     reprangei=atanh(reprange);
%     otherwise
%         error('Modo de interpolación sin especificar!');
% end
% nr=size(reprange,2);
% %Generate subrepranges adequate for plot axes Xticklabels.
% subreprangei=reprangei(1:round(nr/10):nr);
% streprange = arrayfun(@(x)num2str(x,2), reprangei(1:4:41),'UniformOutput',false);
% 
% %% 2.- Interpolate
% %minphi=Inf;maxphi=-Inf;
% ccounti=zeros(nexp,nlambdas,size(reprangei,2));
% for e=1:nexp
%     for l=1:size(lambdas,2)
% %         %always add (Inf,1) to list
% %         if (phis{e}{l}(end) ~=Inf)
% %             phis{e}{l}(end+1)=Inf;
% %             nc{e}{l}(end+1)=2;
% %         end
%         % c).- Generate count interpolations, except at -Inf and Inf
%         interpol=...
%             interp1(phis{e}{l},nc{e}{l},reprangei(2:end-1),'nearest','extrap');
% %            interp1(phis{e}{l},nc{e}{l},reprangei(2:end-1),'linear','extrap');
% %            interp1(phis{e}{l},nc{e}{l},reprangei,'pchip','extrap');
% %            interp1(phis{e}{l},(nc{e}{l}),reprangei,'nearest','extrap');%OK
%         %supply values at -Inf, Inf
%         ccounti(e,l,:) =[1 interpol 2];
%     end
% end
% %Do not average realisations to observe all phenomena
% %plot(reprange,ccounti)

%% If sweeping over phi
if sweep
    %% 4.- Average interpolations
    %size(ccounti)
    %[e,l,p]=size(ccounti);
    if nexp==1 && nlambdas == 1
        avgccounti=reshape(ccounti, [1 npoints]);
    else
        %TODO: a reshape here!
        avgccounti=mean(ccounti,1);
        varccounti=var(eps+ccounti,1);%This trick shouldn't present problems with 0 counts
        stdccounti=sqrt(varccounti);
    end
    % %varccounti=var(ccounti);%Returns a funny error: let's go the loooong
    % %way.
    % stdccounti=zeros(size(avgccounti));
    % for e=1:nexp
    %     stdccounti = stdccounti+ccounti(e,:)-avgccounti;
    % end
    % varccounti=(stdccounti.^2)/nexp;
    %stdccounti=std(ccounti)
    
    %% Try to plot
    %Get the curves in the same matrix.
    %semilogy(reprange,avgccounti,'k',reprange,avgccounti+varccounti,'r:',reprange,max(0,avgccounti-varccounti),'r:');
    curves=zeros(nlambdas,size(reprange,2));
    curves(:)=avgccounti(1,:);
    labels = arrayfun(@(l) sprintf('lambda = %3.2f',l), lambdas,'UniformOutput',false);
    %list of tick marks
    xticks= streprange(1:(floor(npoints/4)):npoints);
    
    %% Figura con Y lineales.
    f1=figure(1);
    %semilogy(reprange,avgccounti,'k',reprange,avgccounti + stdccounti,'r:',reprange,max(0,avgccounti-stdccounti),'r:');
    plot(reprange,curves);
    set(gca,'XTickLabel',xticks);
    legend(labels,'Location','NorthWest');%Upper left hand corner
    
    %% Figura con Y logarítmicas.
    f2=figure(2);
    semilogy(reprange,curves);
    set(gca,'XTickLabel',xticks);
    legend(labels,'Location','NorthWest');%Upper left hand corner
end%if sweep
hold off

%% Explore the data
% size(avgccounti)
% avgccounti(1,11,:)

% %% see percentiles!
% p=[25 50 75];
% pct=prctile(ccounti,p);
% pct=prctile(ccounti,p,npoints)
% semilogy(reprange,pct,reprange,avgccounti,'k+');

%% End the profiles
if doprofiling
    profile off
    profile viewer
end
