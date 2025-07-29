function x = probabilitize (A,dim)

% if A is a vector, x is A/sum(A)
% if A is a N-dim matrix, and dim is a subvector of [1:N]
% A is probabilitized across the dimensions in dim.
% Right now only works for N=2 and length(dim)=1.

if ~length(A),
  x = [];
elseif min(size(A)) == 1
  x = A/sum(A);
elseif length(size(A)) == 2   
  if nargin < 2, dim = 1; end;
  [R,C] = size(A);
  if dim == 1        % probabilitize each row
    for r=1:R, x(r,:) = probabilitize(A(r,:));end;
  elseif dim == 2
    for c=1:C, x(:,c) = probabilitize(A(:,c));end;
  end;
end;
    
    
  