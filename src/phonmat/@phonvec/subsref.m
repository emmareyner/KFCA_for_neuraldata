function x = subsref (pm,a)

% SUBSREF subcripted reference (parentheses or curly braces) for class PHONMAT.
%   Can be called using (), {} or .
%
%   1) x = pm(a)  a-th entry of pm.vec
%
%      pm is a PHONMAT object 
%      a is an integer, or string representing a phone.
%       If it's an out-of-range number, or strings that's not among the phone labels, an error is thrown.
%
%   2) X = pm{a} -- just like pm(a), but a probability is returned. 
%
%   3) pm.field is the same as calling get (pm, field)

if strcmp (a.type,'()') | strcmp (a.type,'{}')
  L = pm.labels;
  b = L(a.subs{1});
  if b
    v = pm.vec;
    if strcmp (a.type,'{}')
       v = probabilitize (v);
    end;
    x = v(b);
  else
    error ('out of range / invalid phone supplied');
  end;
else                            % a.type must be '.'
  x = get (pm, a.subs);
end;





