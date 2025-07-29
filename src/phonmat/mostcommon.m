function [list,sumprob] = mostcommon (v, p)

% v is a vector of probabilities, and p is a number between 0 and 1.
% list is the smallest set {i_1,...,i_k} such that sumprob = sum_{j=1:k} v(i_j) > p

[sorted, orig] = sort(v);

% sorted is the sorted version of v
% orig(k) = i means that v(i) = sorted(k)

sumprob = 0;
list = [];
for k = length(v):-1:1
    if sumprob > p | length(list) > 12
       break;
    end;	
    sumprob = sumprob + sorted(k);
    list = [list orig(k)];
end;


