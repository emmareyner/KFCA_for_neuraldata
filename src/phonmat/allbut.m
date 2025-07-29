function z = allbut (x,togo,hasdups)

% x is a Nx1 cell or number vector. 
% togo is vector of elements, possibly with duplicates, all occurrences of which must be removed from x.
% if hasdups = 0 then togo has no duplicates.

if nargin < 3, hasdups = 1; end;


if hasdups, togo = removeduplicates(togo); end;
for i=1:length(togo)
  if ~length(x), break; end;
  x = x(find(x~=elem(togo,i)));
end;
z = x;

%removetheseindices = [];
%for i=1:length(togo), removetheseindices = joinvecs(removetheseindices, find(x==elem(togo,i))); end;
%z = allbuttheseindices(x,removetheseindices,0);


