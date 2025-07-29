function [a,b] = private_findindices (pm, varargin)
% PRIVATE_FINDINDICES private function to look up indices for a PHONMAT object
%
%	[aa,bb] = private_findindex (pm,a,b) or
%	[aa,bb] = private_findindex (pm,ab)  or
%	[aa,bb] = private_findindex (pm,x)  
%
%	a and b are integers or strings representing a phone.
%	If ab is used then it must be a 2-character string of onelabels, 
%	equivalent to a=ab(1), b=ab(2).
%
%       Alternatively, x is a cell array that is {ab} or {a,b}.
%      
%       aa,bb are integers corresponding to a,b that (if not 0) can be 
%       used as valid integers to index pm.mat. So if for instance 
%       a,b are integers, but out of range, aa,bb are 0.


  switch length (varargin)
  case 1
    ab = varargin{1};
    if iscell (ab)
       switch length (ab)
       case 1
         [a,b] = private_findindices (pm, ab{1});
       case 2
         [a,b] = private_findindices (pm, ab{1},ab{2});
       otherwise
         error ('wrong argument type');
       end
    elseif ischar(ab)
      if length(ab) == 2, 
        a = pm.labels (ab(1)); 
        b = pm.labels (ab(2));
      else
        error ('wrong argument type');
      end;
    else
      error ('wrong argument type');
    end
  case 2
    a = varargin{1};
    b = varargin{2};
    if ischar(a), a = pm.labels(a); end;
    if ischar(b), b = pm.labels(b); end;
  otherwise
    error ('wrong number of arguments');
  end;


n = pm.labels.size;
if a ~= range (a,1,n), a=0; end;
if b ~= range (b,1,n), b=0; end;
