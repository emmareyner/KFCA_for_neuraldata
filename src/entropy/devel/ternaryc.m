function [hd,hcb]=ternaryc(c1,c2,c3,d,symbol)
%FUNCTION H=TERNARYC(C1,C2,C3,D,SYMBOL) 
%
% It plots the four data vectors C1,C2,C3, 
% and D color-coded in a ternary plot. The optional parameter SYMBOL
% determines the symbol used in the scatter plot.
%
% The first three vectors define the position of a data value within the
% ternary diagram, and the fourth vector will be plotted as a coloured
% symbol according to its magnitude. The marker symbol can be optionally
% defined by the marker parameter. If then, note that the marker symbol
% must be enclosed in single quotes (e.g., 'o'). If no symbol is specified
% a dot will be used.
%
% h=ternaryc(c1,c2,c3);
%
% Calling the function with only the first three vectors, i.e.,
% results in a standard ternary plot. The data are plotted as a scatter
% plot in a ternary diagram with constant symbols (a blue diamond is the
% default value). To change the symbol (especially when plotting several
% data in one diagram) you can use the set command:
% set(h,'markerfacecolor','r','marker','+')
%
% FVA: 
% h=ternaryc(c1,c2,c3,d);
%
% The markers will be coloured according to the magitudes in [d] which is
% shown in an attached colorbar.
%
% h=ternaryc(c1,c2,c3,names);
% h=ternaryc(c1,c2,c3,ints);
%
% If the fourht parameter is an array of integers [ints] or strings [names]
% the colormap for the bar is [jet] and the integers or the names are 
% plotted in the color bar instead. 
%
% The ternary axis system must be created before using the terplot
% function. Axis label can be added using the terlabel function.
% The function returns two handles: hd can be used to modify the data
% points, and hcb is the handle of the colorbar.
%
% See also terplot, tersurf, terlabel, tercontour, and termain for a sample
% program showing the use of the ternary functions.
%
% Example:
%   close all;clear all
%   warning off MATLAB:griddata:DuplicateDataPoints
%   load limestone
%   % (The data file comes with the zip file).
%   figure
%   % Plot the ternary axis system
%   [h,hg,htick]=terplot;
%   % Plot the data
%   % First set the colormap (can't be done afterwards)
%   colormap(jet)
%   [hd,hcb]=ternaryc(A(:,1),A(:,2),A(:,3),A(:,4),'o');
%   %   or
%   [hd]=ternaryc(A(:,1),A(:,2),A(:,3));
%   %   for a constant value ternary plot.
%   % Add the labels
%   hlabels=terlabel('Limestone','Water','Air');
%
% Uli Theune, Geophysics, University of Alberta
% 2002 - 2005
%

% May 2005: added constant data plot option
error(nargchk(3, 5, nargin));
%CPM, FVA: Flags for printing tick labels in the color bar.
intc=false;%integer tick labels
stringc = false;%string tick labels

% Data normalization
if max(c1+c2+c3)>1
    c1=c1./(c1+c2+c3);
    c2=c2./(c1+c2+c3);
    c3=c3./(c1+c2+c3); %#ok<NASGU>
end
if nargin == 3
    % CPM: Constant data, set marker: no color bar on the side.
    marker = 1;
else
    %CPM: modifications for discrete values of d
    M=length(d);%%Number of confusions matrices in the array to be plotted.
    % FVA: if the length is zero, this is used to change the plotting
    % symbol
    if (M ~= 0)%%There are some points to draw
        marker = 0;
        if iscellstr(d)%the data are names 
            intc=true;
            lab = char(d);
            d=1:uint16(M);
        elseif (round(d)==d)%The data are integer
            intc=true;
            miv=min(d);
            mav=max(d);
            lab=char(M,4);
            %    Create the yticklabels
            ytl=linspace(miv,mav,M);
            for i=1:M
                B=sprintf('%-4.0f',ytl(i));
                lab(i,1:length(B))=B;
            end
        end
        miv=min(d);
        mav=max(d);
        %CPM: if all the values in d are equal the colormap created must have
        %at least one element. Otherwise it returns NaN.
        if (miv==mav), mav=2*miv; end
    end
    % If no marker specified use the default one
    if nargin>=4
        symbol='.';
    end
    % Get the current colormap
    map=colormap;
end
% Plot the points
hold on
hd=zeros(length(c1),1);%FVA: avoid growing array warning
for i=1:length(c1)    
    x=0.5-c1(i)*cos(pi/3)+c2(i)/2;
    y=0.866-c1(i)*sin(pi/3)-c2(i)*cot(pi/6)/2;
    if marker == 1
        hd(i)=plot(x,y,'db','markerfacecolor','b');
    else
        if (intc || stringc) 
            in=1+round((d(i)-miv)*(length(map))/(mav-miv+1));
        else
            in=1+round((d(i)-miv)*(length(map))/(mav-miv));
        end
        if in==0;in=1;end
        if in > length(map);in=length(map);end
        hd(i)=plot(x,y,symbol,'color',map(in,:),'markerfacecolor',map(in,:));
    end
end
hold off
axis image
% % Re-format the colorbar
% 
numcolors=length(c1);
if marker == 0
    
    %hcb = colorbar('YTick',[1+0.5*(numcolors-1)/numcolors:(numcolors-1)/numcolors:numcolors],'YTickLabel',int2str([1:numcolors]'), 'YLim', [1 numcolors]);
    %set(hcb,'ylim',[1 length(map)]);
    hcb=colorbar;
    if (intc || stringc)
        caxis([1 numcolors]);
        yal=[1+0.5*(numcolors-1)/numcolors:(numcolors-1)/numcolors:numcolors];
        set(hcb,'YTick',yal);
        %print the actual labels lab
        set(hcb,'YTickLabel',lab,'fontsize',9,'ycolor','k','xcolor','k','YLim', [1 numcolors]);
        %colorbar('YTick',[1+0.5*(numcolors-1)/numcolors:(numcolors-1)/numcolors:numcolors],'YTickLabel',s, 'YLim', [1 numcolors]);
        
    else
        nticks=10;
        caxis([0 1]);
        yal=linspace(0,1,nticks);
        set(hcb,'YTick',yal);
        % Create the yticklabels
        ytl=linspace(miv,mav,nticks);
        s=char(nticks,4);
        for i=1:nticks
            if abs(min(log10(abs(ytl)))) <= 3
                B=sprintf('%-4.3f',ytl(i));
            else
                B=sprintf('%-4.2E',ytl(i));
            end
            s(i,1:length(B))=B;
        end
        set(hcb,'YTickLabel',s,'fontsize',9,'ycolor','k','xcolor','k','YLim', [0 1]);
        %colorbar('YTick',[1+0.5*(numcolors-1)/numcolors:(numcolors-1)/numcolors:numcolors],'YTickLabel',s, 'YLim', [1 numcolors]);
    end
    
    
    
end
%grid on
%set(get(h,'title'),'string',string,'fontweight','bold')
return%[hd,hcb]

   
