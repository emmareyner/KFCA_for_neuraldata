function n = private_isgoodmatrix(S)

% PRIVATE_ISGOODCONFMATRIX is a private function of class confmat
% n = private_isgoodmatrix (S)
%
% Confusion matrices are meant to be n x n numeric arrays
% This returns n if S is such, and -1 otherwise.
%  Note that S may be empty, in which case it is valid, and 0 (its
%  size) is returned.

n = -1;
if (isnumeric (S)) & (length(size(S)) == 2) & (size(S,1) == size(S,2)) 
  n = size (S,1);
end;
