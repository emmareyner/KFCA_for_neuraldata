function display(pm, maxdp)
% DISPLAYs contents of pm, which is of type PHONMAT

if nargin < 2, maxdp = 4; end;
init = '    ';      % initial spacing

fprintf('\n');

fprintf (1,' %s (object of type PHONMAT) = \n', inputname(1));
fprintf (1,'\n');
fprintf (1,'%stitle: %s\n', init, pm.title);
n = size(pm.mat,1);

% determine how many characters NCHAR you want to allocate each element in the table
% This is taking too much time to load. 

M = pm.mat / (10^pm.dp);



[B,A] = decimalplaces (M);
maxbefore = fullmax (B);
maxafter  = min (maxdp, fullmax (A));

NCHAR = maxbefore + 1 + maxafter;
blank = repmat ('.', 1, NCHAR);

inbtwn =  '  ';         % spacing in between entries
entries = {};           % entries{i,j} has the string with the (i,j)-th entry

S.type = '()';
for i = 1:n
  for j = 1:n
     if (i > j & pm.symmetric) | (i == j & ~pm.hasdiag)
        entries{i,j} = blank;
     else
        S.subs = {i,j};
%        save test.mat
	entries{i,j} = formatstring ( subsref (pm,S) / (10^pm.dp) , NCHAR, maxafter);
%	entries{i,j} = formatstring ( M(i,j)  , NCHAR, maxafter);
     end;
  end;
end;      

if n == 0
  fprintf (1, '<empty>\n');
else
  fprintf (1,'%sPhones involved: %d, namely %s\n\n', init, n, pm.labels.allphones)

  % print headings for matrix
    
  fprintf (1, '%s  ', init);
  for j = 1:n, 
    fprintf (1, '%s%s', formatstring(pm.labels{j}, NCHAR), inbtwn); 
  end;
  fprintf (1, '\n');
  
  if pm.dp ~= 0
    fprintf (1, '\n%sAll entries seen should be multiplied by 1e%d\n\n',   init, pm.dp);
  end;

  % now print matrix...

  for i = 1 : n                       % for each row of the matrix
    fprintf (1, '%s%s ',init, pm.labels{i});
    for j = 1:n
      fprintf (1, '%s%s', entries{i,j}, inbtwn);
    end;
    fprintf (1, '  %s\n',pm.labels{i});
  end;      
end;

fprintf('\n');


