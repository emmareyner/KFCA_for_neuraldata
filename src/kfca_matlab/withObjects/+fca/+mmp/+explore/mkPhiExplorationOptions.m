function options = mkPhiExplorationOptions(auto,fromPhi,toPhi,numPhis,debug,verbose)
% function options = fca.mmp.explore.mkPhiExplorationOptions(auto,fromPhi,toPhi,samplePhis,numPhis,debug,verbose)
%
% A function to produce a default exploration structure for
% fca.mmp.Contexts to be used in fca.mmp.Context.explore_in_phiv2. This
% primitive concentrates in building the range of phis to be explored.
%
% The default fields are:
% *h = 0, a visual object handle for a waitbar object in the gui.
% *saveMatrix = true, whether to save the structural contexts obtained,
% *inv = false, whether to explore with maxplus(false) or minplus(true) order.
%
% * verbose (boolean (true)), whether to provide verbose output.
%
% * debug (boolean (false)), whether to provide debugging traces.
%
% The options related to the range of phis are:
% *auto, boolean (default 'false'). Let the computer choose the range,
% which is normally equi-spaced in the range from min to max values.
%
% * fromPhi (real, (default -Inf)), starting value of range
%
% * toPhi (real, (default Inf)), ending value of range
%
% * numPhis (positive integer, (default 10)), number of phi values to be explored: if
% Inf, just consider all of them.
%
% If auto = false, then the following are taken into consideration:
% * binning, string (default 'width'),  Choose the type of binning to do the
% sampling.
% binning = 'width';% Do equal *width* binning of phi values.
% binning = 'freq';%Do equal *freq* binning of phi values.
%
% examples:
%   - opts = fca.mmp.explore.build_phis() produces the whole range of phis (the
%   old default, use sparingly). It implies max-plus ordered exploration.
%
%   - opts = fca.mmp.explore.build_phis(false,0,Inf,true,500), returns a range
%   adequate for min-plus ordered exploration of upregulation sampled at
%   500 points. *BUT* you must explicitly request min-plus ordered
%   exploration by changing: 
%   opts.inv=true.
%
% Author FVA: 2009-14
error(nargchk(0, 7, nargin));

%Default values for fields.
rauto = false;      
rfromPhi = mmp.l.zeros;%Whole [-Inf,Inf] range by default.
rtoPhi = mmp.l.tops;
%rsamplePhis = 0; %do not sample by default...
rnumPhis = 10; %returning 100 exploration values by default
rbinning = 'width';%Do equal width binning for choosing Phis

%% Now process input values
if nargin >= 1
    rauto = auto;
end
if nargin >= 2
    rfromPhi = fromPhi;
end
if nargin >= 3
    rtoPhi = toPhi;
end
if nargin >= 4
    rnumPhis = numPhis;
end

if nargin < 5, debug = false; end
if nargin < 6; verbose = true; end

options = struct(...
    'debug',debug,...
    'verbose',verbose,...
    'h',0,...
    'saveMatrix',true,...
    'ignoreperfect',false,...
    'inv',false,...
    'auto',rauto,...
    'binning',rbinning,...
    'fromPhi',rfromPhi,...
    'toPhi',rtoPhi,...
    'numPhis',rnumPhis);%number of phis to be explored
return

