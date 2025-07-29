function [R] = toMaxplus(I)
%function [R] = toMaxplus(I)
%
% transform a logical matrix into its mmp.l.form following the maxplus
% criterion:
%  0 => -Inf
%  1 =>  Inf
%
% This is the inverse of double.toLogical
%
% R == toMaxplus(toLogical(R))
% I == toLogical(toMaxplus(I))

R = +I;
R(R==1)=Inf;
R=log(R);
return


