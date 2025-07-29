function newM = permrows (M)
 
% M = permrows (M)
% 
% randomly permutes the rows of a 2-dim matrix


[R,C] = size(M);
nurows = permuteVec ([1:R]);
for r = 1 : R
  newM (r,:) = M (nurows(r),:);
end
