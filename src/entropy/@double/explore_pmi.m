function [Ixy, Pxy, MI, Hxy,Hxymax, WPI, h] = explore_pmi(rawcounts,varargin)
% function [Ixy, Pxy, MI, Hxy,Hxymax,WPI,h] =explore_pmi(rawcounts,h,rows,row,optionlist)
% function [Ixy, Pxy, MI, Hxy,Hxymax,WPI,h] =explore_pmi(rawcounts,optionlist)
%
% A function to obtain some information theoretic measures about a count
% matrix. For reasons of simplicity, rawcounts is never tested for natural
% numbers. It also DRAWS a colormap of the rawcounts, plots the pointwise
% mutual information histogram and the cumulative density for such
% histogram with a reference to where the normalized average mutual
% information is.
%
% Inputs:
% - rawcounts, a count matrix
% - h is a matrix handle for the picture being displayed
% - rows, the number of rows to plot in h.
% - row is the row where the next analysis will appear
% - optionlist is a list with {('normalize'|'normax'),'debug'}
%
%Outputs
% 
% - Ixy is the Pointwise Mutual Information
% - Pxy is the estimate of the joint probability 
% - MI is the expected mutual information,
% - Hxy is the joint entropy of distribution Pxy
% - Hxymax is the maximum joint entropy for a distribution of the same
% dimensions as Pxy
%
%  Authors: FVA, CPM 2009-2014


%% Todo convert argument passing into a varagin list and process.
%%context of analysis
normalize = false;
normax = false;
debug= false;
newplot = true;
%error(nargchk(1,3,nargin));
rows = 1;
row = 1;
if nargin > 1% h is in there
    h=varargin{1};
    if ischar(h)%h is in fact an option
        %varargin = [h varargin];
        newplot = true;
    else%h was actually a handle...
        newplot = false;
        if length(varargin) > 2%Then pop rows, row
            rows = varargin{2};
            row = varargin{3};
            varargin=varargin(4:end);
        else
            error('Double:explore_pmi','unknown calling pattern');
        end
    end
    %Now process the options
    if ~isempty(varargin)
        if all(logical((cellfun(@ischar, varargin))))
            for arg = 1:length(varargin)
                switch varargin{arg}
                    case 'normalize'
                        if normax
                            error('Double:explore_pmi','only one of normalize, normax allowed');
                        else
                            normalize = true;
                        end
                    case 'normax'
                        if normalize
                            error('Double:explore_pmi','only one of normalize, normax allowed');
                        else
                            normax = true;
                        end
                    case 'debug'
                        debug = true;
                    otherwise
                        error('Double:explor_pmi','unknown option %s', varargin(arg));
                end%switch varargin
            end%for arg
        else
            error('Double:explore_pmi','non char option in varargin');
        end
    end
else
   error(nargchk(1,2,nargin));
end

%Now checkout some information
%if (nargout > 4) || normax
    % 1.2 Calculate the max joint entropy
    Hxymax = log2(prod(size(rawcounts))); %#ok<PSIZE>
%end

%% explore the distribution of the pointwise mutual information
if (nargout > 5) || normalize%obtain the PIM and the MLE estimate of P(x,y), the MI and the joint entropy and WPIs
    [Ixy,Pxy,MI,Hxy,WPI] = pmi(rawcounts);
else
    [Ixy,Pxy,MI,Hxy] = pmi(rawcounts);
end
% if (nargout > 3) || normalize
%     [Ixy,Pxy,MI,Hxy] = pmi(rawcounts);
% else
%     [Ixy,Pxy,MI,Hxy] = pmi(rawcounts);%obtain the PIM and the MLE estimate of P(x,y), the MI and the joint entropy
% end

% nulls = sparse(Pxy == 0);
% % 1. Calculate the joint entropy
% Hxy = Pxy .* log2(Pxy);
% Hxy(nulls) = 0;
% Hxy = -sum(sum(Hxy));
if normalize
    %normalize PMI by the joint entropy
    Ixy = Ixy - Hxy;
    MI = MI - Hxy;
