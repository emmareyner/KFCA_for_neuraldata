function [z,heavier] = comparebinaryvectors (a,b)

% a,b are both binary Tx1 vectors, of the same length
% z is between 0 and 1. 1 means very similar, 0 means never similar.
% correction: this only counts the number of places where they are 1,
% since both are expected to be sparse vectors.
% heavier = 0 if a has more 1s than b, else 1. 2 if both are zero-only

k = length(a);

suma = sum(a);
sumb = sum(b)
heavier = sumb > suma;
if heavier & ~sumb
  heavier = 2;
end;
sumlighter = min (sumb, suma);
if sumlighter
  z = sum ( a == b & a) / sumlighter;
else 
  z = suma == sumb;     % if both are allzero, they are the same.
end;

