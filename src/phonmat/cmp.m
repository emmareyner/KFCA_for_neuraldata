function same = cmp(a,b)

% a and b are both numbers or of type char...

if ischar(a) & ischar(b)
  same = strcmp (a,b);
else 
  same = a == b;
end;