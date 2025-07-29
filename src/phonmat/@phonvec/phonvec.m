function pv = phonvec (varargin)
%
% PHONVEC User-defined class originally designed to help with manipulation 
%   of phoneme data, hence the name. Can be used like an associative array.
%
%   (Author: Dinoj Surendran dinoj@uchicago.edu)
% 
% The class has the following fields:
%
%  pv.labels is of type LABELS and has the n labels involved here
%  pv.vec is a nx1 cell vector , with vec{i}/(i) corresponding to 
%     labels(i), i=1...n
%  pm.title is a string with the name of this matrix
%
% Can be initialized with (other than default, copy constructors)
% 
%  PV = phonvec (L,V,T), where L is a labels object, V a vector (both
%   with n entries) and T a title set to '' if not supplied. L can also
%   be a n-long string of one-labels.
%
%  PV = phonvec (infile), where infile is of the following form. The first line
%    may have a title if its first character is a %. 
%    Each succeeding line has a 1-label and a frequency value only.  
%
%  PV = phonvec (x), where x is a struct corresponding to a phonvec object
%    when saved as part of a .mat file. 


pv.vec = [];
pv.labels = labels;
pv.title = '';

pv = class (pv, 'phonvec');   

switch (nargin)
 case 0                        % default constructor

  return;
  
 case 1
  a = varargin{1};

  if ischar (a)               % must be a filename
    if ~exist(a), error (sprintf ('file %s not found',a)); end;
    [L,V,T] = loadfile (a);
    pv.vec = V;
    pv.labels = labels(L);
    pv.title = T;
    return;
  elseif isa (a, 'phonvec')                      % copy constructor
    pv.vec = a.vec;
    pv.labels = a.labels;
    pv.title = a.title;
    return;
  elseif isa (a, 'struct')                       % assume it is the underlying struct
     FIELDS = fieldnames (a);
     if length(FIELDS)==3 & cmp(FIELDS{1},'vec') & cmp(FIELDS{2},'labels') & cmp(FIELDS{3},'title')
       pv.vec = a.vec;
       pv.labels = labels (a.labels);
       pv.title = a.title;
       return
     else
       error ('constructor called with a struct not formed originally from a phonvec object');
     end
  else
     error ('constructor called with wrong type');
  end;

 case 2                                      % constructor with two arguments (L,V), where L is a labels object or nx1 charray.
  tmp = varargin{1};

  if isa (tmp, 'labels') & (tmp.size == length (varargin{2}))
       pv.labels = varargin{1};
       pv.vec = varargin{2};
       return;
  elseif isa (varargin{1}, 'char') & (length(tmp) == length (varargin{2}))
       pv.labels = labels (varargin{1}) ;
       pv.vec = varargin{2};
       return;
  else       
    error ('constructor called with wrong type / or arguments do not match up');
  end;

 case 3                                                % constructor with three arguments can only be L,V,T.

  if ischar (varargin{3})
    pv = phonvec (varargin{1}, varargin{2});
    pv.title = varargin{3};
    return;
  else
    error ('constructor called with wrong type');
  end;

 otherwise

  error ('wrong number of arguments');
end;



function [onelabels,vecc,titl] = loadfile (filename)
 
% reads a file with two columns, first with one-labels, and second with numbers

line1 = readline (filename, 1);
firstlineistitle =  line1(1) == '%';           % 1 or 0
alllines = textread (filename, '%s', 'commentstyle', 'c', 'headerlines', firstlineistitle, 'delimiter', '\n' );
titl = '';
if firstlineistitle
  titl = line1 (2 : length(line1));
end;
       
onelabels = '';
vecc = [];

for i = 1 : length (alllines)
  % last line may be empty

  if ( (length(alllines{i}) == 0) | (alllines{i}(1) == ' ') | (alllines{i}(1) == '\t')  |  (alllines{i}(1) == '\n') )
    continue;
  end;

  [OL, VL] = strread ( alllines{i}, '%s%f\n', 'delimiter', ' \t');
  if iscell (OL), OL = OL{1}; end;
  if iscell (VL), VL = VL{1}; end;
  vecc = [vecc VL];
  onelabels = [onelabels OL];
end;
