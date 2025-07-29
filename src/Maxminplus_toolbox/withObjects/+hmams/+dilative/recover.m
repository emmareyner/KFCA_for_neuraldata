function veeY = recover(Mxy,X)
% function veeY = hmams.dilative.recover(Mxy,X)
%
% Recovers the associated image of input vector [X] in dilative memory
% [Mxy]. [Mxy] if (fy x fx) and [X] is (fx x j).

veeY = mmp.u.mtimes(Mxy,X);
return
