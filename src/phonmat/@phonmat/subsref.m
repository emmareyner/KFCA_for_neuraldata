function x = subsref (pm,s)

% SUBSREF subcripted reference (parentheses or curly braces) for class PHONMAT.
%   Can be called using (), {} or .
%
%   1) x = pm(a,b) or pm(ab) has the (a,b)-th entry of pm.mat
%
%      pm is a PHONMAT object 
%      a and b are integers or strings representing a phone.
%      If ab is used then it must be a 2-character string of onelabels, equivalent to a=ab(1), b=ab(2).
%
%      if a,b are out-of-range numbers or strings that aren't phone labels, an error is thrown.
%
%   2) X = pm{a,b} or pm{ab} is a 2x2 matrix with the [aa ab; ba bb] entries of pm.mat
%      
%      The same comments about a,b in 1) apply.
%
%   3) pm.field is the same as calling get (pm, field)
%
%  If diagentry = '' (or is any character, then NOTHING HAPPENS (MAY NEED TO CHANGE THIS)

if strcmp (s.type,'()') | strcmp (s.type,'{}')

  switch length (s.subs)
  case 1
    [a,b] = private_findindices (pm,s.subs{1});
  case 2
    [a,b] = private_findindices (pm,s.subs{1},s.subs{2});
  otherwise
    error ('wrong number of arguments');
  end;
  
  n = pm.labels.size;
  if ~a, error ('first argument is not a valid phone'); end;
  if ~b, error ('second argument is not a valid phone'); end;

  x = pm.mat(a,b);
  if strcmp (s.type, '()') 
    if pm.symmetric & a ~= b
      
      X1 = pm.mat(min(a,b),max(a,b));
      X2 = pm.mat(max(a,b),min(a,b));
      x = X1;
      if private_eq (X1, pm.default) 
        x = X2;
      end;

    end;
    if ~pm.hasdiag & a == b
      x = NaN;
    end;
    if abs(x) < pm.smallest
      x = 0;
    end;

  elseif strcmp (s.type, '{}') 
    ss.type = '()'; 
    K = [a b];
    x = zeros(2);
    for i = 1 : 2, for j = 1 : 2, 
      ss.subs = {K(i), K(j)};
      x (i,j) = subsref (pm, ss);
    end; end;
  end;
else               % s.type must be '.'
  x = get (pm, s.subs);
end;





