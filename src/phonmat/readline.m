function z = readline (filename, n)
% READLINE reads a specified line of a specified ascii file
% z = readline (filename, n)
% z is a char string that is the n-th line of file filename
% (Technical note: anything in /* .. */ in the file is ignored.)

if ~ischar(filename), 
  error (sprintf ('The first argument to READLINE must be a string (representing a file name)',filename));
elseif ~exist (filename)
  error (sprintf ('File %s not found',filename));
end;

alllines = textread (filename, '%s', 'commentstyle', 'c', 'headerlines',0, 'delimiter', '\n' );
z = alllines{n};

