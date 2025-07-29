function L = localmax(c)

% dinoj@cs.uchicago.edu 05/20/02
% c,L are 1 x r vector with 
% L(i) = 1 if c(i) > c(i-1) & c(i+1)

% first make L a 1x(r-2) vector dealing with middle of c

r = length(c);
L = c(2:r-1) >= c(1:r-2) & c(2:r-1) >= c(3:r);
a = c(2) > c(1);
b = c(r) > c(r-1);
L = [a L b];
 
 
