function [Z]=mmp_l_mrdivide(A,B)
% function [Z]=mmp_l_mrdivide(A,B)
%
%  A/B (read "A (lower) over B") lower matrix right divide
% mmp_l_mrdivide(A,B)= mmp_l_mtimes(A, mmp_l_inv(B))
% In max-plus calculus, this is the greatest subsolution in x of
% xB = A, i.e. computes the largest x such that  xB <= A
%
% CAVEAT: Either the COLUMN dimension of A and B should be the same or A
% should be a scalar.
Z = mmp_l_mtimes(A,-B.');
return
