function c = contains (element, cellarray)

% returns 1 if cellarray contains element, else 0

c = 0;
[x,L] = size(cellarray);
if L
  i = 0;
  while i < L & ~c
    i = i+1;
    c = strcmp (cellarray(i), element);
  end;
end;
