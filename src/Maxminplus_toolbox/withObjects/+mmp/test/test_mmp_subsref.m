%to test  the subsref primitive
load matrices
[ma na]=size(A)
%1. Selecting one element
B=A(2,3)%B should be 3

%2. selecting an index of elements.
i=1:4;
C=A(i);
