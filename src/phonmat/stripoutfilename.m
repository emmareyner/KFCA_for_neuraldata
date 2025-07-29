function z = stripoutfilename (f)

% f = '.../dr1/mcfg0/sa1'
% z = 'sa1'

n = length(f);
while n > 0
  if strcmp (f(n),'/'), break; else n = n - 1; end;
end;

z = f(n+1:length(f));
