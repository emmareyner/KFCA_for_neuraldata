function [z] = shiftarray(w,shift,padding);
% w is a 1 x N array. 
% shift is a number, positive or negative
% do the shift w(i) -> w(i+shift), i.e. 
%  z(i) = w(i-shift)
% fill in gaps with padding (=0 by default)

if nargin<3,padding=0;end;
N = length(w);
z = repmat (padding, size(w));
for i = range ([1:N]+shift,1,N)
  z(i) = w(i-shift);
end;

