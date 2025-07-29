function updatedlabels = private_addlabels (existinglabels, newlabels)
% PRIVATE_ADDLABELS is a private function of class LABELS
% updatedlabels = private_addlabels (existinglabels, newlabels)
%
% existinglabels is a nx1 cell array, existinglabels{i} is a cell array of strings (each a label for the i-th phoneme)
% newlabels is a string of labels separated by whitespace. Each label not already in existinglabels
%  goes into the class of the last (nearest to it) predecessor (in newlabels) that is in existinglabels.
% e.g. if existinglabels = {{'p','P'}, {'t'}, {'D'}}, newlabels = 'blah z P pee t tee ti p pi D dh'
%      then updatedlabels = {{'p','P','pee','pi'},{'t','tee','ti'},{'D','dh'}}. 
%      Note how 'z' and 'blah' are discarded because nothing in newlabels before them was in existinglabels.


updatedlabels = existinglabels;
if ~length (newlabels), return; end;

nu = strread  (newlabels, '%s');           % now it is a cell array of strings e.g. altnames = {'%', 'p', 'pee','P','t','tee', 'd', 'dee'} 

current = 0;        % index of current phoneme for whom alternatives are being considered
for j = 1 : length (nu)
  i = private_findindex (existinglabels, nu{j});
  if i
    current = i;
  elseif current > 0
    updatedlabels{current} = append (updatedlabels{current}, nu{j});
  end;
end;
