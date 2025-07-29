function pm = phonmat (varargin)
%
% PHONMAT User-defined class originally designed to help with manipulation 
%   of stimulus-response matrices from psycholinguistic experiments 
%   involving phone/mes, but has since proved to be much more versatile. 
%   One can read 'general symbol' for 'phone/me'.
%
%   (Author: Dinoj Surendran dinoj@uchicago.edu)
% 
% The phonmat class has the following fields:
%
%  pm.mat is a nxn array of numbers. The pm.mat(i,j) corresponds to the 
%    entry for the i-th and j-th phoneme.
%  pm.labels is of type LABELS and has the n labels involved here
%  pm.title is a string with the name of this matrix
%  pm.symmetric is 1 if the matrix is symmetric and 0 (default) otherwise.
%  pm.hasdiag is 1 (default) matrix has meaningful diagonal entries, else 0 
%  pm.default is 0 (default)
%  pm.smallest = 1e-10 (default). Any value below smallest is assumed to be 0.
%  pm.dp is the number of decimal places to be used in displaying this object.
%    For instance if it is 2, then a value of 541.32 is displayed as 5.4132,
%    It is by default set to k, where if MAX is the largest entry in pm.mat,
%    and MINnz the smallest nonzero entry in magnitude:
%      if MAX <= 1
%        MAX = a x 10^k, for a in 1..9
%      else
%        MINnz = a x 10^k, for a in 1..9
%      endif
%
%  The fields .symmetric, .hasdiag are provided to deal with cases where the matrix is symmetric
%    and/or has meaningful diagonal entries. For example, if the matrix was a matrix of
%    functional loads of pairs of phonemes, it would be meaningless to have FL(x,x), and
%    therefore pm.hasdiag should be set to 0.
%
%    Note that pm.mat can be any numeric matrix. It can be non-symmetric and have diagonal 
%    entries even if, say, pm.symmetric=1 and pm.hasdiag = 0. In this case, whenever the 
%    matrix is displayed, only its strictly-above-diagonal entries are presented to
%    emphasize the point that those are its only meaningful ones. A call to list(pm) returns
%    a vector with only the meaningful entries of pm. 
%
%    If pm.symmetric is 1, then any call pm(a,b) can return one of pm.mat(a,b) or pm.mat(b,a). 
%    Here is how the decision is made as to which one to use.
%      If both values equal pm.default, pm.default is returned. 
%      If only one value equals pm.default, the other one is returned.
%      If neither equal pm.default, pm.mat(a,b) is returned. THIS MAY NOT BE WHAT IS INTENDED.
%        MAKE SURE IT DOESNT HAPPEN IF pm.symmetric == 1.
%
%  pm.default is 0 (by default, excuse the pun) and this should be enough for most purposes. 
%    If it is not enough, then set it to be some numeric value that no valid entry of pm.mat 
%    can ever take. If pm.mat's entries can take any numeric value, then set it to NaN (not a 
%    number). The statements made in the previous paragraph about 'equalling the default value'
%    still apply, since the author worked around the Matlab definition of (NaN == Nan) = 0. In
%    other words, it can be assumed within this class that (NaN == NaN) = 1.
%
% The constructor function  is overloaded so it can be called in any of the following ways:
% 1) phonmat ()   default constructor
% 2) phonmat (c) where c is of type phonmat (copy constructor)  
% 3) phonmat (filename), where filename is a file with one of the possible structures below.
% 4) phonmat (PM, labels, [title])     arguments are of class PHONMAT, LABELS, [CHAR]
% 5) phonmat (mat, labels, [title])     arguments are of class NUMERIC, LABELS, [CHAR]
%
% No constructor (other than 2) is provided that allows the last three fields to be set to
%  their non-default values. These fields have to be set manually. I had originally put such
%  constructors in, but remembering the order of input ('does symmetric come before hasdiag?')
%  was a source of many bugs while using this class.
% 
%
%  STRUCTURE ONE
%
%  a) The first line of the file should start with a % and then the title of the matrix
%
%  b) The second line of the file should start with a % and then
%  contain a n-long strings with n 1-character phoneme labels eg 
%          %   ptkbdg
%
%  c)  The third line (optional) contains alternative names, separated by
%    spaces and the 1-character names already used. For example
%          % p pee P t tee d dee
%    if you want to be able to call p pee or P, t tee and d dee.
%
%    There should be no other lines before the matrix. 
%
%  d) After this, on lines that are not started by %, you have
%  the matrix itself. 
% 
%  e) Any other comments about the matrix should come after it, in 
%    lines started with a %. 
%
%    Note that in this case you will have to supply all entries of the matrix, 
%    even if it is symmetric or has all diagonals zero. You will have to set
%    those two fields manually.
%
%  STRUCTURE TWO
%
%  Only the first line of the file may have a % sign, in which case it is the title
%  of the matrix. 
%  Every other line of the file has two entries. eg
%  
%     pt 0.41541
%
%  The first is a 2-character entry 'xy' and the second is a number r. This means that
%    the (x,y)-th entry of the matrix is r.
%  
%  For simplicity, DO NOT USE the percent symbol (\%) as a 1-char phone label! 
%  (Strictly speaking though, you can do so, as long as you dont have the first 
%   character of the first two lines being '%', since that is what is used
%   to check that the file has structure one.)
%

