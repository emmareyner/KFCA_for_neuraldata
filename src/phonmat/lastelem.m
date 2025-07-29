function x = lastelem(z)

L = length(z);
if L
  if strcmp('cell',class(z)), x = z{L}; else x = z(L); end;
else
  x = '';
end;