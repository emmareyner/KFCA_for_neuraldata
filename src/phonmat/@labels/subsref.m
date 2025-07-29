function x = subsref (lab,s)
 
% SUBSREF subcripted reference (parentheses or curly braces) for class LABELS
%   Can be called in one of three ways, see below. lab is of type LABELS.
%
%   x = lab(a), where a is a string or number representing a phone.
%           x is the corresponding integer label for it, or 0 if a doesnt
%           not represent a valid phone.
%   x = lab{a}, where a is a string or number representing a phone.
%           x is the corresponding onelabel for it, or '' if a doesnt
%           not represent a valid phone.
%   x = lab.phones, x is a string with the onelabels in lab.
%   x = lab.allphones, x is a string with all labels in lab.
%   x = lab.size, x is the number of onelabels in lab
%   x = lab.data, x is the data structure used to store labels, which is
%       a cell array; x{i} is a cell array of strings used to represent
%       the i-th phone. x{i}{1} has its onelabel, x{i}{2:?} its altlabels.

% BUG: fails to deal with something like x.data{:} when x of type LABELS

if strcmp (s.type,'()') | strcmp (s.type, '{}')
   if length(s.subs) ~= 1, 
      error ('only takes one argument');
   end;
   if ischar(s.subs{1})
      x = private_findindex (lab.data, s.subs{1});
   elseif isnumeric(s.subs{1})
      x = s.subs{1};
      if x ~= range (x, 1, length(lab.data))
        x = 0;
      end;
   else
      error ('argument in {} must be string or number');
   end;
   if strcmp (s.type,'{}')
      if x
        x = lab.data{x}{1};
      else
        x = '';
      end
   end;
else    
  x = get (lab, s.subs);
end;


