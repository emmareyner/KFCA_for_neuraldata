function [Z]=mldivide(X,Y)
% function [Z]=mldivide(X,Y)
%
% A\B (read "A (upper) under B") upper matrix left divide:
%
% mmp.u.mldivide(A,B)= mmp.l.mtimes(mmp.conj(A),B)  
%
% In min-plus calculus, this is the lowest supersolution in x of
% Ax = B, i.e. computes the smallest x such that  Ax >= B
%
% CAVEAT: Either the ROW dimension of A and B should be the same or A
% should be a scalar.

Z = mmp.l.mtimes(mmp.ctranspose(X),Y);
return
