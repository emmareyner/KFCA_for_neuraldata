function [before,after] = decimalplaces(M, sf)

% DECIMALPLACES returns the number of decimal places before and after
%               the decimal point.
%
%	[before,after] = decimalplaces(M,sf)
%
%	If M is a single number of the form b.a (eg 34.543 means b=34,a=543)
%         before = length(b) and after = length(a)
%       If M is a matrix then before and after are the same size as M
%	  with elementwise values eg if M is 3x4x9 and 
%	  [b,a] = decimalplaces(M) then b(4,3,1) = decimalplaces(M(4,3,1))
%
%	sf is the maximum number of significant places you are
%	interested in. It is 6 by default, which is good for most purposes.
%
%	It is assumed M is numeric. For speed, no checks are done, so
%	make sure it is.
%
%	If M < 0 for a number M, the negative sign is counted in before. 
%       eg. if [b,a] = decimalplaces(42.045) and [bn,an] = decimalplaces(-42.045)
%	then bn = b+1 = 2, an = a = 3.
%
%	If M is fractional with k > 4 zeros before a nonzero value,
%	after is set to be k+1. k+3 sometimes results in inaccurate
%	mathematical values and I want to be safe.
%
%       eg. [b,a] = decimalplaces(3000.000000000001190001000)  ==> b = 4, a = 14
%       eg. [b,a] = decimalplaces(3000.00000000000119001000)  ==> b = 4, a = 17
%       eg. [b,a] = decimalplaces(30000.00000000000119001000)  ==> b = 5, a = 0
%

if nargin < 2
  sf = 6;
end;

N = numdim (M);

if ~N
  before = 0;
  after = 0;
end;

if 1 == max (size(M))
  addone = M < 0;
  if addone
    M = -M;
  end;

  after = numDigitsInFraction (rem (M(1), 1), sf);
  before = addone + numDigitsInInteger (floor (M(1)) );

else

  % The command to be issued here depends on the dimensions of M.
  %  Suppose M is 4-dimensional, specifically 5x6x9x2 . Then we need to say
  %  for i = 1 : 2
  %    [before(:,:,:,i), after(:,:,:,i)] = decimalplaces (M(:,:,:,i));
  %   end;

  b4 = '';
  for i = 1 : N-1, b4 = [b4 ':,']; end;

  for i = 1 : size(M,N)
    indx = [b4 num2str(i)];
    if 1 == N, indx = [indx ',1']; end;
    indx = ['(' indx ')'];

    commandrqd = [ '[before' indx ', after' indx '] = decimalplaces (M'  indx ');'];
    eval (commandrqd);
  end;


end; 


%%%%%%%%%%%%% helper functions %%%%%%%%%%%%%%%%%%%%
     
function d = numDigitsInInteger (x)     
% x is an positive integer with  d digits
% x has to be an integer, no checking done.

xx = num2str (x);
n = length (xx);
f = findinvec (xx, 'e');
if f
  d = 1 + str2num ( xx(e+2:n) );
else
  d = n;
end;
  

function d = numDigitsInFraction (x,sf)
% x is a positive number less than 1, else this works bad.
% sf is the max number of significant figures needed.
% d returns the number of digits that would represent
%  x in full, e.g. x = 0.00000000001 should return 11.
%  Note that x = 0.0000000000100001 would return 12.
%  Generally, if there are a zeros then b nonzero digits
%  then c zeros, a+min(b,sf) is returned. c is ignored.

% x = a x 10^-r for some a in 1:9. 

if x==0, d = 0; return; end;

xx = num2str (x);
f = findinvec (xx, 'e');
n = length (xx);

% find a first, i.e. number of zeros after decimal point.

a = 0;
if f
  a = str2num ( xx(f+2:n) ) - 1;             
else
  for i = 3 : length (xx)
    if xx(i) == '0'
      a = a+1;
    else
      break;
    end;
  end;
end;

% now find b, the number of nonzeros after the last zero

xx = num2str (10^a * x, sf);

if findinvec (xx, 'e')
 error ('weird');
end;

b = length (xx) - 2;

d = a+b;
