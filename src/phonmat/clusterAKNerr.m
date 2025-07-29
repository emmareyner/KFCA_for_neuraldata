function [z,chains] = clusterAKN (peaks, scores, ave)

% peaks is a Nx1 integer vector, with certain indices in scores where peaks are.
% scores is a Tx1 integer vector.
% ave is an integer representing the average length of the object detected.
% the z returned is a smaller version (subset) of peaks
%
% I assume peaks is in increasing order.

if ~length(peaks), z = []; return; end;

C0 = round(ave*1.0);
C1 = round(1.5 * ave);
chains = clusterAKNnoscores(peaks,C0,C1);

z = [];
for i = 1 : length(chains)
  [bestscore, bestj] = max (scores(chains{i}));
  z(i) = chains{i}(bestj);
end;

% --------------------------------------------------------------------------

function chains = clusterAKNnoscores (y, C0, C1)

% y has a list of indices of peaks.

y = sort(y);
dy = asrow (find (diff(y) > C0));
starts = [1 (dy+1)];
ends = [dy length(y)];

chains = {};
for i = 1 : length(starts)
  chains = joinvecs (chains, {y([starts(i) : ends(i)])});
end;






