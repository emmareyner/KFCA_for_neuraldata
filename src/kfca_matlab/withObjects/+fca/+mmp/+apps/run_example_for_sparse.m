function [Kout]=run_example(datadir,labelsdir, matfilename, elabelsfilename, rlabelsfilename, outdirbase, maxplus, ignoreperfect, mask, description);

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


[datadir,matfilename,'.mat']
%Load matrix
load([datadir,matfilename,'.mat']);

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

%Output 
%outdir=[outdirbase, matfilename,'/'];
%Now this is done by explore_in_phi
% suc=rmdir(outdir,'s');
% mkdir(outdir)

%Matrix conditioning
% ncounts=sum(sum(pm.mat))
% priors=sum(pm.mat,2)/ncounts;
% marg_post= sum (pm.mat, 1)/ncounts;
% conf_mat=pm.mat/ncounts;
% 
% conf_mat=pm.mat./(priors* ones(1,pm.nrphones));
% %conf_mat=conf_mat./(priors* marg_post);
% i=find(priors==0)
% j=find(marg_post==0)
% conf_mat(find(isnan(conf_mat)))=0;
% if (length(i)>0) & (length(j)>0)
%     ind=(j-1)*pm.nephones+i;
%     conf_mat(ind)=Inf;
% end

conf_mat=pm.mat;
%This is a different pmi.m
%[pmi_mat, wpmi_mat, I, pp_mat,nwpmi, npmi] = pmi(conf_mat);
if ~issparse(conf_mat)
    
    [I,Pxy] = pmi(uint16(conf_mat));
    %[NMI,AMI,AVI,EMI,PAMI,PNMI]=anmi(conf_mat);
    figure(1)
    pmi_mat_sin_inf=I;
    pmi_mat_sin_inf(find(isinf(I)))=0;
    sum(sum(pmi_mat_sin_inf))
    plot(sort(pmi_mat_sin_inf(:)),cumsum(sort(pmi_mat_sin_inf(:))))
    conf_mat=I;
    %conf_mat=PAMI-AMI;
    %maxHxy=log2(pm.nephones*pm.nrphones);
    %conf_mat=npmi
    %conf_mat=npmi-maxHxy
else
     [I,Pxy] = pmi(uint16(full(conf_mat)));
    %[NMI,AMI,AVI,EMI,PAMI,PNMI]=anmi(conf_mat);
    figure(1)
    pmi_mat_sin_inf=I;
    pmi_mat_sin_inf(find(isinf(I)))=0;
    sum(sum(pmi_mat_sin_inf))
    plot(sort(pmi_mat_sin_inf(:)),cumsum(sort(pmi_mat_sin_inf(:))))
    conf_mat=mmp.x.Sparse(I);
end


%Create context
size(conf_mat)
%K=mpfca_create_context(pm.elabelset, pm.rlabelset, conf_mat, matfilename);
K = fca.mmp.Context(pm.elabelset,pm.rlabelset,conf_mat,matfilename);

figure(4)
map=colormap('gray');
map=flipud(map);
colormap(map)
imagesc(double(K.R))
%set(gca,'YTick', [1:K.g], 'XTick', [1:K.m], 'YTickLabel', K.G, 'XTickLabel', double(K.R),  'XAxisLocation', 'top');
%my_xticklabels(gca,[1:K.g],  K.M, 'Rotation',90, 'VerticalAlignment','middle', 'HorizontalAlignment','left','FontSize',14);
%my_yticklabels(gca,[1:K.m],  K.G, 'HorizontalAlignment','center', 'VerticalAlignment','middle','FontSize',14);

posy=max(get(gca,'YLim'))+1;
posx=mean(get(gca,'XLim'));
title(['Confusion matrix:', description],'FontSize',14,'FontWeight','bold','Position',[posx, posy]);

if maxplus
    inv=0;
else
    inv=1;
end
%Now create structural lattices
if ignoreperfect
    [Kout] = explore_in_phi_iperfect(K,outdirbase,mask);
else
    Kout = explore_in_phiv2(K,outdirbase,inv);
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