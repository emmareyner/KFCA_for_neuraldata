function [max2MI_minplus_phi, max2MI_maxplus_phi,Nxy] = disjointMIoptimization( Nxy, Kxy, options )
% A function to maximize using separate (lightweight) minplus and maxplus
% exploration.
% Nxy is a (count) distribution
% Kxy is any information-bearing encoding of Nxy (e.g. PMIxy, wPMIxy, etc.)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%A generic mechanism to explore with maxplus or minplus analysis
%
%We do the minplus exploration to obtain the most prominent associations
%and maxplus to find the least prominent.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
error(nargchk(1,3, nargin));
error(nargchk(0,3, nargin));%might be used for exploration!!!

if (nargin < 2)
    Kxy = weightedPMI(Nxy);
end
if (nargin < 3)
    auto=false;%Equal frequency binning
    auto=true;%Equal width binninb
    %auto=true;
    fromPhi=-Inf;%Do not impose lower limits in exploration
    toPhi=Inf;%Do not impose upper limits in exploration
    %samplePhis=true;%randomize phis
    %samplePhis= false;%interpolate in whole range (data dependent, not[-Inf,Inf]
    maxPhis=30;%Take these many sample points
    %options = fca.mmp.explore.build_phis(auto,fromPhi,toPhi,samplePhis,maxPhis);
    options = fca.mmp.explore.mkPhiExplorationOptions(auto,fromPhi,toPhi,maxPhis);
    options.verbose = true;
end

%Generate different exploration strategies
minplus_options = options;%Show it for logging purposes!
minplus_options.inv=true;%Explicitly request minplus analysis
%minplus_options.fromPhi = 0;
maxplus_options = options;%Show it for logging purposes!
%maxplus_options.toPhi = 0;

%     Ntrain = full(sum(sum(NxyTrain)));
%     fprintf('There are %d instances in the training doc-term matrix on %d entries.\n',Ntrain,nnz(NxyTrain))
%Obtain its entropic characterization
if (minplus_options.verbose)
    fprintf('\nMin-plus exploring the wPMI...\n');
end
%[Kxy,Pdt] = weightedPMI(Nxy);%using
% EMI_Pdt
% wPMIdtTrain
[nDHpxpy,n2MI,nVI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy,phis] = entropic_exploration(Nxy,Kxy,minplus_options);
[muXY,nxy,myx,nx,my,nmuXY] = perplexities2(n2MI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy);
if (minplus_options.verbose)
    h1 = figure()
    %plot_ET_plotbar(nDHpxpy,n2MI,nVI,nmuXY);    
    plot_ET(nDHpxpy,n2MI,nVI,nmuXY);    
    title('Minplus exploration.Colour according to NIT');
    %select the ndx maximizing the transferred MI and the coindexed phi
end
[~,ndxMI] = max(n2MI);
max2MI_minplus_phi = phis(ndxMI);

%Now explore towards the minimization of something else, say nVI
if (maxplus_options.verbose)
    fprintf('Max-plus exploring the wPMI...\n');
end
%maxp_NxyTrain_options.inv = false
[nDHpxpy,n2MI,nVI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy,phis] = entropic_exploration(Nxy,Kxy,maxplus_options);
[muXY,nxy,myx,nx,my,nmuXY] = perplexities2(n2MI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy);
if (maxplus_options.verbose)
    h2 = figure()
    plot_ET(nDHpxpy,n2MI,nVI,nVI);
    title('Maxplus exploration.Colour according to NIT');
end
[~, ndxMImaxplus] = max(n2MI)

max2MI_maxplus_phi = phis(ndxMImaxplus);

%check a consistency condition
assert(max2MI_minplus_phi <= max2MI_maxplus_phi, 'Cannot optimize jointly: > %s and <%s have null overlap',...
    max2MI_minplus_phi,max2MI_minplus_phi)

if (nargout > 2)
    Nxy = Nxy .* (Kxy > max2MI_minplus_phi & Kxy < max2MI_maxplus_phi);
    %     nnz(NxyTrainMax)
    %     max(max(NxyTrainMax))
    %     min(min(NxyTrainMax))
    if (options.verbose)
        % Then obtain this estimate
        oldMI_Nxy = full(sum(sum(Kxy)));%from 4.5264
        Kxy = weightedPMI(Nxy);
        newMI_Nxy = full(sum(sum(Kxy)));% to 8.0689
        fprintf('Information gain: %2.8f from %2.8f to %2.8f!',newMI_Nxy-oldMI_Nxy,oldMI_Nxy,newMI_Nxy);
    end
end
%This has really increased the information transmitted!!! From
return
end

