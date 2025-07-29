function Z = mrdivide(A,B)
% OO maxplus left divide for either sparse or full matrices
Z = mtimes(A,-B.');
return
