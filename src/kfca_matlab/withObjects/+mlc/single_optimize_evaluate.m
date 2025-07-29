function [criteria,measures,Training,optPhis,optTraining,Test,h] =...
    single_optimize_evaluate(hatKE,hatKT,KE,KT,incriteria,inmeasures)
% function [criteria,measures,Training,optPhis,optTraining,Test,h] =...
%   mlc.single_optimize_evaluate(hatKE,hatKT,KE,KT,incriteria,inmeasures)
%
% A function to optimize on an explored version of the context [hatKExplores] a number of
% [criteria] and then evaluate a set of [measures] measures
%
% Input:
% [hatKE]: explored training context to be optimized.
% [hatKT]: non-explored test context to be optimized.
% [KE] : real training decisions context
% [KT] : real test decisions context
%
% [incriteria]: list of criteria for classification optimization
% - 'Hloss': optimize minimum Hamming loss
% - 'miF1': optimize maximum micro F-measure
% - 'maF1': optimize maximum macro F-measure
%
% [inmeasures]
% - 'PR': micro and macro precision-recall
% - 'Hloss': Hamming loss
% - 'F1': F-measure
% If you ask for 'PR' or 'F1' you get both the micro and macro measures!
%
% Output:
% [criteria]: the list of criteria actually used.
% [measures]: the list of measures actually carried out.
% [optPhis]: the optimal phis coindexed by the criteria.
error(nargchk(4,6,nargin));
if (~hatKE.explored)
    error('mlc:single_optimize_evaluate', 'Training context should be already explored!')
end

%Number of explored phis
nPhis = length(hatKE.Phis);
if (nPhis == 0)
    error('mlc:single_optimize_evaluate','Void phi range!');
end

%provide defaults or change criteria and measures to lowercase
if (nargin < 5) || isempty(incriteria)
    criteria = {'hloss'};
    warning('mlc:single_optimize_evaluate', 'Optimizing criterion not provided. Using default!')
else
    criteria = cellfun(@lower,incriteria,'UniformOutput',false);
end
if (nargin < 6) || isempty(inmeasures)
    measures = {'hloss'};
    warning('mlc:single_optimize_evaluate', 'Evaluating measures not provided. Using default!')
else
%     measures = cellfun(@lower,inmeasures,'UniformOutput',false);
    measures=inmeasures;
    for e=1:length(measures)
        switch lower(measures{e})
            case 'hloss'%Hamming loss
                measures{e} = 'hloss';
            case {'pr','mipr','mapr'}%micro and macro P-R
                measures{e} = 'pr';
            case {'f1','mif1','maf1'}%micro and macro F-measure
                measures{e} = 'f1';
        end
    end
    measures=unique(measures);
end

%prepare the output parameters
nCriteria = length(criteria);
nMeasures = length(measures);
h=figure();
subplot(nCriteria,nMeasures,1);
sizh= [nCriteria nMeasures];
optPhis = zeros(nCriteria,1);
optTraining = zeros(nCriteria,1);
Training = struct();%Empty struct storing all measures on training set!
Test = struct();%Empty struct storing all measures on test set!

%Prepare storing the training results
mPE = zeros(1,nPhis);%micro precision in training
mRE = zeros(1,nPhis);%micro recall in training
MPE = zeros(1,nPhis);%macro precision in training
MRE = zeros(1,nPhis);%macro recall in training
mFE = zeros(1,nPhis);%macro F- measure
MFE = zeros(1,nPhis);%macro F- measure
Hloss=zeros(1,nPhis);%Hamming loss

%Work out the actual figures in training...
if (hatKE.minplus)%if the exploration was minplus
    for i = 1:nPhis
        [mPE(i),mRE(i),MPE(i),MRE(i),mFE(i),MFE(i),Hloss(i)]=...
            my.logical.micro_macro_averagedPR(KE.I,hatKE.R >= hatKE.Phis(i));
    end
else%maxplus order exploration
    for i = 1:nPhis
        [mPE(i),mRE(i),MPE(i),MRE(i),mFE(i),MFE(i),Hloss(i)]=...
            my.logical.micro_macro_averagedPR(KE.I,hatKE.R <= hatKE.Phis(i));
    end
end

