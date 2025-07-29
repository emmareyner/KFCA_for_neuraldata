function labels = read_labels(filename)
% read_labels: Reads a list of labels from a text file.
%   Each label is assumed to be on a new line.
%
%   INPUTS:
%   filename: The full path to the text file containing the labels.
%
%   OUTPUTS:
%   labels: A cell array containing the labels.

% Initialize an empty cell array to store the labels
labels = {};
label_count = 0;

% Open the file for reading ('rt' for read, text mode)
fid = fopen(filename, 'rt');

% Check if the file was opened successfully
if fid == -1
    error('fca:apps:read_labels:fileOpenError', 'Could not open file: %s', filename);
end

% Read the file line by line
tline = fgetl(fid);
while ischar(tline)
    % Increment the count and add the line to the cell array
    label_count = label_count + 1;
    labels{label_count} = tline;

    % Read the next line
    tline = fgetl(fid);
end

% Close the file
fclose(fid);

% Display a message confirming the number of labels read
fprintf('Successfully read %d labels from %s\n', numel(labels), filename);

end
  

