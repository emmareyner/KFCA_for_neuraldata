function minn = fullmin(A)

% FULLMIN returns minumum of all elements in an arbitrary-dimensional matrix A.
%     minn = fullmin(A)
% 
%     A is a N-dimensional array. 
%     minn is minimum of all elements.

minn = A;
for n = 1 : length (size (minn))
  minn = min(minn);
end;
