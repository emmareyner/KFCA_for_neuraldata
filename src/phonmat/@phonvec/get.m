function varargout = get (pv, varargin)

% GET get PHONVEC object parameters. Takes N+1 inputs (including pv)
%  and returns n outputs. The calling program should have n variables
%  available to take the outputs, eg if N=3:
%    [a,b,c] = get (pvobject, namea, nameb, namec)
%  The names can be 
%    'vec'/'vector'  :   phone vector
%    'probs'         :   probabilitized vector
%    'title'         :   name of matrix, hopefully with some info on where it came from
%    'labels'        :   the phone labels used (of type LABELS)
%    'phones'	     :   the phone labels used (a string)

if (nargout + (nargout == 0)) ~= nargin-1
  error ('mismatch between number of inputs and outputs');
end;

for i = 1 : nargin - 1
    name = varargin{i};
    if ~ischar (name)
       error ('Parameter names must be strings');
    end;
    switch name
     case {'vec','vector'}
      varargout{i} = pv.vec;
     case {'probs','prob'}
      varargout{i} = probabilitize (pv.vec); 
     case 'title'
      varargout{i} = pv.title;
     case 'labels'
      varargout{i} = pv.labels;
     case 'phones'
      L = pv.labels;
      varargout{i} = L.phones;
     otherwise
      error (sprintf('Parameter name "%s" not known', name));
     end
end
  

