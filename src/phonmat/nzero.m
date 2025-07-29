function a = nzero (b)

% a has indices of b where b nonzero. b is 0-1 vector.
a = [];
for i = 1:length(b)
  if b(i)
    a = [a i];
  end;
end;
