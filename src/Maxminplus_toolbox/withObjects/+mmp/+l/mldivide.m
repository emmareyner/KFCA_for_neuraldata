function [Z]=mldivide(X,Y)
% function [Z]=mldivide(X,Y)
%
% A\B (read "A (lower) under B") lower matrix left divide:
%
% mmp.l.mldivide(A,B)= mmp.u.mtimes(mmp.conj(A),B)
%
% In max-plus calculus, this is the greatest subsolution in x of
% Ax = B, i.e. computes the largest x such that  Ax <= b
%
% CAVEAT: Either the ROW dimension of A and B should be the same or A
% should be a scalar.

Z = mmp.u.mtimes(mmp.inv(X),Y);
return
