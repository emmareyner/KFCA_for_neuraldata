function Aplus = logarithmic_tclosure(A)
% Find the transtive closure of a matrix by means of the logarihmically
% slowened algorithm.

%Ak is the k-th power of A
%C accumulates the addition A+A^2+A^3+...+A^n
Aplus = logical.mtimes_raw(A,logical.logarithmic_trclosure(A));
return%C
