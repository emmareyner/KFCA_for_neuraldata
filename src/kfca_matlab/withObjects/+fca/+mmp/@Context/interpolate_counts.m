function [counti,range,ticks] = interpolate_counts(K,npoints,iplate)
% [counti,range,ticks] = interpolate_counts(K,npoints,iplate)
%
% For a phi-explored context, it returns an interpolation of the concept
% counts K.nc to be represented against the K.Phis.
% It also returns the compressed range labels [-Inf,Inf] to be
% represented with the interpolated Phis from -Inf to Inf.
%
% This is used to compare concept counts in a non-linearly compressed grid.
%
% - [K] a context or cell array of contexts. If it is a cell array of
% contexts, the interpolations are returned for all of the contexts, i.e.
% counti is coindexed with K.
% - [npoints]: number of points of interpolated grid-1. If not supplied,
% number is 51=(50+1) (including points at -Inf and Inf).
% - [iplate]: non-linear expansion functions, expands given ranges from [-Inf
% to Inf]. Values might be 'logit' and 'atanh'.
% - [counti] are the interpolated counts, K.nc, from [-Inf..Inf].
% [ticks]: strings for the range values ready to be set as the 'XTickLabel'
% attribute in a plot.

%% 1.- Generate interpolating grid for the compression function
%There might be some phi=Inf!! Hence we have to compress the range through
%something like the sigmoid!
%iplate='sigmoid';
if nargin < 2
    npoints = 50;
end
if nargin < 3
    iplate='atanh';
end
% Either sigmoi, atanh
switch iplate
    case 'logit'
    % a) The desired range
    range=0:(1/(npoints-1)):1;
    range_exp=logit(range);
    case 'atanh'
     % b) pass trough function to decompress
    range=-1:(2/(npoints-1)):1;
    range_exp=atanh(range);
    otherwise
        error('fca:mmp:Context:interpolate_counts','Unknown non-linear expansion: %s',iplate);
end

%% 2 - Interpolate
% [ne,np] = size(K);%ne is supposed to range over experiments, np over parameters.
% nr=size(range,2);
% counti=ones(ne,np,nr);%concept counts for phi = -Inf at count(:,:,1)
% counti(:,:,nr) =2;%concept counts for phi = Inf
% range_exp=range_exp(2:end-1);%Take away ends, so as not process them.
% for e=1:ne
%     for p=1:np
%         thisK=K(e,p);
%         if thisK.explored
%            counti(e,p,2:nr-1)=interp1(thisK.Phis,thisK.nc,range_exp,'nearest','extrap');
%             %supply value at Inf
%         else
%             error('fca:mmp:Context:interpolate_counts','Unexplored context: use explore_in_phi first');
%         end
%     end
% end
nr=size(range,2);
counti=ones(1,nr);%concept counts for phi = -Inf
counti(nr)=2;%concept counts for phi = Inf
% range_exp=range_exp(2:end-1);
if K.explored
    counti(2:nr-1)=interp1(K.Phis,K.nc,range_exp(2:nr-1),'nearest','extrap');
%    counti(2:nr-1)=interp1(K.Phis,K.nc,range_exp(2:nr-1),'pchip','extrap');% too many discontinuities
%     counti(2:nr-1)=interp1(K.Phis,K.nc,range_exp(2:nr-1),'spline','extrap');%produces negative counts
else
    error('fca:mmp:Context:interpolate_counts','Unexplored context: use explore_in_phi first');
end
% %complete range_exp
% range_exp=[-Inf range_exp Inf];

%% 3- Find the labels to represent range
%Decimate labels for better representation
%TODO: decimation parameter should be npoint-dependent
%Generate subranges adequate for plot axes Xticklabels.
%subrange_exp=range_exp(1:round(nr/10):nr);
%ticks = arrayfun(@(x)num2str(x,2), range_exp(1:4:41),'UniformOutput',false);
ticks = arrayfun(@(x)num2str(x,2), range_exp,'UniformOutput',false);
return%counti,range
