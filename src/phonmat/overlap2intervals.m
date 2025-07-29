function overlap = overlap2intervals (a,b,a1,b1)

% o is the amount of overlap between [a,b] and [a1,b1].
 
if b<a | b1<a1, overlap=0; return; end;
if a > a1
  if a > b1, 
    overlap = 0;
  else
    overlap = min(b1,b) - a + 1;
  end;
else  % a <= a1
  if b < a1
    overlap = 0;
  else
    overlap = min(b1,b) - a1 + 1;
  end;
end;
  
