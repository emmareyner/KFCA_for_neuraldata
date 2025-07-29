function H = entropy(p,total)

% p is a vector of nonnegative numbers.
% p ought to be a probability vector - if not, it is normalized by
% total (which if not provided is assumed to be its sum)

if nargin < 2
  p = probabilitize(p);
elseif total > 0
  p = p / total	;
else
  error ('entropy: weird inputs');
end;
H=0;
for i=1:length(p)
 if p(i)>0,  H = H - p(i)*log(p(i)); end;
end;
H = H/log(2);