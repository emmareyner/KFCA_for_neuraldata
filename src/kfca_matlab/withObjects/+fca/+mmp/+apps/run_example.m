function [Kout]=run_example(datadir,labelsdir, matfilename, elabelsfilename, rlabelsfilename, outdirbase, maxplus, ignoreperfect, mask, description, objectNames, attributeNames);
% run_example: An entry point for performing K-FCA analysis on a formal context matrix.
%   This function handles data loading, preprocessing (PMI calculation),
%   K-FCA context creation, concept extraction over a range of phi values,
%   and visualization of the results.
%
%   INPUTS:
%   datadir: Folder where the data matrix file resides.
%   labelsdir: Folder where the label files reside.
%   matfilename: Base name of the .mat file containing the numerical context matrix.
%                (e.g., if the file is 'mydata.mat', matfilename is 'mydata').
%   elabelsfilename: Base name of the .txt file containing labels for 'emitted' symbols (objects).
%   rlabelsfilename: Base name of the .txt file containing labels for 'received' symbols (attributes).
%   outdirbase: Base directory for saving any output results (e.g., detailed concept descriptions).
%   maxplus: A boolean flag (0 or 1). Determines the type of fuzzy operators used
%            (e.g., 0 for standard fuzzy logic, 1 for max-plus algebra).
%   ignoreperfect: A boolean flag (0 or 1). If 1, ignores concepts that perfectly match all
%                  attributes or objects, focusing on less trivial structures.
%   mask: A numerical matrix or array used for masking or filtering the input data.
%   description: A character string providing a descriptive title for the analysis,
%                used in plots and outputs.
%   objectNames: (Optional) A cell array of strings for object (row) labels.
%                If provided, this bypasses reading from the elabelsfilename.
%   attributeNames: (Optional) A cell array of strings for attribute (column) labels.
%                   If provided, this bypasses reading from the rlabelsfilename.
%
%   OUTPUTS:
%   Kout: A structure containing the results of the K-FCA analysis,
%         most notably 'Kout.Phis' (the array of phi values explored) and
%         'Kout.nc' (the corresponding number of concepts found at each phi).


% --- 1. Argument Validation and Data Loading ---

% Ensure the function receives between 6 and 12 arguments.
error(nargchk(6, 12, nargin));

% Assign an empty string if description is not provided.
if nargin < 10
    description = '';
end

% Load the matrix from the specified .mat file.
% 'fullfile' is used to create a robust file path.
load(fullfile(datadir, [matfilename, '.mat']));

% Create a struct 'pm' to contain the matrix information and metadata.
% This struct consolidates the data, labels, and various flags for internal use
% by the 'fca.mmp' package functions.
pm.mat = eval(matfilename); % Retrieves the matrix content loaded from the .mat file.
pm.title = description;     % Assigns the provided description as the matrix title.
pm.symmetric = 0;           % Flag indicating if the matrix is symmetric (0 = no).
pm.hasdiag = 1;             % Flag indicating if the matrix has meaningful diagonal entries.
pm.smallest = 0;            % Any value below this magnitude is considered 0.
pm.dp = 0;                  % Number of decimal places for display.

% --- 2. Label Loading ---

% Check for direct label inputs; if not provided, load from files.
if nargin >= 11
    % Use the provided in-memory label variables
    pm.elabelset = objectNames;
    pm.rlabelset = attributeNames;
else
    % Load labels from the specified .txt files (original behavior)
    % 'fullfile' is used to create a robust file path.
    pm.elabelset = fca.apps.read_labels(fullfile(labelsdir, [elabelsfilename, '.txt']));
    pm.rlabelset = fca.apps.read_labels(fullfile(labelsdir, [rlabelsfilename, '.txt']));
end
pm.nephones = numel(pm.elabelset); % Number of objects/emitted symbols.
pm.nrphones = numel(pm.rlabelset); % Number of attributes/received symbols.


% --- 3. Matrix Preprocessing (PMI Calculation) ---

% Initialize conf_mat with the raw matrix.
conf_mat = pm.mat;

