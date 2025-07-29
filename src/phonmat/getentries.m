function v = getentries (A,symignorediag)

% A is a 2d numeric matrix
% symdiag is 'sd, 's', 'd' or ''
% v is a single vector with the entries in A...
%   if symignorediag has 's', then A is symmetric so only half its entries are got
%   if symignorediag has 'd', then the diagonals of A are ignored, ie not included in v

if nargin < 2, symignorediag = ''; end;
sym = findinvec (symignorediag, 's');
nodiag = findinvec (symignorediag, 'd');

v = [];
for i = 1 : size(A,1)
  for j = 1 : size (A,2)
    if nodiag & i==j, continue; end;
    if sym    & i>j,  continue; end; 
    v (length(v)+1) = A(i,j);
  end;
end;
 