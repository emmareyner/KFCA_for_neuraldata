function labels = private_makelabels (labelsstring)

% PRIVATE_MAKELABELS is a private function of class LABELS
% labels = private_makelabels (labelsstring)
% 
% labelsstring is of type char string, eg 'abde', in which case
% labels = {{'a'}, {'b'}, {'d'}, {'e'}}
% if labelsstring is not the right input type, labels = -1 is returned.

labels = {};
for i = 1 : length(labelsstring);
  labels{i}{1} = labelsstring (i);
end;

