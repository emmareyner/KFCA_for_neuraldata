function varargout = get (lab, varargin)

% GET get LABELS object parameters. Takes N+1 inputs (including lab)
%  and returns n outputs. The calling program should have n variables
%  available to take the outputs, eg if N=3:
%    [a,b,c] = get (lab, namea, nameb, namec)
%  The names can be 'data' (cell array of labels), 'phones' (string
%  with onelabels in lab), 'allphones' (string with onelabels and altlabels)
%  or 'size' (number of phones in lab)

if (nargout + (nargout == 0)) ~= nargin-1
  error ('mismatch between number of inputs and outputs');
end;

for i = 1 : nargin - 1
    name = varargin{i};
    if ~ischar (name)
       error ('Parameter names must be strings');
    end;
    switch name
     case {'data'}
      varargout{i} = lab.data;
     case 'phones'
      varargout{i} = private_phones(lab);
     case 'allphones'
      varargout{i} = private_allphones(lab);
     case 'size'
      varargout{i} = length (lab.data);
     otherwise
      error (sprintf('Parameter name "%s" not known', name));
     end
end
