function Aplus = mpower_tclosure(A)
% A function to calculate the TR closure by calculating the n-th power of
% the reflexive closure.

Aplus = my.logical.mtimes_raw(A,my.logical.mpower_trclosure(A));
return
