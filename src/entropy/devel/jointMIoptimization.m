function [phis,nDHpxpy,n2MI,nVI,vals] = jointMIoptimization( Nxy, Kxy, options, fhandle )
% function [phis,nDHpxpy,n2MI,nVI,vals] = jointMIoptimization( Nxy, Kxy, optiona, fun)
%   Detailed explanation goes here
% fun is a function on count matrices, like wPMI.
% This can be immediately printed on return!
%
% NOTE: the De Finetti diagram coordinates are already normalized!

% in the absence of values it optimizes tranferred information
if (nargin < 2)
    Kxy = weightedPMI(Nxy);
end
%Do not sample uniformly the values, since the entropies of an empty matrix
%is not defined!!!
if (nargin < 3 || isempty(options))
    verbose = true;
    debug = false;
    debug=true;
    auto=true;%Explore uniformly the whole range!
    %auto=true;
    toPhi=Inf;%Do not impose upper limits in exploration
    %samplePhis=true;%randomize phis
    numPhis=10;%Take these many sample points
    if debug, 
        numPhis = 5; 
        fromPhi=-Inf;%Do not impose lower limits in exploration
    else
        numPhis = 10; 
        fromPhi=0;%Lower values of wPMI are not interesting.
   end
    options = fca.mmp.explore.mkPhiExplorationOptions(auto,fromPhi,toPhi,numPhis,debug,verbose);
    %options = fca.mmp.explore.mkPhiExplorationOptions();%Uniform sweeping
elseif (~options.numPhis)
    options.numPhis = true;
end
With_fhandle = (nargin == 4) && (all(class(fhandle) == 'function_handle'));

%% Start processing
if options.verbose
    warning('jointMIoptimization: obtaining the appropriate phis: %d', options.numPhis)%#ok<*WNTAG> %dummy msgId
end
phis = fca.mmp.explore.build_phis(Kxy,options);
%%% Check this only when debugging requested
if options.inv
    assert(issorted(phis))
else
    assert(issorted(fliplr(phis)))
end
if options.verbose, fprintf('Done!\n'); end
%maxplus_phis = fliplr(phis);%reverse the order for the opposite exploration
% FInd a list of phis to explore, discarding pos and neg infinites!
% phis = unique(Nxy(:));
% phis = phis(~isinf(phis));
% Sometimes the linear span generates non-existent phis!
% phis = linspace(min(min(phis)),max(max(phis)),options.numPhis);
% maxplus_phis = minplus_phis;
% now sweep on minplus and maxplus phi
% obtain the Fxy coordinates
%return everything, even the NIT if it was requested!!!
L = length(phis);%Actual length L <= options.numPhis
nVI = zeros(L,L);
% nVIx = zeros(1,L);
% nVIy = zeros(1,L);
nDHpxpy= zeros(L,L);
% nDHpx= zeros(1,L);
% nDHpy= zeros(1,L);
n2MI = zeros(L,L);
% Hux= zeros(L,L);
% Huy= zeros(L,L);
if (With_fhandle); vals = zeros(L,L); end
for maxp=1:L
    %ymasked_count = Nxy; ymasked_count(Kxy > phis(maxp)) = 0;
    for p=1:L
        if (options.verbose), fprintf('Exploring for phi=%2.8f to varphi=%2.8f...',phis(p),phis(maxp)); end
        tStart=tic;
        if (phis(p) <= phis(maxp))
            %masked_count = Nxy; %ymasked_count; 
            %masked_count(Kxy < phis(p) | Kxy > phis(maxp)) = 0;%The equal signs avoid extreme empty cases.
            masked_count = Nxy .* (Kxy >= phis(p) & Kxy <= phis(maxp));
            [nVI(p,maxp),nDHpxpy(p,maxp),n2MI(p,maxp)]=coordinates(masked_count);
            if (With_fhandle); vals(p,maxp) = fhandle(masked_count); end
        end
        toc(tStart);
        if (options.verbose); fprintf('Done!\n'); end
    end
end
%Normalize coordinates
[m n] = size(Nxy);
Hux = log2(m); Huy = log2(n); 
nVI = nVI / (Hux + Huy);%denominator is just a number...
n2MI = n2MI / (Hux + Huy);
nDHpxpy = nDHpxpy / (Hux + Huy);
return
end

