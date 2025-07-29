function [bins,maxbin] = suggesthistparameters (A)

% SUGGESTHISPARAMETERS
%
%           bins = suggesthistparameters (A)
%
%		A is a numeric vector
%		We want to find out suitable parameters for it
%		- a list of bins
%		- maximum height of a bin, rounded to the nearest 10.

n = length(A);
a = min(A);
b = max(A);
span = b-a;

if a < 0
  a = - round10 (-a);
else
  a = round10 (a, 1);
  if a <= 0.1, a = 0; end;
end;

if b < 0
  b = - round10 (-b, 1);
else
  b = round10 (b);
end;


numbins = 10;
binsize = (b-a) / numbins;
bins = [a : binsize : b];

n = hist (A, bins);
maxbin = max(n);
maxbin = round10 (maxbin);

