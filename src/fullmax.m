function maxx = fullmax(A)

% A is ND array. maxx is min of all elements.

for n = 1 : length (size (A))
  A = max(A);
end;
maxx = A;
