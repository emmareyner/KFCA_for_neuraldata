function subpm = sub (pm,sublabels,notetitle)

% SUB member function of class PHONMAT. Used to extract a submatrix.
%    subpm = sub (pm, slabels, [notetitle] )
%
%    pm is of type PHONMAT and slabels a k-long string 
%     with k onelabels of pm to be included in subpm.
%    The title of subpm is the same as that of pm, with possibly one difference.
%     If notetitle = 1, then information about the original set of
%     phones is added to the title of subpm. 
%     The dafault value of notetitle is 0 or 1 depending on whether
%     sublabels is simply a rearrangement of pm.labels or a proper
%     subset of it, respectively. 

if ~isa (pm, 'phonmat')
   error ('first argument should be of type PHONMAT')
elseif ~ischar (sublabels) 
   error ('second argument should be a string');
end;

% now make sure sublabels only has elements that are in pm.labels.
% where(i) has the index in pm.labels of where the i-th valid member
%   of sublabels is.

subpm = pm;
set (subpm, 'phones', sublabels);

subtitle = pm.title;

if nargin == 2
  notetitle = length (get(subpm,'phones')) ~= length (get(pm,'phones'));
end;

if notetitle
  subtitle = sprintf ('%s (EXTRACTED FROM MATRIX INVOLVING %s)',  pm.title, pm.labels.phones);
end;

set (subpm, 'title', subtitle);





