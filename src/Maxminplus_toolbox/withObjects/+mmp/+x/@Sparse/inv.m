function Z = inv(X)
% Inversion primitive for maxplus encoded matrices
Z=mmp.n.Sparse(-X.Reg.');
return%Z
