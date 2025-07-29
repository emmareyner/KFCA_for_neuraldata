function z = sorttree(x)

% x is a cell vector of cell/integer vectors eg {{4,5,6},{10,13,14}}
% or {[4 5 6], [10 13 14]}. All the elements at the second level are 
% monotone increasing, but not at the first level, which is what we want
% to sort out. 

firsts = [];
for i = 1:length(x)
  firsts(i) = elem(x{i},1);
end;
[y,I] = sort(firsts);

z = {};
for i = 1 : length(x)
  z{i} = x{I(i)};
end;
