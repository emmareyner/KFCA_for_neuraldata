function [r,t,p,phons,numcompared,lis1,lis2] = correl(PM1,PM2,phns,log1,log2)

% CORR4PM correlation for PHONMAT objects
% 
%    [r,t,p,phons,numcompared] = correl(PM1,PM2,phns,log1,log2)
% 
% Returns correlation of PM1 and PM2 for their subset of phns
% 

if nargin < 3, phns=PM1.phones; end
if nargin < 4, log1=0; end
if nargin < 5, log2=0; end


phons = findcommon( findcommon(PM1.phones,phns), PM2.phones );
pm1 = sub (PM1,phons);
pm2 = sub (PM2,phons);
lis1 = asrow(list(pm1));
lis2 = asrow(list(pm2));
L = length(lis1);
if L ~= length (lis2)
  error ('not same length');
end

a = ones(1,L);
b = ones(1,L);

if log1
  a =  (lis1>0);
end
if log2
  b =  (lis2>0);
end  

c = logical(a.*b);
numcompared = length(c);

if log1
  lis1 = log(lis1(c));
end
if log2
  lis2 = log(lis2(c));
end  

[r,t,p] = correl(lis1,lis2);

 