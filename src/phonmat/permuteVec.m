function z = permuteVec(v)

% z = permuteVec(v)
%
% z is a permuted version of v.

L = length(v);
old = [1:L];
nu = [];
while length(old) 
   el = rand * length(old);
   pos = min (floor(el)+1, length(old));
   nu = [nu old(pos)];
   old = [old(1:pos-1) old(pos+1:length(old))];
end
z = v(nu);
