function p = randProb (N)
 
% RANDPROB   generates raNdom probability distributioN.
% geNerates 1xN vector that is a raNdom probability distributioN over N values.

 if (N < 0) 
   error ('invalid input');
 elseif (0 == N)
   p = [];
 elseif (1 == N)
   p = [1];
 else
   k = rand(1,1);
   r = randProb (N-1); 
   p = [k r*(1-k)];
 end;





 