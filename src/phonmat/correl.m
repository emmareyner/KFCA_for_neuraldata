function [r,t,p,df] = correl(a,b)

% CORREL returns linear correlation of two vectors
%
%        [r,t,p,df] = correl(a,b)
%
%        a and b are two numeric vectors of the same size, N.
%	 r is their linear correlation.
%        t and p are the usual level of significance assuming a normal distribution
%        df is the number of degrees of freedom
%   
%        If N is zero, all the above are NaN.

     [n,m] = size(a);
     [nn,mm] = size(b);
     k = max(n,m);
     N = k;
     kk = max(nn,mm);
%     if k ~= kk,  return -10;   end;
     sumx = 0;
     sumy = 0;
     sumx2 = 0;
     sumy2 = 0;
     sumxy = 0;
     for i=1:k
        sumx = sumx + a(i);
        sumy = sumy + b(i);
        sumx2 = sumx2 + a(i)^2;
        sumy2 = sumy2 + b(i)^2;
        sumxy = sumxy + a(i)*b(i);
     end;

if N
  r = ((N * sumxy) - (sumx * sumy)) / sqrt( (N*sumx2 - sumx^2) * (N*sumy2 - sumy^2) ) ;
  t = r * sqrt ( (N-2) / (1-r*r)) ;
  df = N - 2;
  p = betainc( df / (df + t*t), df/2, 0.5) ;
else
  r = NaN; 
  t = NaN;
  df = NaN;
  p = NaN;
end;




