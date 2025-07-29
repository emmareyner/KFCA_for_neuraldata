function phis = build_phis(values,options)
% function phis = fca.mmp.explore.build_phis(values,options)
% function phis = fca.mmp.explore.build_phis.build_phis(values)
%
% A function to extract from a sequence of possibly non-unique values a
% sequence of unique exploration phis to be used in maxplus-FCA or
% minplus-FCA analysis.
%
% function phis = build_phis(values) auto-generates a sequence from a
% standard lower to upper limits for minplus analysis
%
% Author: FVA, 01/2014.
error(nargchk(1, 2, nargin));

% If no values supplied ensure auto-generation
if (nargin < 2); 
    options = fca.mmp.explore.mkPhiExplorationOptions();%Uniform sweeping
    options.inv = true;
end
%Make a vector with the values:
if (size(values,1) ~= 1)
    phis = unique(full(values(:)));%just in case: linearize
else%it is a row
    phis = unique(full(values));
end
%dispose of infinites
phis = phis(~isinf(phis));
min_phi = full(max(options.fromPhi,min(phis)));
max_phi = full(min(options.toPhi,max(phis)));
%Dispose of values out of range
phis=phis(phis>=min_phi);
phis=phis(phis<=max_phi);
if (length(phis) > options.numPhis)
    %SAMPLE FROM THE BINS!
    sampledPhis = zeros(1,options.numPhis);
    %You need to find F and bins to do the sampling.
    if (options.auto)
        %Does equal width over-binning, then downsampling.
        binEdges = linspace(min_phi,max_phi,options.numPhis^2+1);
        %# assign values to bins
        [~,F] = histc(phis, [binEdges(1:end-1) Inf]);
        vals = unique(F');
        if (length(vals) > options.numPhis)
            numbers = floor(mod(vals,length(vals)/(options.numPhis +1)));
            %bins = find(numbers==1);
            bins = vals(numbers==1);
            bins(end) = vals(end);%guarantee the last bin is the highest
        else
            warning('Number of bins found less than requested');
            bins = vals;
        end
        %phis = linspace(min_phi,max_phi,options.numPhis);%might generate NaNs when exploring!
    else
        switch(lower(options.binning))
            case 'freq'
                %if (~options.auto)%equal frequency binning and sampling
                %recipe from
                % http://matlabdatamining.blogspot.com.es/2007/02/dividing-values-into-equal-sized-groups.html
                % to make equal frequency binning
                F = ceil(options.numPhis*tiedrank(phis)/length(phis));%same length as phis
                %F stores the assignment to equal-frequency bins
                %FVA: TODO randomize these sampled Phis
                %phis=phis(1:(length(phis)/opts.numPhis):end);
                %phis = phis(random('unid',length(phis),[1 options.numPhis]));
            case 'width'
                %else%sample from equally spaced binning
                % from: http://stackoverflow.com/questions/7911714/dividing-a-range-into-bins-in-matlab
                binEdges = linspace(min_phi,max_phi,options.numPhis+1);
                %# assign values to bins
                [~,F] = histc(phis, [binEdges(1:end-1) Inf]);
                %     case 'uniform'
                %         phis = linspace(min_phi,max_phi,options.numPhis);
        end
        bins=unique(F);
    end
    for bin=1:length(bins)
        thisBin = phis(F==bins(bin));%FVA: does this compute for different values of numPhis?
        assert(not(isempty(thisBin)))
        %if (isempty(thisBin))
            %sampledPhis(bin) = binEdges(bin+1);%upper limit in interval, but might generate NaNs when exploring!
        %else%artificial limit
            sampledPhis(bin) = thisBin(randi(length(thisBin),1));
        %end
    end
    phis = sampledPhis;
    
end

if options.inv%minplus analysis: sort in ascending order
    phis = sort(phis);
else%for maxplus analysis, sort in descending order
    phis = sort(phis,'descend');
end
if options.debug%Sanity check
    if options.inv
        assert(issorted(phis))
    else 
        assert(issorted(fliplr(phis)))
    end
end
return

