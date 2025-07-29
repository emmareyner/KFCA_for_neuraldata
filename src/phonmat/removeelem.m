function z = removeelem (x, elem)

% z = x with elem removed, if it was there in the first place.

%[y,removeme] = findinvec (x,elem);
z = allbut (x,elem);
