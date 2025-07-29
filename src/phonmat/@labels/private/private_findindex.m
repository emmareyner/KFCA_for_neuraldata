function i = private_findindex (labels, item)
% PRIVATE_FINDINDEX is a private function of class LABELS
% i = private_findindex (labels, item)
%
% labels is a cell array; labels{i} is a cell array of strings (each a
%   label for the i-th phoneme)
% item is a string or an integer representing a phone
% i is the integer corresponding to the phone, or 0 if it's not valid.

i = 0;
if ischar (item)
 for j = 1 : length (labels)
  for k = 1 : length (labels{j})
    if strcmp (labels{j}{k}, item)
      i = j;
      break;
    end;
  end;
  if i, break; end;
 end;
elseif isnumeric (item)
 if item > 0 & item <= length(labels) & ~rem(item,1)
   i = item;
 end;
else
 error ('bad parameter');
end;