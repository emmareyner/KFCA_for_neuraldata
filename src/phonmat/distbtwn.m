function z = distbtwn (a,b,c,d)

% DISTBTWN distance between contiguous 1-d vectors
%
%   z = distbtwn (a,b,c,d)
%
%   [a b] and [c d] are both contiguous ?x1 vectors
%   a,b,c,d are assumed to be all integers. 
%   If they overlap by a, z equals -a.
%   Otherwise, z is the shortest distance from [a b] to [c d]
%
%   This can never return 0 as a valid value e.g. 
%     [1 10] and [-5 1] overlap by 1   (so z = -1)
%     [1 10] and [-5 0] differ by 1-0  (so z = 1)

overlap = (b-a+1+d-c+1) - (length (removeduplicates ([a:b c:d])));
if overlap > 0
  z = -overlap;
else
  z = min ( abs ([ a-[c d] b-[c d] ]) );
end;
