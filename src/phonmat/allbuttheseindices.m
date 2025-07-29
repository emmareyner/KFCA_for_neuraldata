function z = allbuttheseindices (x,indicestogo,hasdups)

% x is a Nx1 cell or number vector. 
% indicestogo is a subset of [1:N]. It may have duplicates. (default checks for duplicates)
% z is x except for x(indicestogo)
% note that allbut calls removeduplicates and viceversa
% if hasdups = 0 then indicestogo has no duplicates.

if nargin < 3, hasdups = 1; end;
if hasdups, indicestogo = removeduplicates(indicestogo); end;
z = x(complement(indicestogo,length(x),0));

