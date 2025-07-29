function set (pv, name, value)

% SET set some confmat object parameters. 
%
%  set (pm, name, value)
%
%  where name can be 'vec', 'title', 'labels',
%  value should be of the correct type - you're responsible for that. 
%  labels can be initialized with anything (eg charray of onelabels) that
%   can be used to initialize a LABELS object.

% NEED TO FIX THIS FUNCTION WITH MATLAB BOOK

  if ~ischar (name), error ('Parameter name must be char strings');  end
  name = lower (name);

  if strcmp (name, 'vec') | strcmp (name, 'vector')
    pv.vec = value;
  elseif strcmp (name, 'title')
    pv.title = value;
  elseif strcmp (name, 'labels')
    if isa (value, 'labels')
       pv.labels = value;
    else 
       pv.labels = labels (value);
    end;
  else
    error ('not supported');
  end;

assignin ('caller', inputname(1), pv);

