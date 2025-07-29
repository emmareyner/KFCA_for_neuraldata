function newM = permcols (M)

% M = permcols (M)
% 
% randomly permutes the columns of a 2-dim matrix

newM = (permrows(M'))';