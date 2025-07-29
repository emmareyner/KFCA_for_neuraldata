function [muXY,nx_y,my_x,nx,my,nmuXY] = perplexities2(n2MI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy)
% function [muXY,nx_y,my_x,nx,my,nmuXY] = perplexities2(n2MI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy)
%
% a function to calculate and explore all possible perplexities given the
% normalized entropy values of a bivariate probability distribution, as
% obtained from primitive [entropies]
% 
% To work out the perplexities from the joint probability use rather
% perplexities.m (q.v.), but once you have the entropies, it is more effective
% to use this primitive than using perplexities.m.
%
% Authors: FVA, CPM, 2009-2014

% [muXY,nxy,myx,nx,my,nmuXY] = perplexities(n2MI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy);

error(nargchk(7,7,nargin));

dim = max(size(n2MI));
if (dim==1)
    n = 2^Hux;
    nx_y=2^(nVIx*Hux);
    my_x=2^(nVIy*Huy);
    nx=n/(2^(nDHpx*Hux));
    my=n/(2^(nDHpy*Huy));
    muXY=2^(n2MI*(Hux+Huy)*(1/2));
    nmuXY=muXY/n;
else
    n = 2.^Hux;
    nx_y=2.^(nVIx.*Hux);
    my_x=2.^(nVIy.*Huy);
    nx=n ./(2.^(nDHpx.*Hux));
    my=n ./(2.^(nDHpy.*Huy));
    muXY=2.^(n2MI.*(Hux + Huy)*(1/2));
    nmuXY=muXY ./ n;
end
return