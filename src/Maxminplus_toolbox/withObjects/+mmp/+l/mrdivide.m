function [Z]=mrdivide(A,B)
% function [Z]=mrdivide(A,B)
%
%  A/B (read "A (lower) over B") lower matrix right divide
% mmp.l.mrdivide(A,B)= mmp.u.mtimes(A, mmp.conj(B))
% In max-plus calculus, this is the greatest subsolution in x of
% xB = A, i.e. computes the largest x such that  xB <= A
%
% CAVEAT: Either the COLUMN dimension of A and B should be the same or A
% should be a scalar.
Z = mmp.u.mtimes(A,mmp.inv(B));
return
