function latex (PM,  decplaces, BAD, totals)
%	LATEX member function of PHONMAT. Produces output in LaTeX format
%
% 	latex (PM, decplaces, BAD, totals)
%
%	This produces a LaTeXized version of PM. 
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
%
%	BAD is a possibly empty substring of 'bad', corresponding to 
%	whether you want below-diagonal, above-diagonal and/or
%	diagonal entries. The default is to do whatever corresponds to 
%	a normal display. It will ignore directives to print diagonals
%       if it has .hasdiag set to 0.
%
%	totals is a possibly empty (default) substring of 'rc' for 
%	row and/or column totals

M = PM.mat;
%n = size(M,1);
[n,m] = size(M);
divby = (10^PM.dp);

justf = 'r';

if nargin < 2, decplaces = 3; end;
if nargin < 3, BAD = 'bad'; end;
if nargin < 4, totals = ''; end;

d = decplaces;

if ~PM.hasdiag, BAD = removeelem (BAD, 'd'); end;

%if PM.symmetric, BAD = removeelem (BAD, 'b'); end;

phe = PM.elabelset;
phr = PM.rlabelset;

% we want output like this (if BAD = 'ba' for example)
% 
% \begin{table}
% \begin{center}
% \begin{tabular}{lrrr}
% \hline
%	&   p	&  t	&   k	\\
% \hline
%   p	&  	& 0.12  &  0.24 \\
%   t	& 0.23  &	&  0.13 \\
%   k	& 0.35	& 0.42	&	\\
% \hline
% \end{tabular}
% \end{center}
% \caption{}
% \label{}
% \end{table}

hline = '\\hline\n'; 
border = '|';

rowtotal = fca.apps.findinvec (totals, 'r');
coltotal = fca.apps.findinvec (totals, 'c');

if ((length (BAD) == 1) & (BAD(1) == 'a'))

  fprintf ( '\\begin{table}\n' );
  fprintf ( '\\label{}\n');
  fprintf ( '\\begin{center}\n' );
  fprintf ( '\\begin{tabular}{' );

  tab = [border];
  for i = 2 : n, tab = [tab  justf]; end;

%  if rowtotal, tab = [tab border justf]; end;       % ignored for now

  tab = [tab border 'l' border ];

  fprintf ([tab '}\n']);
  fprintf (hline);

  for j = 2 : m
    fprintf (sprintf (' & %s ', phr{j} )); 
  end;

%  if rowtotal
%    fprintf (' & Total ');
%    rowtotals  = sum (PM.mat, 2) ;
%  end;
  fprintf ('& \\\\\n');

  fprintf (hline);

  S.type = '()';
  blank = fca.apps.spaces (d+8);

  for i = 1 : n-1
    for j = 2 : m
      S.subs = {i,j};
      val = 0; 
      if i < j 
        fprintf ( fca.apps.formatstring ( subsref (PM, S) / divby , d+8, d));
      else
        fprintf (blank);
      end;
      fprintf (' & ');
    end;
%    if rowtotal
%      fprintf ( fca.apps.formatstring ( rowtotals (i) / divby, d+8, d) );
%    end;
    fprintf (phe{i});
    fprintf ('\\\\\n');
  end;

  fprintf (hline);
  fprintf ('\\end{tabular}\n');
  fprintf ('\\end{center}\n');
  cap = '';
  if PM.dp ~= 0
    cap = sprintf ('\nAll entries seen should be multiplied by 1e%d\n',    PM.dp);
  end;

  fprintf ('\\caption{%s}\n', cap);
  fprintf ('\\end{table}\n\n');

else

	fprintf ( '\\begin{table}\n' );
	fprintf ( '\\label{}\n');
	fprintf ( '\\begin{center}\n' );
	fprintf ( '\\begin{tabular}{' );

	tab = [border 'l' border];
	for i = 1 : n, tab = [tab  justf]; end;
	if rowtotal, tab = [tab border justf]; end;
	tab = [tab border ];

	fprintf ([tab '}\n']);
	fprintf (hline);
	
	for i = 1 : m, 
	  fprintf (sprintf (' & %s ', phr{i} )); 
	end;

	if rowtotal
	  fprintf (' & Total ');
	  rowtotals  = sum (PM.mat, 2) ;
	end;
 
        fprintf ('\\\\\n');

        fprintf (hline);

        S.type = '()';
        blank = fca.apps.spaces (d+8);

        for i = 1 : n
        fprintf (phe{i});
        fprintf (' & ');
        for j = 1 : m
          S.subs = {i,j};
          val = 0; 
          if (fca.apps.findinvec (BAD, 'd') & i == j) | (fca.apps.findinvec (BAD, 'b') & i > j ) |  (fca.apps.findinvec (BAD, 'a') & i < j )
            fprintf ( fca.apps.formatstring ( PM.mat(i,j)/divby , uint16(d+8), d));
          else
            fprintf (blank);
          end;
          if n > j | rowtotal 
            fprintf (' & ');
          end;
        end;
        if rowtotal
          fprintf ( fca.apps.formatstring ( rowtotals (i) / divby, uint16(d+8), d) );
        end;
        fprintf ('\\\\\n');
end;

fprintf (hline);
fprintf ('\\end{tabular}\n');
fprintf ('\\end{center}\n');
cap = '';
if PM.dp ~= 0
  cap = sprintf ('\nAll entries seen should be multiplied by 1e%d\n',    PM.dp);
end;

fprintf ('\\caption{%s}\n', cap);
fprintf ('\\end{table}\n\n');

end;
