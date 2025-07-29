function hatY = recover(Wxy,X)
% function hatY = hmams.erosive.recover(Wxy,X)
%
% Recovers the associated image of input vector [X] in erosive memory
% [Wxy]. [Wxy] if (fy x fx) and [X] is (fx x j).

hatY = mmp.l.mtimes(Wxy,X);
return
