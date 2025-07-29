function [nDHpxpy,n2MI,nVI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy,phis,masked] = entropic_exploration(rawcounts,mat,options,oldPhis)
% function [nDHpxpy,n2MI,nVI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy,phis,masked] = NITcluster(rawcounts,Kin,options)
% function [nDHpxpy,n2MI,nVI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy,phis] = NITcluster(rawcounts,Kin,options)
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
%     numPhis=20;%need to randomize
%     options = fca.mmp.explore.build_phis(auto,fromPhi,toPhi,samplePhis,numPhis)%Show it for logging purposes!
%     options.inv=true;%Explicitly request minplus analysis
% 
% Note that the chosen standard context is [Kout.Ks{ndx}] which should be
% explored with ConExp, for instance.
%
% SEE ALSO: NITclustering, for a previous, less generic attempt at this.
% Authors: FVA, 20/01/2014
error(nargchk(1, 4, nargin));

%% Preprocess arguments
rawcounts = double(rawcounts);%No effect if already double
% If no mat suplied, explore the rawcounts matrix
if (nargin < 2); mat = rawcounts; else mat = double(mat); end

%Find the phis to be explore
phis=unique(mat(:));%Only sweep unique values. Done and done again!
% phis=full(phis(~isinf(phis)))';%Do not explore -Inf, Inf
% [nr,nc]=size(phis);
% if (nr>nc);phis=phis';end%Turn into a row vector
if (nargin > 3); phis=setdiff(phis,oldPhis); end%do not reexplore old values
fprintf('There are %d phis left to explore.\n', length(phis))

% Now explore in several conceptualization modes
%always restrict the bounds
fromPhi=min(min(phis));
toPhi=max(max(phis));
if (nargin < 3)
    %We do the minplus exploration to obtain the most prominent associations.
    auto=false;
    %samplePhis=true;
    numPhis=20;%need to randomize. Done!
%TODO: remove this dependency on the fca library!    
    options = fca.mmp.explore.mkPhiExplorationOptions(auto,fromPhi,toPhi,numPhis);%Show it for logging purposes!
    options.inv=true;%Explicitly request minplus analysis
else%change bounds, but not the type of exploration requested 
    options.fromPhi = min(options.fromPhi,fromPhi);
    options.toPhi = max(options.toPhi,toPhi);
end
fprintf('***Exploring matrix with options:')
display(options)

%The code above leaves the phis ready for auto exploration!
%%exploreAllPhis=options.auto;
%if (~options.auto)
    phis = fca.mmp.explore.build_phis(phis,options);

% 
%     phis=phis(phis>=options.fromPhi);
%     phis=phis(phis<=options.toPhi);
% 
%     if (options.numPhis<length(phis))
%         if (options.samplePhis)%Do not generate, but sample the phis
%             %FVA: TODO randomize these sampled Phis
%             %phis=phis(1:(length(phis)/opts.numPhis):end);
%             phis = phis(random('unid',length(phis),[1 options.numPhis]));
%         else%generate the phis uniformly
%             phis=linspace(min(phis),max(phis),options.numPhis);
%         end
%     end
%     if options.inv%minplus analysis: sort in ascending order
%         phis = sort(phis);
%     else%for maxplus analysis, sort in descending order
%         phis = sort(phis,'descend');
%     end
    
%end

%% Go over matrices masking the original counts with the result of exploration
% needs rawcounts, and the context or the matrix being analyzed, e.g. WPI, 
% to create the masked counts
%  Adapted from explore_in_phi
%Now build the set of explored mats
L = length(phis);
if (nargout > 10)%also return the masked matrices
    masked = cell(1,L);%TODO: Return as 3d matrix? NO, if you want them sparse!
end
%if (nargout <= 4)
    nVI = zeros(1,L);
    nVIx = zeros(1,L);
    nVIy = zeros(1,L);
    nDHpxpy= zeros(1,L);
    nDHpx= zeros(1,L);
    nDHpy= zeros(1,L);
    n2MI = zeros(1,L);
    Hux= zeros(1,L);
    Huy= zeros(1,L);
%end

for l=1:L
    % FVA: a nice touch from JMGC, to see how things are progressing...
    tic
    phi = full(phis(l));
    barL=find(phis==phi)/length(phis);%Phis should be ordered for this to work!
    if (options.inv)
        waitStr=sprintf('Exploring MinPlus: Phi: %f2.8f. Progress: %f%%',phi,barL*100); %CPM: still is phi (not -phi)
    else
        waitStr=sprintf('Exploring MaxPlus: Varphi: %2.8f. Progress: %f%%',phi,barL*100);
    end
    if (options.h>0)
        waitbar(barL,h,waitStr);
    else
        disp(waitStr);
    end
    
    %Stack struct context coindexed with phi    
    if (options.inv)
        I=mat>=phi;             
    else
    	I=mat<=phi;
    end
    %Then work out the coordinates
    masked_rc = rawcounts .* +I;
    if (nargout > 4), masked{l} = masked_rc; end;%TODO: perhaps store the sparse masks, not the masked?
    [nVI(l),nDHpxpy(l),n2MI(l),nVIx(l),nVIy(l),nDHpx(l),nDHpy(l),Hux(l),Huy(l)]=coordinates(masked_rc);
    
    toc
end

end

