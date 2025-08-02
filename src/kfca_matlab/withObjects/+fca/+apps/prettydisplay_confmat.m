function prettydisplay_confmat(matrix, etags, rtags, description);

%INPUTS:
%


%labelsdir is the folder wher the labels reside 
%matrix contains the confusion matrix 
%             Input matrices must be count matrices of the form: emitted X received (estimulus x response)
%etags is a cell array containing the labels for the emitted symbols
%(assumed to be a .txt file)
%rtags is a cell array containing the labels for the received symbols
%(assumed to be a .txt file)
%description char string describing the experiment


%Check number of input args
error(nargchk(3, 4, nargin))
if nargin<4 description=''; end;



%Create a struct to contain the matrix info (resembling phonmat class)
 % pm.mat has the underlying matrix.
 % pm.labels has the labels of the symbols involved.
 % pm.title has the name of this matrix
 % pm.symmetric specified whether the matrix is symmetric
 % pm.hasdiag specified whether the matrix has meaningful diagonal entries
 % pm.default -- don't worry about it.
 % pm.smallest. Any value below smallest in magnitude is assumed to be 0.
 % pm.dp is the number of decimal places to be used in displaying this object. %

pm.mat=matrix
pm.title=description;
pm.symmetric =0;
pm.hasdiag=1;
pm.smallest=0;
pm.dp=0;

%Load labelsets
%pm.elabelset=fca.apps.read_labels([labelsdir,elabelsfilename, '.txt']);
%pm.rlabelset=fca.apps.read_labels([labelsdir,rlabelsfilename, '.txt']);
pm.elabelset=etags;
pm.rlabelset=rtags;

pm.nephones=length(pm.elabelset);
pm.nrphones=length(pm.rlabelset);


conf_mat=pm.mat;

%figure
map=colormap('gray');
map=flipud(map);
colormap(map)

imagesc(pm.mat)
set(gca,'YTick', [1:pm.nephones], 'XTick', [1:pm.nrphones], 'YTickLabel', pm.elabelset, 'XTickLabel', pm.rlabelset,  'XAxisLocation', 'top');
[hx,hy] = fca.apps.format_ticks(gca, pm.rlabelset, pm.elabelset, [], [], 90, 0,0.05,'FontSize',12,'FontWeight','Normal','HorizontalAlignment','left', 'VerticalAlignment','middle');


posy=max(get(gca,'YLim'))+1.0;
posx=mean(get(gca,'XLim'));
title(['', description],'FontSize',11,'FontWeight','Normal','FontAngle','Italic','Position',[posx, posy]);


%Uses functions from phonmat: formatstring.m should be modified to present
%the string centered in the slot
fca.apps.display_mat(pm);

fca.apps.latex_mat(pm,0)