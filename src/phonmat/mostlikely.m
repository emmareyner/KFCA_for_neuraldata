function [list] = mostlikely (v, p)

% v is a Nx1 vector, where N is the number of detectors.
% v(i) is the probability that the i detector fired given that some phoneme was spoken
% list is the indices of the subset of v with the detectors whose prob of firing > p
% list has the indices i sorted in descending order of v(i)
% e.g. v = [0.54 0.49 0.92 0.63 0.12], p = 0.5 => list = [3 4 1].


[sorted,perm] = sort (v);
% perm(i) = j means that v(j) = sorted(i)
% perm is therefore a list of indices i sorted in descending order of v(i)

list_reverse = perm (find (v(perm)>=p));
for i = 1 : length(list_reverse)
    list(i) = list_reverse(length(list_reverse) - i + 1);
end;

