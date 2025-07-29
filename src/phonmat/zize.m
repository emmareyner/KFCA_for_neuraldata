function z = zize (A)

m = mean(A);
stdev = sqrt (var(A));

z = A - m;
if stdev
  z = z / stdev;
end;