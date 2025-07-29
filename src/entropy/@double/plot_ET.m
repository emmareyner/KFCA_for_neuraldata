function [h]=plot_ET(nDHpxpy,n2MI,nVI,nvalues,varargin)
%[h]=plot_ET(nDHpxpy,n2MI,nVI,nvalues,varargin)
%[h]=plot_ET(nDHpxpy,n2MI,nVI,color,varargin)
%
% A primitive to plot in the entropy triangle a a series of points given
% their [nDHpxpy,n2MI,nVI] coordinates. 
% 
% If a  value is provided for each point in [nvalues], then a plotbar is
% also drawn with the colorbar in the range to represent the values.
%
% The rest of the arguments are passed along to ternary.plotbar
%
% AUTHOR: FVA 01/2014

error(nargchk(4, 260, nargin));

%TODO: only print black dots if there is not a fourth argument (no
%colourbar)
%    ishold()

%% Check input values
if (iscell(n2MI) || iscell(nVI))
    error('entropy:double:plot_ET','Some coordinates are cells')
end
% if (iscell(n2MI)), n2MI = cell2mat(n2MI); end
% if (iscell(nVI)), nVI = cell2mat(nVI); end
% if (iscell(nvalues)) nvalues = cell2mat(nvalues); end
M = length(nDHpxpy);%NUmber of values to plot!
if (M ~= length(n2MI) || (M ~= length(nVI))) 
    error('entropy:double:plot_ET','Coordinates with dissimilar lengths')
end
%whether to use plotbar or not:
% - if nvalues has the same dimensions as n2MI, use plotbar
% - if nvalues has triples (three columns), use the colors in them.
if (isempty(nvalues))%to draw isolated points    
    nvalues = [1 0 0]; %in red
end
[thisM numCols] = size(nvalues);
if (numCols == 3)%Looks like no plotbar
    PLOTBAR = false;
elseif (thisM == M)%looks like a plotbar with nvalues the values to plot
    PLOTBAR = true;
else
     error('entropy:double:plot_ET','Undefined plotting more: neither plotbar nor specified colors')
end

%% Define labels for the ternary plot
SPLIT=false;%FVA: experimental
colormap(jet)
% Set the ER view on plot
ternary.axes(10,'fraction');
%labs for the split plot: OLD STUFF
if SPLIT
    clabs = '$${H''}_{P_{X|Y}}, {H''}_{P_{Y|X}}$$';
    alabs = '$$\Delta \emph{{H''}}_{P_X}, \Delta \emph{{H''}}_{P_Y}$$';
    blabs = '$$\emph{{MI''}}_{P_{XY}}$$';
    ternary.label(alabs,blabs,clabs);
else%labels for the un-split plot
    clab = '$${VI''}_{P_{XY}}$$';
    alab = '$$\Delta \emph{H''}_{P_X \cdot P_Y}$$';
    blab = '$$2\times {MI''}_{P_{XY}}$$';
    ternary.label(alab,blab,clab);
end
%prevent the entropy triangle to be over bloated with dots
if (M > 100) 
    mainMsize = 3;
    if SPLIT; splitMsize = 2; end
else
    mainMsize = 7;
    if SPLIT; splitMsize = 4; end
end


% %% detect whether we are requesting plotbars or not.
% 
% if (isempty(nvalues))%to draw isolated points
%     %nvalues = [1 1 1]; %in black
%     nvalues = [1 0 0]; %in red
% end
% if (M == length(nvalues)) 
%     PLOTBAR = size(nvalues,2) == 1; 
%     PLOTBAR = xor(size(nvalues,2) == 1,size(nvalues,1)==1);
% else
%     if (size(nvalues,2) ~= 3)
%        error('entropy:double:plot_ET','nvalues of dissimilar length or not a color')
%     end
%     PLOTBAR = false;
% end

%% Generate the plotbar and plot
if PLOTBAR 
    if SPLIT
        hold on
        h=ternary.plotbar(nDHpx,n2MI,nVIx,nvalues,'markersize',splitMsize,'marker','x',varargin{:});
        hold on
        h=ternary.plotbar(nDHpy,n2MI,nVIy,nvalues,'markersize',splitMsize,'marker','o',varargin{:});
        hold off
    else
        h=ternary.plotbar(nDHpxpy,n2MI,nVI,nvalues,varargin{:},'markersize',mainMsize,'marker','d');
    end
else
    %Rotate the different types of markers with in the following order
    % recipe from: 
    % http://stackoverflow.com/questions/5210514/how-to-plot-multiple-lines-with-different-markers
    m = {'+','o','*','.','x','s','d','^','v','>','<','p','h'};
    m = repmat(m,1,ceil(M/length(m)));%This is a dirty hack: at least the color should change.
    m = m(1:M);
%    set(gca(), 'LineStyleOrder',m, 'ColorOrder',[0 0 0], 'NextPlot','replacechildren')
    % FVA: setting the colors too does not allow the LineStyleOrder
    % variation
    %set(gca(), 'LineStyleOrder',m, 'ColorOrder',[1 0 0; 0 0 1; 0 1 0], 'NextPlot','replacechildren')
    %set(gca(), 'LineStyleOrder',m, 'ColorOrder',[1 0 0], 'NextPlot','replacechildren')
    %set(gca(), 'LineStyleOrder',m,'ColorOrder',get(gca(),'Color'),'NextPlot','replacechildren')%Always starts on red!
    set(gca(), 'LineStyleOrder',m,'ColorOrder',nvalues,'NextPlot','replacechildren')%Always starts on red!
   %args = [{'markersize',mainMsize} varargin{:}];
   %FVA: the matrices should be printed one by one
   for i=1:M
       hold all
       varargin = [{'markersize',mainMsize} varargin{:}];
       h=ternary.plot(nDHpxpy(i),n2MI(i),nVI(i),varargin{:}); %'MarkerSize',mainMsize);  
   end
end
    
%title('Colour according to NIT');

