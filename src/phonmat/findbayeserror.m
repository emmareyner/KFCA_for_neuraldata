function [bestprob] = findbayeserror (A,B)

% A is a mx1 vector of integers
% B is a nx1 vector of integers
% bestprob is the bayes error - the amount of overlap between them.

p = min ( min(A), min(B) );
q = max ( max(A), max(B) );

if mean(A) < mean(B)
  tmp{1} = A; tmp{2} = B;
else   
  tmp{2} = A; tmp{1} = B;
end;
bestprob = 1;
step = (q-p)/1000;
for i = p-1 : step:q+1
  numlargerclassifiedassmaller = length (find (tmp{1}> i)); %/ length(tmp{1});
  numsmallerclassifiedaslarger = length (find (tmp{2}<=i)); % / length(tmp{2});
  prob = (numlargerclassifiedassmaller + numsmallerclassifiedaslarger) / (length(tmp{1}) + length(tmp{2}));
  if bestprob > prob
    bestprob = prob;
  end;
end;  
