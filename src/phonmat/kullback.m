function d = kullback (p,q)

% p and q are both N x 1 probability vectors
% their Kullback-Leibler distance is returned (base of log = e)
% returns -1 if there is no i such that p(i) > 0 and q(i) > 0

p = probabilitize(asrow(p));
q = probabilitize(asrow(q));

N = length(p);
if N ~= length(q)
  error ('vectors not same length');
end;

nzero_p = find (p ~= 0);
nzero_q = find (q ~= 0);
nzero_both = findcommon (nzero_p, nzero_q);

if length (nzero_both) == 0
  d = -1; 
  return;
end;

d = 0;
for z = nzero_both
  d = d + p(z) * log ( p(z) / q(z) );
end;
