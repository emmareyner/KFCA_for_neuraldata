function C = iterative_tclosure(A)
% Find the transtive closure of a matrix by means of the iterative
% algorithm: multiply then add (a gaxpy on matrices)

%Ak is the k-th power of A
%C accumulates the addition A+A^2+A^3+...+A^n
n=size(A,1);
Ak=A;
C = Ak;
for k=2:n
%    Ak=mtimes(Ak,A);
    Ak=logical.mtimes_raw(Ak,A);
    C=C|Ak;
end
return%C
