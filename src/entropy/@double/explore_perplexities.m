function [h]=explore_perplexities(PP_Px,PP_Py,PP_Px_y,PP_Py_x,maxPP_Px,maxPP_Py,varargin)
%  [h]=explore_perplexities(PP_Px,PP_Py,PP_Px_y,PP_Py_x,maxPP_Px, maxPP_Py,varargin)
%
% a function to to draw perplexities vs each other.
% Either the inputs are perplexities or coindexed vectors of perplexities. In
% the first case, explore_perplexities(PP_Px,PP_Py,PP_Px_y,PP_Py_x,maxPP_Px,maxPP_Py,h,c,...)
% adds to an existing figure h, by plotting a '*' in color 'c'.
% If the entropies are matrices and no h is supplied, it generates a new figure
% plotting in 3d H_Px vs H_Py vs EMI_Pxy normalized wrt to H_Pxy.
% If an h is supplied, then it is added to the present graph.
%
%Options controlling behaviour:
% - two types of plots: VI vs. H_Px|y vs. H_Py|x  ('3D', default) or VI vs. H_Px ('2D') 
%- Two types of exploration:  normalized by H_Pxy or not. Default is
%unnormalized. Set by putting 'normalize' into options
%- Two types of representation, log or linear: default is linear. Set by
%putting 'logarithmic' into options.
%- Two types of plot building: incremental on true means, "add to preexisting
%plot". Set by putting 'incremental' into options
% - Two types of domain: percent ('percent') and bits('bit') (one exponential version of the
% other)
norm = false;
log = false;%default is linear
incremental = false;
threeDview = true;
bit = true;
c = 'r';

error(nargchk(6,10,nargin));
%Check that we have the same number of points in all entropies.
sxy = size(PP_Px_y);sx = size(PP_Px); sy = size(PP_Py); syx = size(PP_Py_x);
smx = size(maxPP_Px);smy = size(maxPP_Py);

if any(sxy ~= sx | sxy ~= sy |sxy ~= syx | sxy~=smx |sxy  ~= smy)
    error('Double:explore_perplexities','different dimensions in input entropies');
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
                case 'log'
                    log = true;
                case 'linear'
                    log = false;
                case '2D'
                    threeDview = false;
                case '3D'
                    threeDview = true;
                otherwise
                    warning('double:explore_entropies','unrecognized optional argument %s: read as LineSpec',thisopt);
                    c=thisopt;
            end
        end
    end
end

%Decide whether to add or start afresh.
if incremental
    h = figure(varargin{1});
else
    h=figure();%Get a new, fresh figure
    grid on
end

% Max perplexities with a *
% perplexities with a .
% residual perplexities with a o
Hmax = maxPP_Px * maxPP_Py;
if norm
    Hnorm = Hmax;
    uniti = [0 1];%unitary interval
else%No normalization
    Hnorm = 1;
    uniti = [0 Hmax];%unitary interval
end
if threeDview
    camera = [1 3 1];% a perspective that focuses in the ZY plane
    axis([uniti uniti uniti ]);
    camera = Hmax * camera;%Pull the camera away
    view(camera);
    plot3(Hmax, PP_Px * PP_Py, PP_Px_y * PP_Py_x,':o');
else %Plot in 2D normalized or unnormalized versions of entropy.
    if norm
        plot(PP_Px/maxPP_Px,PP_Py/maxPP_Py,':*',PP_Px_y/maxPP_Px,PP_Py_x/maxPP_Py,':o');
    else%unormalized
        %    for i = 1:sxy
        plot(PP_Px,PP_Py,':*',PP_Px_y,PP_Py_x,':o',maxPP_Px,maxPP_Py,':.');
        %    end
    end
end

return%h

