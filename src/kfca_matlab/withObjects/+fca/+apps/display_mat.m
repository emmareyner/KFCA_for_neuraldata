function display_mat(pm, maxdp)
% DISPLAYs contents of mat
%
%pm is a struct containing the matrix info (resembling phonmat class)
 % pm.mat has the underlying matrix.
 % pm.labels has the labels of the symbols involved.
 % pm.title has the name of this matrix
 % pm.symmetric specified whether the matrix is symmetric
 % pm.hasdiag specified whether the matrix has meaningful diagonal entries
 % pm.default -- don't worry about it.
 % pm.smallest. Any value below smallest in magnitude is assumed to be 0.
 % pm.dp is the number of decimal places to be used in displaying this object. %

if nargin < 2, maxdp = 4; end;
init = '    ';      % initial spacing

fprintf('\n');

fprintf (1,' %s  = \n', inputname(1));
fprintf (1,'\n');
fprintf (1,'%stitle: %s\n\n', init, pm.title);
[n,m] = size(pm.mat);

% determine how many characters NCHAR you want to allocate each element in the table
% This is taking too much time to load. 

M = pm.mat / (10^pm.dp);



[B,A] = fca.apps.decimalplaces (M);
maxbefore = fca.apps.fullmax (B);
maxafter  = min (maxdp, fca.apps.fullmax (A));

NCHAR = uint16(maxbefore + 1 + maxafter);
if mod(NCHAR,2)==0 NCHAR=NCHAR+1; end
blank = repmat ('.', 1, NCHAR);

inbtwn =  ' ';         % spacing in between entries
entries = {};           % entries{i,j} has the string with the (i,j)-th entry

S.type = '()';
for i = 1:n
  for j = 1:m
     if (i > j & pm.symmetric) | (i == j & ~pm.hasdiag)
        entries{i,j} = blank;
     else
        S.subs = {i,j};
%        save test.mat
    entries{i,j} = fca.apps.formatstring ( pm.mat(i,j) / (10^pm.dp) , NCHAR, maxafter);
%	entries{i,j} = fca.apps.formatstring ( M(i,j)  , NCHAR, maxafter);
     end;
  end;
end;      

if n == 0
  fprintf (1, '<empty>\n');
else
    allphones=[];
    for i=1:n
        allphones=[allphones,' ', sprintf('%s',pm.elabelset{i})];
    end

  fprintf (1,'%sPhones involved (emitted): %d, namely %s\n\n', init, n, allphones)

   allphones=[];
    for i=1:m
        allphones=[allphones,' ', sprintf('%s',pm.rlabelset{i})];
    end

  fprintf (1,'%sPhones involved (received): %d, namely %s\n\n', init, m, allphones)

  
  % print headings for matrix
    if pm.dp ~= 0
    fprintf (1, '\n%sAll entries seen should be multiplied by 1e%d\n\n',   init, pm.dp);
  end;
 
  fprintf (1, '\n');
  fprintf (1, '%s%s%s', init, fca.apps.formatstring(init, NCHAR),inbtwn);
  %fprintf (1, '%s  ', fca.apps.formatstring(init, NCHAR));
  for j = 1:m, 
    fprintf (1, '%s%s', fca.apps.formatstring(pm.rlabelset{j}, NCHAR), inbtwn); 
  end;
  fprintf (1, '\n');
  
 
  % now print matrix...

  for i = 1 : n                       % for each row of the matrix
    fprintf (1, '%s%s%s',init, fca.apps.formatstring(pm.elabelset{i},NCHAR),inbtwn);
    for j = 1:m
      fprintf (1, '%s%s', entries{i,j},inbtwn);
    end;
    fprintf (1, '%s%s\n',fca.apps.formatstring(pm.elabelset{i},NCHAR),inbtwn);
  end;      
end;

fprintf('\n');


