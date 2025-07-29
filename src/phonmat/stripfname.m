function [z,y,rest] = stripfname (f,n,joiner)

% Used to get any number of parts of the path in question.
% f = '.../dr1/mcfg0/sa1'
% z = 'sa1', y = {'sa1'} if n=1
% z = 'mcfg0_sa1', y = {'sa1','mcfg0'} if n=2
% z = 'dr1_mcfg0_sa1', y = {'sa1','mcfg0','dr1'} if n=3
% joiner = '-', '_', etc

if nargin < 3, joiner='-'; end;


z = '';
N = length(f);
if f(N) == '/', f=f(1:N-1); end;
N = length(f);
lastslash = N;

while N > 0 & n > 0
  if strcmp (f(N),'/'), 
    if strcmp (z,'')
      z = f(N+1:length(f));
      y{1} = f(N+1:length(f));
    else
      z = strcat (f(N+1:lastslash-1),strcat (joiner,z));
      y{length(y)+1} = f(N+1:lastslash-1);
    end;
    lastslash = N;
    n=n-1;
  end;
  N = N-1; 
end;
rest = f(1:lastslash);

