function imagesc(pm, description)


figure
map=colormap('gray');
map=flipud(map);
colormap(map)
imagesc(pm.mat)
set(gca,'YTick', [1:pm.nephones], 'XTick', [1:pm.nrphones], 'YTickLabel', pm.elabelset, 'XTickLabel', pm.rlabelset,  'XAxisLocation', 'top');
my_xticklabels(gca,[1:pm.nrphones], pm.rlabelset, 'Rotation',90, 'VerticalAlignment','middle', 'HorizontalAlignment','left','FontSize',14);
my_yticklabels(gca,[1:pm.nephones], pm.elabelset, 'HorizontalAlignment','center', 'VerticalAlignment','middle','FontSize',14);

posy=max(get(gca,'YLim'))+3;
posx=mean(get(gca,'XLim'));
title(['Confusion matrix:', description],'FontSize',14,'FontWeight','bold','Position',[posx, posy]);

