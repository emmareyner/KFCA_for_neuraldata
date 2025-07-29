function [Kout]=coocurMatrix_analysis(datadir,labelsdir, matfilename, elabelsfilename, rlabelsfilename, outdirbase, maxplus, ignoreperfect, mask, description);

%INPUTS:
%

%datadir is the folder where the data reside: confusion matrices
%labelsdir is the folder wher the labels reside 
%matfilename is the file containing the confusion matrix (it is assumed to be .mat file)
%             Input matrices must be count matrices of the form: emitted X received (estimulus x response)
%elabelsfilename is the file containing the labels for the emitted symbols
%(assumed to be a .txt file)
%rlabelsfilename is the file containing the labels for the received symbols
%(assumed to be a .txt file)
%description char string describing the experiment
%step is the size of the step in the phi loop (actually,
%phistep=logit(step)) (default 0.0005)
%
%OUTPUTS:
%
%outdir: is the folder for the CVS descriptions of the structural
%lattices
%        the CVS files are named after their phi values
%K is the output context



%Check number of input args
error(nargchk(6, 10, nargin))
if nargin<10 description=''; end;


[datadir,'/',matfilename,'.mat']
%Load matrix
load([datadir,'/',matfilename,'.mat']);

%Create a struct to contain the matrix info (resembling phonmat class)
 % pm.mat has the underlying matrix.
 % pm.labels has the labels of the symbols involved.
 % pm.title has the name of this matrix
 % pm.symmetric specified whether the matrix is symmetric
 % pm.hasdiag specified whether the matrix has meaningful diagonal entries
 % pm.default -- don't worry about it.
 % pm.smallest. Any value below smallest in magnitude is assumed to be 0.
 % pm.dp is the number of decimal places to be used in displaying this object. %

pm.mat=eval(matfilename);
pm.title=description;
pm.symmetric =0;
pm.hasdiag=1;
pm.smallest=0;
pm.dp=0;

%Load labelsets
pm.elabelset=fca.apps.read_labels([labelsdir,elabelsfilename, '.txt']);
pm.rlabelset=fca.apps.read_labels([labelsdir,rlabelsfilename, '.txt']);
pm.nephones=length(pm.elabelset);
pm.nrphones=length(pm.rlabelset);


conf_mat=pm.mat;
conf_mat = log(conf_mat);
%[NMI,AMI,AVI,EMI,PAMI,PNMI]=anmi(conf_mat);
figure(1)
mat_sin_inf=conf_mat;
%pmi_mat_sin_inf(find(isinf(I)))=0;
mat_sin_inf(isinf(conf_mat))=0;%better to use logical indexing
sum(sum(mat_sin_inf))
plot(sort(mat_sin_inf(:)),cumsum(sort(mat_sin_inf(:))))



%Create context
size(conf_mat)
%K=mpfca_create_context(pm.elabelset, pm.rlabelset, conf_mat, matfilename);
K = fca.mmp.Context(pm.elabelset,pm.rlabelset,conf_mat,matfilename);

% FVA: the following is generating problems because of the visualization
% primitives. The next time you test, use a K with K.g ~= K.m and see what
% happens!
%
% figure(4)
% map=colormap('gray');
% map=flipud(map);
% colormap(map)
% R=get_virtual_incidence(K);
% if issparse(R)
%     R = double(R);
% end
% imagesc(R)
% set(gca,'YTick', [1:K.g], 'XTick', [1:K.m], 'YTickLabel', K.G, 'XTickLabel', K.R,  'XAxisLocation', 'top');
% my_xticklabels(gca,[1:K.m],  K.M, 'Rotation',90, 'VerticalAlignment','middle', 'HorizontalAlignment','left','FontSize',14);
% my_yticklabels(gca,[1:K.g],  K.G, 'HorizontalAlignment','center', 'VerticalAlignment','middle','FontSize',14);
% 
% posy=max(get(gca,'YLim'))+1;
% posx=mean(get(gca,'XLim'));
% title(['Confusion matrix:', description],'FontSize',14,'FontWeight','bold','Position',[posx, posy]);
auto=false;
fromPhi=-Inf;
toPhi=0;
samplePhis=true;
maxPhis=200;
options = fca.mmp.explore.build_phis(auto,fromPhi,toPhi,samplePhis,maxPhis)%Show it for logging purposes!
options.inv=~maxplus;
%Now create structural lattices
if ignoreperfect
    [Kout] = explore_in_phi_iperfect(K,outdirbase,mask);
else
    Kout = explore_in_phiv2(K,outdirbase,options);
end

%Make plots 
figure(2)
plot(Kout.Phis,Kout.nc)
title(['Number of concepts:', description],'FontSize',14,'FontWeight','bold');
xlabel(['\phi'])
ylabel('Number of concepts')


%Uses functions from phonmat: formatstring.m should be modified to present
%the string centered in the slot
fca.apps.display_mat(pm);
display(['Accuracy: ',num2str(sum(diag(pm.mat)/sum(sum(pm.mat))))])

fca.apps.latex_mat(pm,0)