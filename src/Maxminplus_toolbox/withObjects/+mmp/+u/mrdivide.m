function [Z]=mrdivide(X,Y)
% function [Z]=mrdivide(X,Y)
%
%  A/B (read "A (upper) over B") upper matrix right divide
%  mmp.u.mrdivide(A,B)= mmp.l.mtimes(A, mmp.conj(B)) 
%
% In min-plus calculus, this is the lowest supersolution in x of
% xB = A, i.e. computes the smallest x such that  xB >= A
%
% CAVEAT: Either the COLUMN dimension of A and B should be the same or A
% should be a scalar.

Z = mmp.l.mtimes(X,mmp.inv(Y));
return
