function [Z]=mmp_l_mldivide(A,B)
% function [Z]=mmp_l_mldivide(A,B)
%
%  A\B (read "A (lower) under B") lower matrix left divide
% mmp_l_mldivide(A,B)= mmp_l_mtimes(mmp_l_inv(A), B)
% In max-plus calculus, this is the greatest subsolution in x of
% Ax = B i.e. computes the largest x such that  Ax <= B
%
% CAVEAT: Either the COLUMN dimension of A and B should be the same or A
% should be a scalar.
Z = mmp_l_mtimes(-A.',-B);
return
