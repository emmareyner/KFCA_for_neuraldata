function peaks = getpeaks (scores, thresh)

% scores is a vector of L numbers (or a cell array, in which case its first element should be the requisite numeric vector)
% peaks has the indices of scores (which cannot be 1 or L) where there is a peak in score. There is a peak at time t if
%   scores(t) >= scores(t-1)    and     scores(t) >= scores(t+1)       and scores(t) >= thresh.

if iscell(scores), s=scores{1};  else s = scores;  end;
if nargin < 2, thresh = min(s); end;
L = length(s);
d = diff (s);

% d(t) = scores(t+1) - scores(t), so the above condition for a peak at t becomes 
%    d(t-1) >= 0    and    d(t) <= 0    and   scores(t) >= thresh

peaks = find (d(1:L-1)<=0 & s(1:L-1)>=thresh)';
peaks = peaks (peaks>1);
peaks = peaks (d(peaks-1)>=0);

