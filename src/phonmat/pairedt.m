function p = pairedt (A,B)
% PAIREDT computes p-value of paired t-test
%
%	p = pairedt (A,B)
%
%	A and B are both n-long numeric vectors.
%	p is the p-value (level of significance) of A and B, and is
%	  the probability that the observed difference is as large
%	  (or larger) as it is given that there is no significant
%	  difference between the populations represented by A and B
%
%	In other words, the smaller the p, the more likely it is 
%	that samples A and B represent different populations
%
%	See http://graphpad.com/articles/interpret/principles/p_values.htm

n = isnumericvector(A);
if n & n == isnumericvector(A,n)
   d = ascol(A) - ascol(B);
   meand = mean(d);
   sterrd = sqrt (sum (d.*d) / (n-1));
   t = meand / sterrd;
   