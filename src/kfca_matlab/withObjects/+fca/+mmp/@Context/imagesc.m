function h = imagesc(K, description)
% h = imagesc(K,description)
% A function to plot a heatmap of a virtual context and annotate it with
% the labels of the objects and attributes

if nargin < 2
    description = ['Context: ', K.Name];
end
figure
%map=colormap('gray');%for paper editions
map=colormap('hot');%for online editions
map=flipud(map);
colormap(map);
% h=imagesc(pm.mat);
h=imagesc(double(K.R));
colorbar;%add a simple colorbar
%BUG
xticks = find(K.iM); 
yticks = find(K.iG);
% set(gca,'YTick', [1:pm.nephones], 'XTick', [1:pm.nrphones], 'YTickLabel', pm.elabelset, 'XTickLabel', pm.rlabelset,  'XAxisLocation', 'top');
set(gca,'YTick', yticks, 'XTick', xticks, 'YTickLabel', K.G(yticks), 'XTickLabel', K.M(xticks),  'XAxisLocation', 'top');
% my_xticklabels(gca,[1:pm.nrphones], pm.rlabelset, 'Rotation',90, 'VerticalAlignment','middle', 'HorizontalAlignment','left','FontSize',14);
my_xticklabels(gca,xticks, K.M(xticks), 'Rotation',90, 'VerticalAlignment','middle', 'HorizontalAlignment','left','FontSize',14);
% my_yticklabels(gca,[1:pm.nephones], pm.elabelset, 'HorizontalAlignment','center', 'VerticalAlignment','middle','FontSize',14);
my_yticklabels(gca,yticks, K.G(yticks), 'HorizontalAlignment','center', 'VerticalAlignment','middle','FontSize',14);

posy=max(get(gca,'YLim'))+3;
posx=mean(get(gca,'XLim'));
%title(['Confusion matrix:', description],'FontSize',14,'FontWeight','bold','Position', [posx, posy]);
title(description,'FontSize',14,'FontWeight','bold','Position', [posx, posy]);
return%h

