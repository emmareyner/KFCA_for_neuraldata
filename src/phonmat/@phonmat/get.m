function varargout = get (pm, varargin)

% GET get PHONMAT object parameters. Takes N+1 inputs (including pm)
%  and returns n outputs. The calling program should have n variables
%  available to take the outputs, eg if N=3:
%    [a,b,c] = get (pmobject, namea, nameb, namec)
%  The names can be 
%    'mat'/'matrix'  :   phone matrix
%    'title'         :   name of matrix, hopefully with some info on where it came from
%    'labels'        :   the phone labels used (of type LABELS)
%    'phones'        :   the onelabels used, same as calling pm.labels.phones
%    'allphones'     :   all labels used,    same as calling pm.labels.allphones
%    'size'          :   number of onelabels
%    'hasdiag'       :   boolean flag saying whether diagonal entries are meaningful (1 means yes)
%    'symmetric'     :   boolean flag saying whether matrix is symmetric (1 means yes)
%    'smallest'      :   nonnegative value. Any value whose magnitude is below it is considered to be zero
%    'dp'            :   number of decimal places used in displaying
%    'default'       :   default value of matrix entries
%    'total'         :   displays matrix with totals
%    'list'          :   returns list of meaningful matrix entries. If matrix is symmetric, only 
%                        about half its entries are returned. If diagonal entries are meaningless,
%			 they are not returned.			 

if (nargout + (nargout == 0)) ~= nargin-1
  error ('mismatch between number of inputs and outputs');
end;

for i = 1 : nargin - 1
    name = varargin{i};
    if ~ischar (name)
       error ('Parameter names must be strings');
    end;
    switch name
     case {'mat','matrix'}
      varargout{i} = pm.mat;
     case 'title'
      varargout{i} = pm.title;
     case 'labels'
      varargout{i} = pm.labels;
     case 'size'
      varargout{i} = size(pm.mat,1);
     case 'phones'
      L = pm.labels;
      varargout{i} = L.phones;
     case 'allphones'
      L = pm.labels;
      varargout{i} = L.allphones;
     case 'hasdiag'
      varargout{i} = pm.hasdiag ~= 0;
     case 'symmetric'
      varargout{i} = pm.symmetric ~= 0;
     case 'default'
      varargout{i} = pm.default;
     case 'dp'
      varargout{i} = pm.dp;
     case 'smallest'
      varargout{i} = pm.smallest;
     case 'list'
      varargout{i} = list (pm);
     case 'total'
      total (pm);
      varargout{i} = 1;
     otherwise
      error (sprintf('Parameter name "%s" not known', name));
     end
end
  

