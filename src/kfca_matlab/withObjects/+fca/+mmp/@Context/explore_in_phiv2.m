function [Kout] = explore_in_phiv2(Kin, outdirbase, opts, subfolderName)
% explore_in_phiv2: A function to obtain the series of structural contexts of a K-FCA context.
%   This function sweeps through the phi parameter to generate a series of
%   conceptual lattices and records their properties, such as the number of
%   concepts at each phi value.
%
%   INPUTS:
%
%   - [Kin]: An input context object of type fca.mmp.Context to be analyzed.
%   - [outdirbase]: The base directory for saving output files.
%   - [opts]: A structure containing options for the phi exploration.
%       * opts.inv (boolean): Set to true for min-plus analysis, false for max-plus.
%       * opts.saveMatrix (boolean): If true, saves each structural incidence matrix.
%       * opts.h: Handle for a waitbar object (can be 0 for no waitbar).
%       * opts.auto (boolean): If true, explores all unique phi values.
%       * opts.fromPhi: Starting phi in a custom range (if opts.auto is false).
%       * opts.toPhi: Ending phi in a custom range (if opts.auto is false).
%       * opts.samplePhis (boolean): If true, samples the phi range.
%       * opts.numPhis (integer): Number of different phis to explore.
%   - [subfolderName]: (Optional) A custom name for the output subfolder.
%                      If not provided, a descriptive name will be generated.
%
%   OUTPUTS:
%
%   - [Kout]: The output context structure, containing the exploration results.
%       * Kout.Phis: A sorted array of the phi values explored.
%       * Kout.nc: An array holding the number of concepts found at each phi value.


%% 1. Preprocess Input Data and Options

% Check for number of input arguments to handle optional 'subfolderName'.
if nargin < 3
    error('explore_in_phiv2 requires at least 3 arguments: Kin, outdirbase, opts.');
end

% If the context is already clarified, use it directly. Otherwise, clarify it.
% Kout will be the main structure for storing results.
if Kin.clarified
    Kout = Kin;
else
    % Note: clarify(Kin) is commented out in the original, so we'll maintain that.
    Kout = Kin;
end

% Set up default options if not provided.
if nargin < 3
    opts = fca.mmp.explore.mkPhiExplorationOptions(); % Default options.
end

% Extract options for easier use.
saveMatrix = opts.saveMatrix;
inv = opts.inv;
h = opts.h;
exploreAllPhis = opts.auto;

%% 2. Determine Phi Values for Exploration

% Get the virtual incidence matrix.
qR = get_virtual_incidence(Kin);

% Find all unique, non-infinite values in the matrix.
uqR = unique(double(qR));
phis = full(uqR(~isinf(uqR)))';

% Ensure phis is a row vector.
if size(phis, 1) > size(phis, 2)
    phis = phis';
end

% If not exploring all unique phis, generate a custom range.
if ~exploreAllPhis
    phis = phis(phis >= opts.fromPhi);
    phis = phis(phis <= opts.toPhi);
    if opts.numPhis < length(phis)
        if (opts.samplePhis)
            % Sample a random subset of the unique phi values.
            phis = phis(sort(random('unid', length(phis), [1 opts.numPhis])));
        else
            % Generate a uniformly spaced range of phi values.
            phis = linspace(min(phis), max(phis), opts.numPhis);
        end
    end
end

%% 3. Create Output Directory

% Record the type of exploration in the output context name.
if inv
    Kout.Name = sprintf('%s_minplus', Kout.Name);
else
    Kout.Name = sprintf('%s_maxplus', Kout.Name);
end

% Create the output directory based on a custom subfolder name or a generated one.
if nargin > 3 && ischar(subfolderName)
    outdir = fullfile(outdirbase, subfolderName);
else
    % Fallback to a descriptive naming scheme if no custom name is provided.
    outdir = fullfile(outdirbase, [Kin.Name, '_', num2str(Kin.g), 'x', num2str(Kin.m), '_minplus']);
end

% Create the directory if it doesn't exist.
[suc, msg] = mkdir(outdir);
if ~suc
    error('kfca:mmp:Context:explore_in_phiv2', msg);
end

% Initialize output arrays.
Kout.nc = [];
Kout.Phis = [];
if saveMatrix
    Kout.Ks = {};
end

%% 4. Explore Phi Values and Generate Concepts

disp('Calculating concepts for each phi value...');
prevUniqI = 0; % Stores the unique incidence matrix from the previous step.
k = 0;

% Get the labels from the input context.
vG = Kin.G;
vM = Kin.M;

% Loop through each phi value to explore the conceptual lattice.
for phi = phis
    % Skip this phi if it has already been explored.
    if any(phi == Kout.Phis)
        continue;
    end

    % Generate the structural incidence matrix I for the current phi.
    if inv
        I = Kin.R >= phi;
    else
        I = Kin.R <= phi;
    end

    % Get the unique rows of the incidence matrix.
    uniqI = unique(I, 'rows');
    uniqI = unique(uniqI', 'rows')'; % Clarify columns as well.

    % Only proceed if the new incidence matrix is different from the previous one.
    if ~(isequal(uniqI, prevUniqI))
        % Update progress feedback.
        barL = find(phis == phi, 1) / length(phis);
        if inv
            waitStr = sprintf('Exploring MinPlus: Phi: %f. Progress: %.1f%%', phi, barL * 100);
        else
            waitStr = sprintf('Exploring MaxPlus: Varphi: %f. Progress: %.1f%%', phi, barL * 100);
        end

        if h > 0
            waitbar(barL, h, waitStr);
        else
            disp(waitStr);
        end

        % Create a new context from the current structural incidence matrix.
        k = k + 1;
        thisK = fca.Context(vG, vM, I, sprintf('%s_structural_%1.20f', Kout.Name, phi));

        % Output the context to a CSV file.
        mat2csv(thisK, outdir);

        % Optionally, save the structural context matrix itself.
        if (saveMatrix)
            Kout.Ks{k} = thisK;
        end

        % Calculate and store the number of concepts.
        Kout.nc(k) = size(concepts(thisK), 2);
        Kout.Phis(k) = phi;

        % Check for an empty conceptual lattice (should not happen).
        if Kout.nc(k) < 1
            error('fca:mmp:Context:explore_in_phi', 'Conceptual lattice is empty!');
        end
        
        % Update the previous unique incidence matrix.
        prevUniqI = uniqI;
    end
end

% Set a flag to indicate the context has been successfully explored.
Kout.explored = true;
Kout.minplus = opts.inv; % Record the type of exploration.

end