function a = altlabels (lab, onelabel)

% ALTLABELS returns altlabels for a given onelabel in a LABELS object
%      a = altlabels (lab, onelabel)
%
%      lab is of type LABELS
%      onelabel is of type char or an integer
%      a is a cell array of strings, each an alternative label for onelabel

dat = lab.data;
i = private_findindex (dat, onelabel);
a = {};
for j = 2 : length (dat{i})
  a = append (a, dat{i}{j});
end;