elseif normax
    %normalize PMI by the maximum joint entropy
    Ixy = Ixy - Hxymax;
    MI = MI - Hxymax;    
end

%% Do the drawings
%1. heatmap, histogram for Ixy and cumulative density function for Ixy
if newplot
    h = figure();
    row = 1;%This is the first row in the plot
else%add to old plot
    %Get how many plots
    %subplot(h);%select h as the figure
    %axes(h);
    %go to the next plotting line
    hold on;%write on top of previous plot
end
cols=3;%FVA: change this if another plot is needed!
base = cols*(row-1);
subplot(rows,cols,base+1)
colormap('hot')
imagesc(Ixy);%heatmap %Segmented digits is attached
if row==1, title('I(x,y) pointwise mutual information'); end
%hold on

%% Calculate the expectation of the PMI, and, possibly,
% MI = Pxy.*Ixy;%weighted PMI
% MI(nulls)=0;
% % Hence the average mutual information MI is:
% MI = sum(sum(MI));%Average mutual information
if debug
    display(Ixy > MI);%Should resemble a diagonal matrix
end
if ~normalize
    % Now we obtain the variance
    CIxy = (Ixy-MI) .^2;%Squared centered
    CIxy(Pxy==0)=0;
    s2 = sum(sum(Pxy .* CIxy)); %work out the variance
    if debug
        display(Ixy > MI - sqrt(s2));%average MI minus a deviation
    end
end

%% Plot histogram of PMI or NPMI. 
% CAVEAT: Only plots finite values... -Inf values should wait
centered_histogram = false;
centered_histogram = true;
subplot(rows,cols,base+2)
colormap('jet')
finIxy =  Ixy(~isinf(Ixy));%ONLY ACCEPTS FINITE VALUES!
%finIxy = finIxy(:);
if centered_histogram
%    finIxy = Ixy(:);
    [n,xout] = hist(finIxy,25);%25 bins adequate?
else
    r = range(finIxy); 
    finxout = min(finIxy):r/22:max(finIxy);
    xout = [-Inf finxout Inf];
    [n] = histc(Ixy(:),xout);
end
bar(xout,n);%plot and get handle, -Inf bar is missing!
if row==1, title('I(x,y) histogram'); end
%set(gca,'xlim',[min(finI),max(finI)])

%% Plot the cumulative density function F(I)
%f = figure();
subplot(rows,cols,base+3)
plot(xout,cumsum(n)/sum(n));
if row==1, title('Cumulative density for I(x,y)'); end
hold all
%plot the average/expectation MI
threshold = zeros(1,11);
threshold(:)=MI;
plot(threshold,0.0:0.1:1)
if normalize
    text(MI,0.2,'\leftarrow MI-H_{xy}')
elseif normax
    text(MI,0.2,'\leftarrow MI-H_{xy}^max')
else
    text(MI,0.2,'\leftarrow MI')
% end
% %keep this figure
% if ~normalize
    hold all
%     %plot the expectation minus a standard deviation
%     threshold(:)=MI - sqrt(s2);
%     plot(threshold,0.0:0.1:1)
%     text(MI - sqrt(s2),0.4,'\leftarrow E\{I\}-\sigma')
%     hold on
    % plot the joint entropy
    threshold(:)=Hxy;
    plot(threshold,0.0:0.1:1)
    text(Hxy,0.4,'\leftarrow H_{xy}')
    %axis([min(finI),max(finI),0,10])
    %plot the maximum joint entropy
    hold all
    threshold(:)=Hxymax;
    plot(threshold,0.0:0.1:1)
    text(Hxymax,0.6,'\leftarrow H_{max}')
end

return%Ixy,Pxy,MI,Hxy,Hxymax
