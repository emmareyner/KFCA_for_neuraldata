function ind = coordconv (all, this)

% eg all = [3 2 4], means that there are 3*2*4 = 24 combinations, 
% Say x = [111 112 113 114 121 122 123 124 211 212 213 214 221 222 223 224 311
%   312 313 314 321 322 323 324]
% Then length(x) = 24
% ind is the index in x of this,
% eg this = [1 2 3], ind = 7 = (1-1)*(2*4) + (2-1)*4 + (3-1)*1 + 1
% eg this = [3 1 3], ind = 19 = (3-1)*8 + (1-1)*4 + (3-1)*1 + 1

if length(all) ~= length(this), 
  error ('coordconv: all and this are different length');
  return;
end;
ind = 1;
r = 1;
for i = length(all) : -1 : 1
  if i < length(all), r = r*all(i+1); end;
  ind = ind + (this(i)-1) * r;
end; 