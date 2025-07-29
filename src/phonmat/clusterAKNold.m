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

function chains = clusterAKNnoscores (y, C0, C1, verbose)

if nargin<4, verbose=0; end;

% y is a  vector of monotone incg (strict) integers.
y = sort(y);
L = length(y);
if ~L, z=[]; return; end;
chains = {[y(1)]};
c = 1;  % which chain you're in
for i = 2:L
  if y(i)-y(i-1) > C0, c = c+1; end;
  if length(chains) < c, chains{c} = []; end;
  chains{c} = append (chains{c},y(i));
end;

M = length(chains);
if verbose
 fprintf ('\nprinting chains after first step of clustering:\n\n');
 displaytree(chains);
end;

chains1 = chains;
chains = {};

for c = 1 : length(chains1)
  chopped = clusterAKNchop (chains1{c},C1);
%  chopped{:}
  chains = joinvecs (chains, chopped);
end;

if verbose
 fprintf ('\nprinting chains after second step of clustering:\n\n');
 displaytree(chains);
end;

% -----------------------------------------------------------


function pieces = clusterAKNchop (piece,C1)

% does second part of AKN's clustering procedure. 
% Only called by clusterAKN.m
% piece is a cell array of the form [43, 45, 59] 
% pieces = {[43,45],[59]} for example.

if lastelem(piece) - piece(1) <= C1
  pieces = {piece};
else
  longestlen = -Inf;          % piece{2} - piece{1};
  best_i = 1;
  L = length(piece);
  for i = 2 : L             % chop{1} has at least 3 elems if satisfied while condition.
    thislen = piece(i) - piece(i-1);
    if thislen > longestlen
      best_i = i;
      longestlen = thislen;
    end;
%    [best_i longestlen];
  end;

  % pieces are now 1:best_i-2, best_i-1:best_i and best_i+1:L

  midpiece = piece(best_i-1:best_i);
  pieces = {};  
  if best_i-2 > 1
    pieces = joinvecs ({midpiece}, clusterAKNchop (piece(1:best_i-2),C1)); 
  else 
    pieces = {midpiece};
  end;

  if best_i+1 <= L
    pieces = joinvecs (pieces, clusterAKNchop (piece(best_i+1:L),C1));
  end;
end;








