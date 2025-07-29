function s = vectorsummary (x)

% x is a number/cell vector 
% s is a string with x's contents.

s = '[';
for i = 1 : length(x)
  s = strcat (s, num2str (elem(x,i)));
  if i < length(x)
    s = strcat (s, ' . ');
  else
    s = strcat(s,']');
  end;
end;
