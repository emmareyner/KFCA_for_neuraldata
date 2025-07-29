function Mxy = create(X,Y)
% function Mxy = +hmams.dilative.create(X,Y)
%
% Create a dilative heteroassociative morphological memory [Mxy] with
% inputs [X] and outputs [Y]. [X] should be of dimensions fx x i where f is
% the number of x features and i the number of instances and [Y] should be
% fy x i, where fy is the number of y features.
%
% The dilative memory built is:
% Mxy = mmp.l.mldivide(Y,X)
% So the output memory is fy x fx

Mxy = mmp.l.mrdivide(Y,X);
return

