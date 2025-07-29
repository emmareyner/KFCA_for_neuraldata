function m = mutinfo (A)

% MUTINFO find mutual information of matrix 
%      m = mutinfo (A)
%
%      m is the mutual information of A

if ~isnumeric (A) | length (size(A)) > 2
   error ('input is not a 2d numeric matrix'); 
end;

hx = entropy (sum(A,1));
hy = entropy (sum(A,2));
hxy = entropy (A(:));
m = hx + hy - hxy;
