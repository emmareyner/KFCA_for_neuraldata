function latex (PM,  decplaces, BAD, totals)
%	LATEX member function of PHONMAT. Produces output in LaTeX format
%
% 	latex (PM, decplaces, BAD, totals)
%
%	This produces a LaTeXized version of PM. 
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
[n p] = size(M);
divby = (10^PM.dp);

if nargin < 2, decplaces = 3; end;
if nargin < 3,
    BAD = 'bad';
else
    BAD = lower(BAD);
end;
if nargin < 4, totals = ''; end;

d = decplaces;

if ~PM.hasdiag, BAD = removeelem (BAD, 'd'); end;

%flags to print row and column totals
rowtotal = findinvec(totals, 'r');
coltotal = findinvec(totals, 'c');


%if PM.symmetric, BAD = removeelem (BAD, 'b'); end;

ph = PM.labels;

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

%Constant to draw line in latex
hline = '\\hline\n';
%justf = 'r';
%border = '|';%FVA: OLD BORDER


%pattern to print entries
rs = ones(1,n);rs(:)=double('r');
if rowtotal
    tab = sprintf('|l||%s|r|',rs);
else%no row total to print
    tab = sprintf('|l||%s|',rs);
end

%default tex label for the table
if isempty(PM.title)
    texlabel = 'tab:empty';
else
    texlabel = ['tab:' PM.title];
end

%Prepare the caption
cap = '';
if PM.dp ~= 0
    cap = sprintf ('\nAll entries seen should be multiplied by 1e%d\n',    PM.dp);
end;
style = 'IEEEtran';

%TABLE PRELUDE
fprintf ( '\\begin{table}\n' );
%  fprintf ( '\\label{}\n');%FVA: OLD
fprintf('\\label{%s}\n',texlabel);
if strcmp(style,'IEEEtran')
    fprintf ('\\caption{%s}\n', cap);
end
%fprintf ( '\\begin{center}\n' );%IEEEtrans prefers centering
fprintf ( '\\centering\n' );

%TABULAR ENVIRONMENT
fprintf('\\begin{tabular}{%s}\n',tab );    
%     fprintf ( '\\begin{tabular}{' );
%     
%     tab = [border];
%     for i = 2 : n, tab = [tab  justf]; end;
%     
%     %  if rowtotal, tab = [tab border justf]; end;       % ignored for now
%     
%     tab = [tab border 'l' border ];
%     
%     fprintf ([tab '}\n']);

%SEPARATING BARS
fprintf (hline);

%PRINT PHONEME LABELS
for j = 1 : n
    fprintf (sprintf (' & %s ', ph{j} ));
end;
if rowtotal%Print extra column
    fprintf (' & Total ');
    rowtotals  = sum (PM.mat, 2) ;
end;
fprintf ('\\\\\n');

%TWO separating bars for labels
fprintf (hline);
fprintf(hline);%FVA: new notation for CM

%PROCESSING OF VISUALIZATION OPTIONS
S.type = '()';
blank = spaces (d+6);
switch BAD
    case 'a'
        %if ((length (BAD) == 1) && (BAD(1) == 'a'))
        for i = 1 : n-1
            for j = 2 : n
                S.subs = {i,j};
                %val = 0;
                if i < j
                    fprintf ( formatstring ( subsref (PM, S) / divby , d+6, d));
                else
                    fprintf (blank);
                end;
                fprintf (' & ');
            end;
            %    if rowtotal
            %      fprintf ( formatstring ( rowtotals (i) / divby, d+6, d) );
            %    end;
            fprintf (ph{i});
            fprintf ('\\\\\n');
        end;
    otherwise
        %else
        for i = 1 : n
            fprintf (ph{i});
            fprintf (' & ');
            for j = 1 : n
                S.subs = {i,j};
                %val = 0;
                if (findinvec (BAD, 'd') && i == j) || (findinvec (BAD, 'b') && i > j ) ||  (findinvec (BAD, 'a') && i < j )
                    fprintf ( formatstring ( subsref (PM, S) / divby , d+6, d));
                else
                    fprintf (blank);
                end;
                if n > j || rowtotal
                    fprintf (' & ');
                end;
            end;
            if rowtotal
                fprintf ( formatstring ( rowtotals (i) / divby, uint16(d+6), d) );
            end;
            fprintf ('\\\\\n');
        end;
end;
%FVA: print coltotals if necessary
if coltotal
    coltotals = sum(PM.mat);
    fprintf (hline);
    fprintf('Totals ');
    for j = 1:p
        fprintf('& %s', formatstring( coltotals(j) / divby, uint16(d+6), d));
    end
    if rowtotal
        fprintf('& %s', formatstring( sum(coltotals) /divby, uint16(d+6), d))
    end
    fprintf ('\\\\\n');
end
%FVA: print closing environments
fprintf (hline);
fprintf ('\\end{tabular}\n');
%fprintf ('\\end{center}\n');
if ~strcmp(style,'IEEEtran')
    %FVA: IEEEtran prefers table captions on top.
    fprintf ('\\caption{%s}\n', cap);
end
fprintf ('\\end{table}\n\n');
return

