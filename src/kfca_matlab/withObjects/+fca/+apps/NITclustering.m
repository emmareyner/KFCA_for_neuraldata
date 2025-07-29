function [Kout,ndx,maxNIT,maxPhi] = NITclustering(rawcounts,Kin,options)
% function [Kout,ndx,maxNIT,maxPhi] = NITcluster(rawcounts,Kin,options)
% 
% A function to explore a matrix of counts and a context built on it with 
% whatever weight function.
%
% By default, it maximizes the NIT factor and the exploration is carried
% out with the options:
%     %We do the minplus exploration to obtain the most prominent associations.
%     auto=false;
%     fromPhi=0;
%     toPhi=Inf;
%     samplePhis=false;
%     maxPhis=20;%need to randomize
%     options = fca.mmp.explore.build_phis(auto,fromPhi,toPhi,samplePhis,maxPhis)%Show it for logging purposes!
%     options.inv=true;%Explicitly request minplus analysis
% 
% Note that the chosen standard context is [Kout.Ks{ndx}] which should be
% explored with ConExp, for instance.
%
% Authors: FVA, 20/01/2014
error(nargchk(1, 3, nargin));

%% Now explore in several conceptualization modes
if (nargin < 3)
    %We do the minplus exploration to obtain the most prominent associations.
    auto=false;
    fromPhi=0;
    toPhi=Inf;
    numPhis=20;%need to randomize. Done!
    %options = fca.mmp.explore.build_phis(auto,fromPhi,toPhi,samplePhis,maxPhis)%Show it for logging purposes!
    options = fca.mmp.explore.mkPhiExplorationOptions(auto,fromPhi,toPhi,numPhis)%Show it for logging purposes!
    options.inv=true;%Explicitly request minplus analysis
    options.samplePhis=false;
end
Kout = explore_in_phiv2(Kin,'./NITclustering',options);

%% Go over matrices masking the original counts with the result of exploration
% needs rawcounts, and the context or the matrix being analyzed, e.g. WPI, 
% to create the masked counts
masked_counts = cellfun(@(m) double(rawcounts) .* +m.I,Kout.Ks, 'UniformOutput',false);
% represent the matrices. to visulaize them, but not really needed to
% maximize the NIT
compareETs(masked_counts)%Not really needed... Just for visualization purposes.

%% Find the context with the maximum NIT
%infos = cellfun(@(m) pmi(double(rawcounts) .* +m.I),Kout.Ks, 'UniformOutput', false)
[nVI,nDHpxpy,n2MI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy]=coordinates(masked_counts);
% Nit is nmuXY and ema is 1/nxy in the following
[muXY,nxy,myx,nx,my,nmuXY] = perplexities2(n2MI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy);
%find out the max nmuXY 
[maxNIT,ndx] = max(nmuXY)
%now find the phi
maxPhi = Kout.Phis(ndx)

return