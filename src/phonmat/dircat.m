function z = dircat (a,b)

% a and b are parths of paths
% we want to have a and b joined
% there needs to be a / between a and b
% we arent sure if either a or b or both already has this slash

A = length(a); B=length(b);
if A & strcmp (a(A),'/'), a = a(1:A-1); end; 
if B & strcmp (b(1),'/'), b = b(2:B); end; 
z = strcat(a,strcat('/',b));