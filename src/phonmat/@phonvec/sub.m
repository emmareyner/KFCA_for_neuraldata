function subpv = sub (pv,sublabels,notetitle)

% SUB member function of class PHONMAT. Used to extract a submatrix.
%    subpv = sub (pv, slabels, [notetitle] )
%
%    pv is of type PHONVEC and slabels a k-long string 
%     with k onelabels of pv to be included in subpv.
%    The title of subpv is the same as that of pv, with possibly one difference.
%     If notetitle = 1, then information about the original set of
%     phones is added to the title of subpv. 
%     The dafault value of notetitle is 0 or 1 depending on whether
%     sublabels is simply a rearrangement of pv.labels or a proper
%     subset of it, respectively. 

if ~isa (pv, 'phonvec')
   error ('first argument should be of type PHONVEC')
elseif ~ischar (sublabels) 
   error ('second argument should be a string');
end;
subpv = pv;

% now make sure sublabels only has elements that are in pv.labels.
% where(i) has the index in pv.labels of where the i-th valid member
%   of sublabels is.

if iscell (pv.vec)
  subvec = {};
else
  subvec = [];
end;

sublabels_valid = '';               % sublabels that already exist.

for n = 1 : length (sublabels)
  a = pv.labels ( sublabels(n) );
  if a > 0
     sublabels_valid = [sublabels_valid sublabels(n)];
     subvec = append (subvec, elem (pv.vec, a));
  end;
end;

set (subpv, 'labels', labels (sublabels_valid));
set (subpv, 'vec',    subvec);

subtitle = pv.title;

if nargin == 2
  SL = subpv.labels;
  L = pv.labels;
  notetitle = (SL.size ~= L.size);
end;

if notetitle
  subtitle = sprintf ('%s (EXTRACTED FROM VECTOR INVOLVING %s)',  pv.title, pv.labels.phones);
end;

set (subpv, 'title', subtitle);





