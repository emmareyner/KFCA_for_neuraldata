function x = removeduplicates (x)

% x is a cell /number vector, possibly with duplicates.
% x could also be a single string with duplicates.
% z is x without the duplicates.
% note that allbut calls removeduplicates and viceversa

if length(x)
 if isnumeric(x)
  x = sort(x);
  a = lastelem(x);
  x = x(find(diff(x)));   
  if length(x)
    if a ~= lastelem(x), x=append(x,a); end;
  else
    x = [a];
  end;

 elseif iscell(x)
  removethese = [];
  i = 1;
  while i <= length(x)
    [zz,all] = findinvec (x(i+1:length(x)),x{i});
    x = allbuttheseindices (x,all+i,0);
    i = i + 1;
  end;

 elseif ischar (x)
  for i = 1 : length(x), tmp{i} = x(i); end;
  tmp = removeduplicates (tmp);
  x = '';
  for i = 1 : length (tmp), x = [x tmp{i}]; end;
 end;
else 
 x=[];
end;


