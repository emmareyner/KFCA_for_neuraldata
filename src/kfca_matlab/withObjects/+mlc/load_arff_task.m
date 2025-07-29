function [task] = load_arff_task(intask)
% function [task] = load_arff_task(intask)
%
% a function to load a MLC task in ARFF (weka) format.
%
% [intask] is a structure with
% task.name
% task.nfeatures
% task.nlabels
%
% Returns an enriched description of the data in [task]
% task.trainName
% task.testName
% task.nTrainInstances
% task.nTestInstances 
% task.I_D_E: (nTrainingInstances x nfeatures) training vectors
% task.K_R_E: context of (nTrainingInstances x nlabels) training decisions
% task.I_D_T: (nTestInstances x nfeatures) training vectors
% task.K_R_T: context of (nTestInstances x nlabels) training decisions

error(nargchk(1, 1, nargin));

datafile = sprintf('%s-data',intask.name);
fprintf('*Trying to load %s data in matlab form...',datafile)
fprintf('Done!\n');
try
    load(datafile,'task')
catch exception %#ok<NASGU>
    warning('mlc:load_arff_task','loading task data from scratch!');
    %build names for files
    task = intask;
    task.trainName = sprintf('%s-train',task.name);
    task.testName = sprintf('%s-test',task.name);
    arfftrainName = sprintf('%s.arff',task.trainName);
    arfftestName = sprintf('%s.arff',task.testName);


%% create Weka object for training data
WekaObjTrain = loadARFF(arfftrainName);
[edata,featureNames] =...%,targetNDX,stringVals,relationName] =...
     weka2matlab(WekaObjTrain,[]);
task.nTrainInstances = size(edata, 1);

% The arff format just conflates both types of labels:
M = featureNames(task.nfeatures+(1:task.nlabels));%Attribute names for relevance contexts
task.featureNames = featureNames(1:task.nfeatures);
%objects and attributes for training and testing
GE = cellfun(@num2str,num2cell(1:task.nTrainInstances), 'UniformOutput',false);

%the number of features and class labels can be seen from task.featureNames                                            
task.I_D_E = (edata(:,1:task.nfeatures));       % Parameterization data, features
% By the nature of the multilabel task, relevance is sparse!
R_E = logical(sparse(edata(:,task.nfeatures+(1:task.nlabels))));%Real training relevance
% caveat: sometimes is will be better just to take log of this matrix!
task.K_R_E = fca.Context(GE,M,R_E,task.trainName);%training relevance context
clear edata
task.K_R_E.mat2csv('./decisions')

% %%% SO FAR %%%%
% WekaObjTrain = loadARFF('yeast-train.arff');
% [mdata,task.featureNames,targetNDX,stringVals,relationName] =...
%      weka2matlab(WekaObjTrain,{});
% %the number of features and class labels can be seen from task.featureNames                                            
% I_D_E = cell2mat(edata(:,1:103));       % Parameterization data, features
% R_E = logical(cellfun(@str2num, edata(:,104:end)));%Real training relevance
%% create Weka object for test data
WekaObjTest = loadARFF(arfftestName);
[tdata] =...%,featureNames,targetNDX,stringVals,relationName] =...
      weka2matlab(WekaObjTest,[]);
task.nTestInstances = size(tdata, 1); 
GT = cellfun(@num2str,num2cell(1:task.nTestInstances), 'UniformOutput',false);

%the number of features and class labels can be seen from task.featureNames                                            
task.I_D_T = tdata(:,1:task.nfeatures);       % Parameterization data, features
% By the nature of the multilabel task, relevance is sparse!
R_T = logical(sparse(tdata(:,task.nfeatures+(1:task.nlabels))));%Real test relevance
task.K_R_T = fca.Context(GT,M,R_T,task.testName);%testing relevance context
clear tdata
task.K_R_T.mat2csv('./decisions')
% WekaObjTest = loadARFF('yeast-test.arff');
% [mdata,task.featureNames,targetNDX,stringVals,relationName] =...
%       weka2matlab(WekaObjTest,{});
% %the number of features and class labels can be seen from task.featureNames                                            
% I_D_T = cell2mat(mdata(:,1:103));       % Parameterization data, features
% R_T = logical(cellfun(@str2num, mdata(:,104:end)));%Real test relevance
% 
% %TODO: Check parameters of data, like similar dimensions!

%save all task data
save(datafile,'task')
% save(datafile,...
%     task,...
%     task.trainName,task.testName,...
%     nfeatures,nlabels,task.nTrainInstances,task.nTestInstances,...
%     labelNames,task.featureNames,...
%     K_R_E,K_R_T)
end
