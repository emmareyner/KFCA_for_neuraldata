function a = eqvec(x,y)

% x, y are row vectors of the same size
% a = 1 if they are equal, 0 else

%a = prod (eq (x,y));

a = (length(x) == length(y)) & x == y;