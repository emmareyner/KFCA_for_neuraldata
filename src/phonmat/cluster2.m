function z = cluster2 (peaks, score, close)

% score is a Tx1 array of integers, representing detector outputs at different times.
% close is a small integer
% peaks is a subset of [1:T] showing where some peaks in the utterance are.
% z is a subset of peaks, the ones removed were within close time units of a higher scoring peak.

if nargin < 3, close=0; end;
if ~close, z = peaks; return; end;
peaks = sort(peaks);
T = length (score);
N = length (peaks);
removetheseindices = [];     % these may well have repetitions when we're done.
same = {};

for n = 1 : N
%  common = findcommon ( find(peaks <= peaks(n) + c), find(peaks > peaks(n)));          % indices of peaks that are within peaks(n)+1 and peaksn(n)+c inclusive 
  a = find (peaks <= peaks(n) + close);
  common = [n+1:lastelem(a)];

  if length (common)
    [maxinvicinity,a] = max (score(common));
    if maxinvicinity > score(peaks(n))
      removetheseindices = append (removetheseindices, n);
    else                                                           %in case of equality -- we'll keep just the first occurence. 
      removetheseindices = joinvecs (removetheseindices,common);
    end;
  end;
end;

z = allbut (peaks, removetheseindices);



