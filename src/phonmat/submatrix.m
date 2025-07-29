function M = submatrix (A,subx,suby)

% e.g. A is a X x Y matrix
%   subx is a subvector of [1:X]
%   suby is a subvector of [1:Y]

if nargin < 3 & size(A,1) == size(A,2)
  suby = subx;
end;
[X,Y] = size(A);
subx = subx (subx <= X);
suby = suby (suby <= Y);
M = A(subx,suby);
