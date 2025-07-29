function [Kout] = explore_in_phi_iperfect(Kin, outdirbase, mask, phis, subfolderName)
% explore_in_phi_iperfect: A function to explore a K-FCA context by sweeping
%   through the phi parameter while ignoring "perfect" classifications. This
%   is a specialized function for contexts where a mask is used to identify
%   perfectly classified entries, which should be excluded from the analysis.
%
%   INPUTS:
%
%   - [Kin]: An input context object of type fca.mmp.Context.
%   - [outdirbase]: The base directory for saving output files.
%   - [mask]: A numerical matrix representing the "perfect" classifications.
%   - [phis]: (Optional) A set of specific phi values to explore. If not
%             provided, the function will automatically determine the unique
%             phi values from the context matrix.
%   - [subfolderName]: (Optional) A custom name for the output subfolder.
%                      If not provided, a descriptive name will be generated.
%
%   OUTPUTS:
%
%   - [Kout]: The output context structure, containing the exploration results.
%       * Kout.Phis: A sorted array of the phi values explored.
%       * Kout.nc: An array holding the number of concepts found at each phi value.


%% 1. Preprocess Input Data and Options

% Check for number of input arguments.
error(nargchk(3, 5, nargin));

% Create the output context from the input context.
Kout = Kin;

% Invert the R matrix, as this function works with minplus logic internally.
% The original matrix is restored at the end of the function.
Kout.R = -Kout.R;

% If the context has already been explored, return early.
if Kout.explored
    warning('mmp:fca:Context:structural', 'Context fully explored already');
    return;
end

%% 2. Determine Phi Values for Exploration

if nargin < 4 % phis were not provided as an input argument.
    % Get all unique values from the virtual incidence matrix.
    qR = get_virtual_incidence(Kout);
    % Exclude infinite values, as these are not part of the exploration.
    Kout.Phis = unique(qR);
    Kout.Phis = Kout.Phis(~isinf(Kout.Phis));
else
    % Use the phi values provided by the user.
    Kout.Phis = phis;
end

% Ensure phis is a sorted row vector for consistent iteration.
Kout.Phis = sort(Kout.Phis);

%% 3. Create Output Directory

% Define the base name for the output context.
Kout.Name = sprintf('%s_minplus', Kout.Name);

% Create the output directory based on a custom subfolder name or a generated one.
if nargin > 4 && ischar(subfolderName)
    outdir = fullfile(outdirbase, subfolderName);
else
    % Fallback to the original descriptive naming if no custom name is provided.
    outdir = fullfile(outdirbase, [Kin.mat_filename, '_', num2str(Kin.g), 'x', num2str(Kin.m), '_minplus']);
end

% Create the directory if it doesn't exist.
[suc, msg] = mkdir(outdir);
if ~suc
    error('kfca:mmp:Context:explore_in_phi', msg);
end

% Initialize output arrays.
nphis = length(Kout.Phis);
Kout.nc = zeros(nphis, 1);
Kout.Ks = cell(1, nphis);


%% 4. Explore Phi Values and Generate Concepts

lastK_idx = 0; % Index of the last structural context that was different.
last_inc = [];  % Stores the incidence matrix of the last different context.

% Loop through each phi value to explore the conceptual lattice.
for step = 1:nphis
    phi = Kout.Phis(step);

    % Create the structural context for the current phi, ignoring perfect classifications.
    [thisKs] = structural_iperfect(Kout, mask, phi);

    % Only output files and re-calculate concepts if the structural context has changed.
    % This avoids redundant calculations for plateaus in the concept count curve.
    current_inc = get_virtual_incidence(thisKs);
    
    if step == 1 || ~isequal(current_inc, last_inc)
        % Output the new context to a CSV file.
        mat2csv(thisKs, outdir);

        % Get the concepts.
        A = concepts(thisKs);

        % Store the structural context, its phi value, and the concept count.
        Kout.Ks{step} = thisKs;
        Kout.nc(step) = size(A, 2);
        
        % Update the tracking variables for the last different context.
        lastK_idx = step;
        last_inc = current_inc;
    else
        % If the context is the same as the last one, just copy the concept count.
        Kout.nc(step) = Kout.nc(lastK_idx);
        % Note: We don't save the matrix to `Kout.Ks` again to save memory.
    end
end

% Restore the original R matrix.
Kout.R = -Kout.R;

% Flag the context as explored on a successful exit.
Kout.explored = true;

end