pm.mat = [];
pm.labels = labels;
pm.title = '';
pm.symmetric = 0;
pm.hasdiag = 1;
pm.default = 0;
pm.smallest = 1e-10;
pm.dp = 0;

pm = class (pm, 'phonmat');   

switch (nargin)
 case 0                        % default constructor

  return;
  
 case 1
  a = varargin{1};

  if isa (a, 'phonmat')                      % copy constructor

    pm.mat = a.mat;
    pm.title = a.title;
    pm.symmetric = a.symmetric;
    pm.hasdiag = a.hasdiag;
    pm.default = a.default;
    pm.dp = a.dp;
    pm.smallest = a.smallest;

    pm = private_changelabels (pm,labels);
  
    return;

  elseif ischar (a)                        % phonmat (filename)

    filename = a;
    if ~exist(filename), error (sprintf ('file %s not found',filename)); end;

    % now check if file filename has structure one or two.

    filestruc = whichStructure (filename);
    if filestruc == 1
      [pm.mat, pm.labels, pm.title] = readStructureOne (filename);
      pm.dp = private_finddp (pm.mat, pm.smallest);
      return;      
    elseif filestruc == 2
      [pm.mat, pm.labels, pm.title] = readStructureTwo (filename);
      pm.dp = private_finddp (pm.mat, pm.smallest);
      return;
    end;
    
    
  end;    

  error ('constructor called with wrong type');

 case 2                                                % constructor with two arguments can only be phonmat (pm,labels) 

  if isnumeric (varargin{1}) && isa (varargin{2}, 'labels') && goodarguments (varargin{1}, varargin{2})					       
    set (pm, 'labels', varargin{2});
    set (pm, 'mat', varargin{1});
    return;
  elseif isa (varargin{1}, 'phonmat') && isa (varargin{2}, 'labels');					       
    pm = phonmat (varargin{1});
    set (pm, 'labels', varargin{2});
    return;
  end;

  error ('constructor called with wrong type');

 case 3                                                % constructor with three arguments can only be phonmat (pm,labels,title)

  if ischar (varargin{3})
    pm = phonmat (varargin{1}, varargin{2});
    pm.title = varargin{3};
    return;
  end;
  error ('constructor called with wrong type');

 otherwise

  error ('wrong number of arguments');
end;


%%%%%%%%%%%%%%%%%%%   helper functions    %%%%%%%%%%%%%%%%%%%

function ok = goodarguments (S,lab)
% returns true if S is a n x n matrix of integers (actually, just checking if it's numeric) and  labels is a string with n phoneme labels

if isa (lab,'labels')
  ok = private_isgoodmatrix(S) == lab.size;
elseif isa (lab,'char')
  ok = private_isgoodmatrix(S) == length(lab);
else 
  ok = 0;
end;



function z = whichStructure (filename)
% returns 1 or 2 if file filename is of structure 1 or 2 respectively.

z = 2;
line1 = readline (filename, 1);
line2 = readline (filename, 2);
if line1(1) == '%' & line2(1) == '%'
  z = 1;
end;






function [S, L, title] = readStructureOne (filename)
% S = matrix for pm.mat, L = labels for pm.labels

	line1 = readline (filename, 1);
	line2 = readline (filename, 2);
        title     = private_removecomment (line1) ;
	onelabels = private_removecomment (line2) ;
	altlabels = readline (filename, 3);

	if findstr (altlabels, '%')
	  altlabels = private_removecomment (altlabels);
	else
          altlabels = '';
        end;
        S = load (filename);

	if ~goodarguments (S,onelabels) 
	  error ('file not formatted correctly -- see @phonmat/phonmat.m comments for details');
	end;

        L = labels (onelabels, altlabels);


function [S, L, title] = readStructureTwo (filename)
% S = matrix for pm.mat, L = labels for pm.labels

       line1 = readline (filename, 1);
       firstlineistitle =  line1(1) == '%';           % 1 or 0
       alllines = textread (filename, '%s', 'commentstyle', 'c', 'headerlines', firstlineistitle, 'delimiter', '\n' );
       somepairs = {};
       somevals  = [];
       onelabels = '';
       title = '';
       if firstlineistitle
         title = private_removecomment (line1);
       end;
       
       for i = 1 : length (alllines)
         [somepair, someval] = strread ( alllines{i}, '%s%f\n', 'delimiter', ' \t');

	 if iscell (somepair), somepair = somepair{1}; end;
	 if iscell (someval), someval = someval{1}; end;
	 	 
	 somepairs { 1 + length (somepairs) } = somepair;
	 somevals  ( 1 + length (somevals)  ) = someval;
	 
	 if length(somepair) ~= 2
	   error ('file supposed to be Structure Two but isnt');
         end;

	 for i = 1:2
	   present = findinvec (onelabels, somepair(i));
   	   if ~present
	     onelabels = [onelabels, somepair(i)];
           end;
	 end;
       end;

       L = labels (onelabels);
       n = length (onelabels);
       S = zeros(n);

       for i = 1 : length (somepairs)   % deal with entries 'xy r'
         x = somepairs{i}(1);
         y = somepairs{i}(2);
	 r = somevals(i);

%	 x,y,r,L(x),L(y)
	 
         S (L(x), L(y)) = r;
       end;