% Go over ptimization criteria finding results
for j = 1:nCriteria
    switch criteria{j}
        case 'hloss'
            criterion = 'Hamming loss';
            %Choose phi by minimal Hamming loss in the TRAINING SET
            optTraining(j) = min(Hloss);
            i_opt = find(Hloss==optTraining(j));
        case 'mif1'%micro FE
            criterion = 'Micro averaged F1';
            %Choose phi by maximal micro-averaged F-measure in the TRAINING SET
            optTraining(j) = max(mFE);
            i_opt = find(mFE==optTraining(j));
        case 'maf1'%macro FE
            criterion = 'Macro averaged F1';
            %Choose phi by maximal macro-averaged F-measure in the TRAINING SET
            optTraining(j) = max(MFE);
            i_opt = find(MFE==optTraining(j));
        otherwise
            error('mlc:single_optimize_evaluate',...
                  'Unknown criterion for optimizing MLC: %s',criteria{j})
    end
    fprintf('Maximizing by criterion: %s\n',criterion);
    %Get the actual index of the element optimizing the criterion
    nOptArgs = length(i_opt);
    if (nOptArgs > 1)
        warning('mlc:single_optimize_evaluate','More than one optimal argument! Choosing one at random\n');
        %i_opt = i_opt(1);%on a tie, choose the first: FVA CAUTION!
        perm = randperm(nOptArgs);%on a tie, choose at random
        i_opt = i_opt(perm(1));
    end
    %get the actual phi that optimizes the criterion
    opt_phi = hatKE.Phis(i_opt);%used many times!
    optPhis(j) = opt_phi;
    fprintf('*Optimal varphi=%1.4f\n',opt_phi);
    %Find the thresholded version of the test context
    if (hatKE.minplus)%if the exploration was minplus
        hatKT_opt = (hatKT.R >= optPhis(j));
    else
        hatKT_opt = (hatKT.R <= optPhis(j));
    end
    
    %Now go over test set evaluating at the optimal phi and plot everything
    [mPT,mRT,MPT,MRT,mFT,MFT,HLossT]=my.logical.micro_macro_averagedPR(KT.I,hatKT_opt);
    for e = 1:nMeasures
        subplot(nCriteria,nMeasures,sub2ind(sizh,j,e));
        switch measures{e}
            case 'hloss'
                measure='Hamming loss';
                %find the test loss
%                [~,~,FP_T,FN_T]=my.logical.roc(KT.I,hatKT_opt);
%                Test(j,e) = (sum(sum(+FP_T))+sum(sum(+FN_T)))/numel(KT.I);
                Test.Hloss = full(HLossT);
                Training.Hloss = Hloss;
                
                %Plot in Hloss places
                %hHloss = figure();
                plot(hatKE.Phis,Hloss,'-b',optPhis(j),Test.Hloss,'r+')
%                 figure(hHloss);
%                 hold on
%                 plot(optPhis(j),Test(j,e),'r+');
%                 legend boxon
                legend('Training Set curve','Test Set point')
                title(sprintf('%s optimized by %s',measure, criterion));
                fprintf('**Optimal training %s: %1.4f\n',measure,Training.Hloss(i_opt));
                fprintf('**Optimal testing %s: %1.4f\n',measure,Test.Hloss);
            case {'pr'}
                measure='P-R';
                %hPR = figure();
                %subplot(nCriteria,nMeasures,su2ind(sizh,j,e));
                %plot(mRE,mPE,'-b',MRE,MPE,'-r',0:0.1:1,0:0.1:1,'--k')
                Training.mPR = mRE+j*mPE;
                Training.MPR = MRE+j*MPE;
                Test.mPR = mRT+j*mPT;
                Test.MPR = MRT+j*MPT;
                plot(mRE,mPE,'-b',MRE,MPE,'-r')
                %                 figure(hPR)
                hold on
                plot(mRT,mPT,'b+',MRT,MPT,'r+');%,0:1,0:1,'--k')
                legend boxoff
                legend('Training Set micro P-R','Training set macro P-R',...
                    'Test set micro P-R','Test set macro P-R');%,'BEP')
                plot(0:1,0:1,'--k')
                title(sprintf('%s optimized by %s',measure,criterion));
                fprintf('**Optimal training micro %s: %1.4f+j%1.4f\n',measure,mRE(i_opt),mPE(i_opt));
                fprintf('**Optimal testing micro %s: %1.4f+j%1.4f\n',measure,mRT,mPT);
                fprintf('**Optimal training macro %s: %1.4f+j%1.4f\n',measure,MRE(i_opt),MPE(i_opt));
                fprintf('**Optimal testing macro %s: %1.4f+j%1.4f\n',measure,MRT,MPT);
            case 'f1'
                measure='F1';
                Training.mF1 = mFE;
                Training.MF1 = MFE;
                Test.mF1 = mFT;
                Test.MF1 = MFT;
                %hF1 = figure();
                %subplot(nCriteria,nMeasures,su2ind(sizh,j,e));
                plot(hatKE.Phis,mFE,'-b',hatKE.Phis,MFE,'-r')
                hold on
                plot(optPhis(j),mFT,'b+',optPhis(j),MFT,'r+')
                title(sprintf('%s optimized by %s',measure,criterion));
                legend('Training Set micro F1','Training set macro F1',...
                    'Test set micro F1','Test set macro F')
                fprintf('**Optimal training micro %s: %1.4f\n',measure,Training.mF1(i_opt));
                fprintf('**Optimal testing micro %s: %1.4f\n',measure,Test.mF1);
                fprintf('**Optimal training macro %s: %1.4f\n',measure,Training.MF1(i_opt));
                fprintf('**Optimal testing macro %s: %1.4f\n',measure,Test.MF1);
            otherwise
                error('mlc:single_optimize_evaluate',...
                    'Unknown measure for evaluating MLC: %s',measures{e})
        end
    end%evaluate test
end%criterion = criteria
return