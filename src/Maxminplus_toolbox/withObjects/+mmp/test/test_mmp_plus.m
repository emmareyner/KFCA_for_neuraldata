%tests for lower and upper additions
%% non-square matrix
A=[0 -Inf -Inf -Inf;
    Inf 1 -Inf -Inf;
    Inf Inf 2 -Inf];
Act = mmp_ctranspose(A);
Aopp = -A

%try nonconformant additions
%AplAct = mmp_l_plus(A,Act)
%ApuAct = mmp.l.plus(A,Act)
AplAopp = mmp_l_plus(A,Aopp);

%% Try to do some upper and lower additions
B=-A*2
AplB = mmp_l_plus(A,B)
ApuB = mmp_u_plus(A,B)

%% Now try some additions in sparse form
Ax=mmp.x.Sparse(A); An=mmp.n.Sparse(A);
%Check that conversions are okay
all(all((Ax == An) & (Ax == A)))
all(all((An == Ax) & (An == A)))
Bx=mmp.x.Sparse(B);Bn=mmp.n.Sparse(B);
all(all((Bx == Bn) & (Bx == B)))

%% check that lower lass additions in any format are OK
all(all(...
AplB == (Ax + Bx) & ...%maxplus oplusl maxplus
AplB == (Ax + B)& ...%maxplus oplusl full
AplB == (A + Bx)...& ...%maxplus oplusl full
))
AplB == (Ax + Bn);%%maxplus oplul minplus =>%error! This would generate difficult to follow errors


%% check that upper lass additions in any format are OK
all(all(...
ApuB == (An + Bn) &...%minplus oplusu minplus
ApuB == (An + B) &...%minplus oplusu full
ApuB == (A + Bn)...%minplus oplusu full
))
ApuB == (An + Bx);%ERROR!...This would generate difficult to follow errors
%% check that the static lower additions in any format are OK
all(all(...
AplB == mmp.l.plus(Ax, Bx) &...%maxplus oplusl maxplus
AplB == mmp.l.plus(A, Bx) & ...%maxplus oplusl full
AplB == mmp.l.plus(Ax, Bn) &...%maxplus oplul minplus =>%p.full(Ax + Bn)
AplB == mmp.l.plus(An, Bn)...
))
%% check that the static lower additions in any format are OK
all(all(...
ApuB == mmp.u.plus(Ax, Bx) &...%maxplus oplusl maxplus
ApuB == mmp.u.plus(A, Bx) & ...%maxplus oplusl full
ApuB == mmp.u.plus(Ax, Bn) &...%maxplus oplul minplus =>%p.full(Ax + Bn)
ApuB == mmp.u.plus(An, Bx) &...%maxplus oplul minplus =>%p.full(Ax + Bn)
ApuB == mmp.u.plus(An, Bn)...
))
%SO FAR ON 27/07/09
