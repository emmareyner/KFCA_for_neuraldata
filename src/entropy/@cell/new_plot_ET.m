function [h]=plot_ET(nDHpxpy,n2MI,nVI,nvalues,varargin)
%[h]=plot_ET(nDHpxpy,n2MI,nVI,nvalues,varargin)
%
% A primitive to plot in the entropy triangle a a series of points given
% their [nDHpxpy,n2MI,nVI] coordinates. 
% 

% If a  value is provided for each point in [nvalues], then a plotbar is
% also drawn with the colorbar in the range to represent the values.
%
% If nvalues is empty, then the points are drawn isolated.
%
% The rest of the arguments are passed along to ternary.plotbar
%
% AUTHOR: FVA 01/2014

error(nargchk(4, 260, nargin));

%TODO: only print black dots if there is not a fourth argument (no
%colourbar)
%    ishold()

%% Check input values
if (~iscell(n2MI) || ~iscell(nVI))
    error('entropy:cell:plot_ET','Some coordinates are mats')
end
% if (iscell(n2MI)), n2MI = cell2mat(n2MI); end
% if (iscell(nVI)), nVI = cell2mat(nVI); end
% if (iscell(nvalues)) nvalues = cell2mat(nvalues); end
M = length(nDHpxpy);
if (M ~= length(n2MI) || (M ~= length(nVI))) 
    error('entropy:cell:plot_ET','Coordinates with dissimilar lengths')
end
% detect whether we are requesting plotbars or not.
if (isempty(nvalues))
    PLOTBAR = false;
else
    if ( ~iscell(nvalues) || (M ~= length(nvalues)))
        error('entropy:cell:plot_ET','value not array or dissimilar length')
    end
    PLOTBAR = true;
end
%    ishold()

if PLOTBAR
    for i=1:M
        plot_ET(nDHpxpy{i},n2MI{i},nVI{i},nvalues{i},varargin{:});
    end    
else
    for i=1:M
        plot_ET(nDHpxpy{i},n2MI{i},nVI{i},[],varargin{:});
    end
end
return
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
%    ishold()

%prevent the entropy triangle to be over bloated with dots
if (M > 100) 
    mainMsize = 3;
    if SPLIT; splitMsize = 2; end
else
    mainMsize = 7;
    if SPLIT; splitMsize = 4; end
end

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
   h=ternary.plot(nDHpxpy,n2MI,nVI,nvalues,varargin{:},'markersize',mainMsize);    
end
    
%title('Colour according to NIT');

