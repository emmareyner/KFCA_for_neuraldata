function z = z-ize (A)

m = mean(A);
stdev = sqrt (var(A));

z = A - m;
if v
  z = z / stdev;
end;