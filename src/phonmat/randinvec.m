function z = randinvec(v,K,distn)

% z = randinvec(v,[K,distn])
% z is K different random elements of v.
% k is 1 by default
% v is a nonempty vector of length, say, L.
% K is a integer between 1 and L.
% distn is optional, and is a vector of length L.
%   distn(i) = probability with with v(i) should be chosen.
%
% The only ambiguous case is two arguments are given
%  and we cant work out if the second is K or distn.
%  But that can only happen if v is a vector of 1, 
%  in which case K would have to be 1 and there's no
%  ambiguity.

L = length(v);
if nargin<1, error('not enough arguments'); end
if nargin<2, K=1; end
if nargin<3, 
  if length(K) > 1
    distn = K;
    K=1; 
  else
    distn=ones(1,L);
  end
end


if ~L
  error ('cannot use randinvec on empty vector');
end
if K > L
  fprintf (1,'randinvec: asking to get %d random entries from a %d-long vector\n',K,L);
  error ('cannot ask for more entries than possible');
end
if ~sum(distn) 
  error ('distribution cannot sum to zero!');
end
if length(find(distn<0))
  error ('distribution cannot have negative numbers!');
end

distn = probabilitize(distn);
cumdistn = cumsum(distn);

z_indices = [0];
for k = 1 : K
  a = 0;
  while findinvec (z_indices,a)
    r = rand;
    a = min (find (cumdistn>r));
  end
  z_indices(k) = a;
  z(k) = v(a);
end










