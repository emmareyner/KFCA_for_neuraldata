function [r,t,p,phons,numcompared] = correl(PM1,PM2,phns,log1,log2)

% returns correlation of PM1 and PM2 for their subset of phns
% 

phons = findcommon( findcommon(PM1.phones,phns), PM2.phones );
pm1 = sub (PM1,phons);
pm2 = sub (PM2,phons);
lis1 = asrow(list(pm1));
lis2 = asrow(list(pm2));
L = length(lis1)
if L ~= length (lis2)
  error ('not same length');
end

a = ones(1,L);
b = ones(1,L);

if log1
  a = find (lis1>0);
end
if log2
  b = find (lis2>0);
end  

c = logical(a.*b);
numcompared = length(c);

[r,t,p] = correl(lis1(c),lis2(c));

 