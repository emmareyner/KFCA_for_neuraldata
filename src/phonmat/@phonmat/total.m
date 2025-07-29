function total (pm)

% TOTAL displays a given PHONMAT object with a column of totals
%      total (pm)

init = '    ';      % initial spacing

fprintf('\n');

fprintf (1,' %s (object of type PHONMAT) = \n', inputname(1));
fprintf (1,'\n');
fprintf (1,'%stitle: %s\n', init, pm.title);

lab = pm.labels;
n = lab.size;

if n
  fprintf (1,'%sPhones involved: %d, namely ', init, n)
  for i = 1 : n
    fprintf (1, '%s ', lab{i});
    AlternativeLabels = altlabels (lab, i);
    A = length (AlternativeLabels);
    if A
      fprintf (1, '(');
      for j = 1 : A
        fprintf (1, '%s', AlternativeLabels{j});
        if j < A, fprintf (1, ' '); end;
      end;
      fprintf (1, ') ');
    end;
  end;
  fprintf (1, '\n\n');
  


  % print headings for matrix
    
  maxF = 0;          % maximum number of digits in any element (ie frequency) of pm.mat
  for i = 1:n, for j = 1:n, maxF = max (maxF, length (num2str (pm.mat(i,j)))); end; end;

  fprintf (1, '%s  ', init);
  for j = 1:n, fprintf (1, ' %s', formatstring(lab{j}, maxF)); end;
  fprintf (1, '    Total\n');

  % now print matrix...

  for i = 1 : n                       % for each row of the matrix
    fprintf (1, '%s%s ',init, lab{i});
    for j = 1:n, fprintf (1, ' %s', formatstring (pm.mat(i,j), maxF));    end;
    fprintf (1, '  %s',lab{i});
    fprintf (1, ' %d\n', sum(pm.mat(i,:)));
  end;      
else 
  fprintf (1, '<empty>\n');
end

fprintf('\n');
