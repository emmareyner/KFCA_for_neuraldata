function Z = inv(X)
% Inversion primitive for maxplus encoded matrices
Z=mmp.x.Sparse(-X.Reg.');
return%Z
