function display(pv, maxdp)
% DISPLAYs contents of pv, which is of type PHONVEC

if nargin < 2, maxdp = 4; end;
init = '    ';      % initial spacing

fprintf('\n');

fprintf (1,' %s (object of type PHONVEC) =  \n', inputname(1));
fprintf (1,'\n');
fprintf (1,'%stitle: %s\n', init, pv.title);
fprintf (1,'%sphones: %s\n\n    ', init, pv.labels.phones);

L = pv.labels.phones;
V = pv.vec;
if abs(max(V)) > 0
  df = log(abs(max(V)))/log(10);
  if df > 0
    df = ceil(df);
    W = V / 10^df;
  elseif df < 0
    df = floor(df);
    W = V / 10^df;
  else
    df = 0;
    W = V;
  end;
else
  df = 0;
  V = W;
end;  

if df 
   fprintf (1,' MULTIPLY ALL VALUES BY 10^%d\n\n    ', df);
end;
for n = 1 : length (W);
   eval (sprintf ('fprintf (1, ''%%s (%%1.%df) '', L(n), W(n))', maxdp) );
end;
fprintf (1,'\n\n    ');
V = probabilitize(V);
for n = 1 : length (pv.vec)
   eval (sprintf ('fprintf (1, ''%%s (%%0.%df) '', L(n), V(n))', maxdp) );
end;
fprintf (1,'\n');
