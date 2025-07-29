function Wxy = create(X,Y)
% function Wxy = +hmams.erosive.create(X,Y)
%
% Create an erosive heteroassociative morphological memory [Wxy] with
% inputs [X] and outputs [Y]. [X] should be of dimensions fx x i where f is
% the number of x features and i the number of instances and [Y] should be
% fy x i, where fy is the number of y features.
%
% The erosieve memory built is:
%
% Wxy = mmp.u.mldivide(Y,X)
%
% So the output memory is fy x fx

Wxy = mmp.u.mrdivide(Y,X);
return