% Perform Pointwise Mutual Information (PMI) calculation.
% This transforms the raw counts into a measure of association strength.
if issparse(conf_mat)
    % Handles sparse matrices for efficiency.
    [I, Pxy] = pmi(conf_mat);
    conf_mat = mmp.x.Sparse(I); % Converts the PMI result back to a sparse object.
else
    % For dense matrices, issues a warning about type conversion.
    warning('fca:mmp:apps:run_example', 'about to transform counts into integers!');
    [I, Pxy] = pmi(uint16(conf_mat));
    % The line below is commented out to use the original `pm.mat` for the context.
    % If PMI is desired as the context, this line should be uncommented.
    % conf_mat = I;
end

% Plotting the cumulative sum of PMI values. If PMI has not wanted,
% this figure does not provide information.
figure;
pmi_mat_sin_inf = I;
pmi_mat_sin_inf(isinf(I)) = 0; % Replace any Inf (infinity) values with 0.
sum(sum(pmi_mat_sin_inf)); % Display the sum of all non-infinite PMI values (debugging aid).
title('Cumulative sum of PMI values of the elements of the CM', 'Interpreter', 'latex');
plot(sort(pmi_mat_sin_inf(:)), cumsum(sort(pmi_mat_sin_inf(:))));


% --- 4. Create the K-FCA Context Object with Dimension Checks ---

% Create the K-FCA Context object, which encapsulates the formal context.
% First, we perform checks to ensure dimensions match.
[numRows, numCols] = size(conf_mat);
numObjLabels = numel(pm.elabelset);
numAttLabels = numel(pm.rlabelset);

% Check and transpose the matrix if its dimensions don't match the labels.
if numRows == numAttLabels && numCols == numObjLabels
    warning('run_example:matrixTransposed', 'Matrix dimensions appear transposed. Transposing back to Objects x Attributes.');
    conf_mat = conf_mat';
    [numRows, numCols] = size(conf_mat);
end

% Final check to ensure consistency before creating the Context object.
if numRows ~= numObjLabels
    error('run_example:dimensionMismatch', ...
        'Number of matrix rows (%d) does not match the number of object labels (%d).', numRows, numObjLabels);
end
if numCols ~= numAttLabels
    error('run_example:dimensionMismatch', ...
        'Number of matrix columns (%d) does not match the number of attribute labels (%d).', numCols, numAttLabels);
end

% Now, create the K-FCA Context object.
K = fca.mmp.Context(pm.elabelset, pm.rlabelset, conf_mat, matfilename);


% --- 5. Configure and Run the Phi Exploration ---

% Configure options for the phi exploration.
opts = fca.mmp.explore.mkPhiExplorationOptions(); % Creates a structure for phi exploration options.
opts.samplePhis = 0; % Determines if phi values are sampled (0=no, implies a full sweep).
opts.numPhis = Inf;  % Number of phi values to explore.

% Logic to set the 'inv' (inverse) option based on 'maxplus'.
if maxplus
    opts.inv = false;
else
    opts.inv = true;
end

% Run the phi exploration to generate formal concepts across a range of phi values.
if ignoreperfect
    % If 'ignoreperfect' is true, a specific function 'explore_in_phi_iperfect' is used.
    [Kout] = explore_in_phi_iperfect(K, outdirbase, mask);
else
    % Otherwise, 'explore_in_phiv2' is used, which is a more general function.
    Kout = explore_in_phiv2(K, outdirbase, opts);
end


% --- 6. Plotting and Final Output ---

% Make plots: Number of concepts vs. phi.
figure;
[Kout.Phis, I] = sort(Kout.Phis); % Sort the phi values for a smooth plot.
Kout.nc = Kout.nc(I);              % Apply the same sorting permutation to concept counts.
plot(Kout.Phis, Kout.nc);
title(['Number of concepts:', description], 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex');
xlabel(['\phi']);
ylabel('Number of concepts');

% Display the accuracy (relevant for confusion matrices).
display(['Accuracy: ', num2str(sum(diag(pm.mat) / sum(sum(pm.mat))))]);

% Pretty display of the confusion matrix using 'fca.apps.prettydisplay_confmat'.
figure;
colormap(gray); % Sets the colormap for the image display.
fca.apps.prettydisplay_confmat(pm.mat, pm.elabelset, pm.rlabelset, pm.title);

end