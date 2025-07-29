function y = rulesplit (total, x, rule)

% RULESPLIT spreads a number into a nonnegative vector totallying that number, according to some rule;
%
%	y = rulesplit (total, x, rule)
%
%	total is a nonnegative number
%	x is a n-long vector of numbers that are either 0 or >= 1. 
%         Ideally, x must not be fully 0 -- if it is, then the total is split equally.
%	y is a n-long vector of nonnegative numbers that sum up to x
%	if rule is :
%	   'argmax'   Suppose the indices i_1,...,i_n are the indices of x with maximum value.
%		      Then y(x_{i_j}) = total/n, for j=1:n
%          'lin'      y_i is proportional to x_i,      i.e. y_i / total = x_i / sum(x)
%	   'log'      y_i is proportional to log(x_i), i.e. y_i / total = log(x_i) / sum (log(x))
%		      y_i = 0 if x_i = 0 or 1.
%
%	

if nargin ~= 3, error ('three arguments needed'); end;
if ~isnumeric(total) | total < 0, error ('first argument must be a nonnegative number'); end;

if ~isnumericvector(x) | min(x) < 0 | min (x(find(x))) < 1, error ('second argument must be a nonzero vector of numbers that are either 0 or at least 1 '); end;

if ~ischar(rule), error ('third argument must be a string'); end;

x = x+2;
n = length(x);
y = zeros(size(x));
switch rule
case 'argmax' 
     [first,all] = argmax (x);
     for i = all, y(i) = total / length(all); end;
case 'lin'
     p = probabilitize (x);
     y = total * p;
case 'log'
     totallogx = sum (log(x(find(x))));
     for i = 1 : n
       if x(i), y(i) = total * log(x(i)) / totallogx; end;
     end;
otherwise
    error ('third argument not supported');
end;
    


