function [h,DeltaH_Pxy,twoMI,VI,Hmax]=explore_entropies(H_Ux,H_Uy,H_Pxy,H_Px,H_Py,EMI_Pxy,varargin)
%  [h,DeltaH_Pxy,twoAMI,VI,HMax,H_Uxy]=explore_entropies(H_Ux,H_Uy,H_Pxy,H_Px,H_Py,EMI_Pxy, options)
%
% a function to to draw  entropies H_UxyH_Pxy,H_Px,H_Py,EMI_Pxy vs each other.
% Either the inputs are entropies or coindexed matrices of entropies. In
% the first case, explore_entropies(Pxy,H_Pxy,H_Px,H_Py,EMI_Pxy,h,c,...)
% adds to an existing figure h, by plotting a '*' in color 'c'.
% If the entropies are matrices and no h is supplied, it generates a new figure
% plotting in 3d H_Px vs H_Py vs EMI_Pxy normalized wrt to H_Pxy.
% If an h is supplied, then the plot is added to the existing graph.
%
% It also returns the constrained variables in the 2-simplex:
% - DeltaH_Pxy, the decrement in entropy from $U_X \cdot U_Y$ to $P_X \cdot P_Y$
% - VI, the variation of information.
% - twoAMI, double the average mutual information.
% - H_Uxy, the maximum joint entropy.

%Options controlling behaviour:
% - two types of plots: 2-simplex ('simplex', default) vs. entropy triangle ('triangle')
% - two types of dimensions: VI vs. H_Px|y vs. H_Py|x  ('3D', default) or VI vs. H_Px ('2D') 
%- Two types of exploration:  normalized or not. Default is
% normalized. Control by putting 'normalized|unnormalized' into options
%- Two types of representation, log or linear: default is linear. Set by
%putting 'logarithmic' into options.
%- Two types of plot building: incremental on true means, "add to preexisting
%plot". Set by putting 'incremental' into options
% - Two types of domain: percent ('percent') and bits('bit') (one exponential version of the
% other)
% If the option 'split' is passed, the Marker type is set to 'x' for input
% variable entropies and 'o' for output variable entropies, so only line
% and color specifications will be used from those supplied.
norm = true;%use normalized plotting
%log = false;%default is linear
incremental = false;
%threeDview = true;
etriangle = false;
msize = 12;%markersize
c = ':o';%Default line plot is dotted in circles
IEEE = true; %To visualize in IEEE form
tags=false;%WHETHER TO PRINT SOME TAGS ASSOCIATED TO THE EDGES OF THE TRIANGLE
split = false;%%% Split true means plot the input and output entropies splitted

%V 74: disposed of plain 2-dimensional plots. Only the simplex in 3D space
%and the de Finetti diagram are plotted.

%Argument checking
error(nargchk(6,10,nargin));

%Check that we have the same number of points in all entropies.
sxy = size(H_Pxy);sx = size(H_Px); sy = size(H_Py); sM = size(EMI_Pxy);
if any(sxy ~= sx | sxy ~= sy | sxy ~= sM)
    error('Double:explore_entropies','different dimensions in input entropies');
end

%process arguments
nargs = length(varargin);
if nargs > 0
    if isa(varargin{1},'double')
        incremental = true;
        %c = varargin{2};%This is potentially dangerous...
%         if ~ischar(varargin{2})
%             error('Double:explore_entropies','Color missing from options');
%         end
        options = 2:nargs;
    else
        options = 1:nargs;
    end
    options = varargin(options);%Select options left
    charoptions = cellfun(@ischar,options);
    if any(charoptions);
        for o = find(charoptions)
            thisopt = cell2mat(options(o));
            switch thisopt
                case 'normalized'
                    norm=true;
                case 'unnormalized'
                    norm= false;
                case 'incremental'
                    incremental = true;
%                 case 'log'
%                     log = true;
%                 case 'linear'
%                     log = false;
%                 case '2D'
%                     threeDview = false;
                case {'3D','simplex'}
                    %threeDview = true;
                    etriangle = false;
                case {'tags'}
                    tags=true;
                case 'triangle'
                    %threeDview = true;
                    etriangle = true;
                case 'split'
                    split = true;
                    %etriangle = true;
                otherwise
                    warning('double:explore_entropies','unrecognized optional argument %s: read as LineSpec',thisopt);
                    c=thisopt;
            end
        end
    end
