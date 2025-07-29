%% Just a quick check that transitive reduction is easy to implement in
%%maxminplus
A = ABG06a.M-20/3
Asmax = mmp.l.trclosure(A)
%The transitive reduction is:
Armax = mmp.u.plus(A,-mmp.l.mtimes(A,A))
Asmax == mmp.l.trclosure(Armax)
%The transitive closure in minplus:
% The transitive reduction in minplus
Armin = mmp.l.plus(A,-mmp.u.mtimes(A,A))
