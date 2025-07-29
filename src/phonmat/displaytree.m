function z = displaytree(x)

% x is a cell vector of cell/integer vectors.
% 

x = sorttree(x);
z = '';
firsts = [];
for i = 1:length(x)
%  z = strcat(z,'');
  for j = 1 : length(x{i})
    z = strcat (z,num2str(elem(x{i},j)),'\t');
  end;
  z = strcat(z,'\n\n');
  firsts(i) = elem(x{i},1);
end;

[y,i] = sort(firsts);



fprintf(z);