end

%Decide whether to add or start afresh.
if incremental
    h = figure(varargin{1});%invoke supplied axes
    hold on
else
    h=figure();%Get a new, fresh figure
end

%Obtain the coordinates
Hmax = H_Ux + H_Uy;%maximum entropy of size n x p

%Calculate unnormalized entropic coordinates
DeltaH_Pxy = (Hmax - H_Px - H_Py);
twoMI = (2*EMI_Pxy);
VI = (H_Pxy - EMI_Pxy);

%This only plots the overall balance equation
if norm
    Hnorm = Hmax;
    DeltaH_Pxy = DeltaH_Pxy./Hnorm;
    twoMI = twoMI./Hnorm;
    VI = VI./Hnorm;
    Hmax = Hmax./Hnorm;
% else%No normalization
%     Hnorm = ones(
%     Hnorm = 1;
end

%Now plot the actual data
if etriangle%plot the de Finetti diagram, entails normalization
    %In any case, plot the average value
    ternary.plot(DeltaH_Pxy,twoMI,VI,c,'MarkerSize',msize);
    if split %Split, draw in separate point the X and Y entropy balances
        hold on
        DeltaH_Px = H_Ux - H_Px;
        DeltaH_Py = H_Uy - H_Py;
        VI_X= H_Px - EMI_Pxy;
        VI_Y = H_Py - EMI_Pxy;
        ternary.plot(DeltaH_Px,EMI_Pxy,VI_X,c,'Marker','x','MarkerSize',msize);%input entropies
        hold on
        ternary.plot(DeltaH_Py,EMI_Pxy,VI_Y,c,'Marker','o','MarkerSize',msize);%Output entropies
        hold on
    end
    %hold on
    if ~incremental
        if norm
            clab = '$$\emph{{VI}''}_{P_{XY}}$$';
            alab = '$$\Delta \emph{{H''}}_{P_X \cdot P_Y}$$';
            blab = '$$2\times \emph{{MI}''}_{P_{XY}}$$';
        else
            clab = '$${VI}_{P_{XY}}$$';
            alab = '$$\Delta {H}_{P_X \cdot P_Y}}$$';
            blab = '$$2\times {MI}_{P_{XY}}$$';
        end
        ternary.label(alab,blab,clab);
    end
else%plot 3D diagram
    hold on
    if ~incremental
        simplexcolor = 'k';
        simplexline = '-';
        grid on%ON three D we want to see the axes
        camera = [1 3 1];% a perspective that focuses in the ZY plane
        %camera = [1 1 1];% a perspective that resembles the triangle with depth
        zeroi=[0 0];%zero interval
        if norm
            maxHmax = 1;
            %uniti = [0 1];%unitary interval
            ylab = 'Norm. Entropy decrement';
            xlab = 'Norm. Variation of information';
            zlab = 'Norm 2\times Mutual Information';
        else%No normalization, might include points with differing Hmax!!
            %uniti = [0 Hmax];%unitary interval
            maxHmax = max(Hmax);
            ylab = 'Entropy decrement';
            xlab = 'Variation of information';
            zlab = '2\times Mutual Information';
        end%~norm
        uniti = [0 1];%representation interval
        xlabel(xlab,'FontSize',10,'Rotation',5);%reduction in uniformity needs a +5 deg tilt, positive is counterclockwise, as customary
        zlabel(zlab,'FontSize',10);%Mutual information
        ylabel(ylab,'FontSize',10,'Rotation',-40);%variation of information needs a -40 deg tilt
        %         % Delta H_Pxy, vs. MI vs. H_Pxy =
        itinu = fliplr(uniti);
        %Set the camera direction
        axis(maxHmax * [uniti uniti uniti ]);
        camera = maxHmax * camera;%Pull the camera away
        view(camera);
        %For the etriangle projection, take away all information and put
        %tags in corners
        %paint the normalized 3 simplex:
        plot3(uniti,itinu,zeroi,simplexline,'Color',simplexcolor);%In the XY plane
        plot3(itinu,zeroi,uniti,simplexline,'Color',simplexcolor);%In the XZ plane
        plot3(zeroi,uniti,itinu,simplexline,'Color',simplexcolor);%inf the YZ plane
    end
    plot3(VI, DeltaH_Pxy, twoMI,c,'MarkerSize',10);
end
return%h, coordinates
