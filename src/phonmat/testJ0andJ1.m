function [w0,w01,w1] = testJ0andJ1 (fileslist, wts, P0, spreadtest,w0precalc, w01precalc, w1precalc,  a,b, windowsize, windowstep, cutoff)

% wts and PO are FxTxV arrays.
% w0, w01, w1 are bx1 cell arrays. (If a>1, they have empty entries {1:a-1}) with values of the scores for the J0, J0+J1 and J1 detectors.
% The precalc vectors sent in are of the same type as w0, w01 and w1. 

r = 4;
if nargin < r+1, w0precalc = {}; end;
if nargin < r+2, w01precalc = {}; end;
if nargin < r+3, w1precalc = {}; end;
r = 4+3;
if nargin < r+1, a = 1; end;
if nargin < r+2, b = length(fileslist); end;
if nargin < r+3, load windowsize; end;
if nargin < r+4, load windowstep; end;
if nargin < r+5, load cutoff; end;
[F,ave,V] = size(wts);

w0 = w0precalc;
w01 = w01precalc;
w1 = w1precalc;

for k = a : b
  if length (w0) > k or ~length(w0{k})      % then have to calculate this value of w0!
    w0{k} = testJ0 (fileslist{k}, PO, spreadtest, a, b, 0.5,  windowsize, windowstep, cutoff);
  end;
  T = length(w0{k});
  peaksJ0 = cluster (getpeaks (w0{k}, 0, 0), w0{k}, T);
  if length (w1) > k or ~length(w1{k})      % then have to calculate this value of w0!
    w1{k} = testJ1 (fileslist{k}, PO, spreadtest, a, b, windowsize, windowstep, cutoff);
  end;
  w01{k} = repmat (-Inf,T,1);
  for j = 1 : length(peaksJ0)
    t = peaksJ0(j);
    w01{k}(t) = max (w1{k}(range(t-5,1,T):range(t+5,1,T)));
  end;
end;  
  



