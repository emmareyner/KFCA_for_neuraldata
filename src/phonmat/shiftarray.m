function Z = shiftarray(W,shift,padding);

% W is a M x N array. 
% shift = [a b] is a 2x1 vector.
% do the shift w(i) -> w(i+shift)
% In other words, Z(i) = W(i-shift)   % treating index as a vector
% fill in gaps with padding (=0 by default)

if nargin<3,padding=0;end;
[M N] = size(W);
Z = repmat (padding,size(W));
for j = range ([1:M]+shift(1),1,M)       % for each shifted row
  Z(j,:) = shiftvector (W(j-shift(1),:), shift(2), padding);
end;
