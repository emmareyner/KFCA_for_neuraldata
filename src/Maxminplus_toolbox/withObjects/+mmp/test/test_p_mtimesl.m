% test_mmp_times.m
% Script para probar casos de mmp.l.times y mmp.u.times

%% load matrices
load test_matrices

%% obtain the definite matrices issuing from these
AAstarl = mmp.l.mtimes(A,mmp.inv(A))
BBstarl = mmp.l.mtimes(B,mmp.inv(B))
CCstarl = mmp.l.mtimes(C,mmp.inv(C))
DDstarl = mmp.l.mtimes(D,mmp.inv(D))
%%% the other projectors
AstarAl = mmp.l.mtimes(mmp.inv(A),A)
BstarBl = mmp.l.mtimes(mmp.inv(B),B)
CstarCl = mmp.l.mtimes(mmp.inv(C),C)
DstarDl = mmp.l.mtimes(mmp.inv(D),D)
%%%The lower multiplications
AAstaru = mmp.u.mtimes(A,mmp.inv(A))
BBstaru = mmp.u.mtimes(B,mmp.inv(B))
CCstaru= mmp.u.mtimes(C,mmp.inv(C))
%%caveat: CCstarl == CCstaru in this example.
DDstaru= mmp.u.mtimes(D,mmp.inv(D))
%%% the other projectors
AstarAu = mmp.u.mtimes(mmp.inv(A),A)
BstarBu= mmp.u.mtimes(mmp.inv(B),B)
CstarCu = mmp.u.mtimes(mmp.inv(C),C)
DstarDu = mmp.u.mtimes(mmp.inv(D),D)

%% on finite matrices, products are the same
all(all(...
    CCstarl == CCstaru &...%coincidence
    BBstarl == BBstaru &...
    AAstarl == AAstaru...
 ))
 % on non-finite matrices, products are different
any(any(...
    DDstarl ~= DDstaru...
    ))

%% max encoding for lower multiply
AAstarlx = mmp.l.mtimes(Ax,Axinv);
BBstarlx = mmp.l.mtimes(Bx,Bxinv);
CCstarlx = mmp.l.mtimes(Cx,Cxinv);
DDstarlx = mmp.l.mtimes(Dx,Dxinv);

%% %Check that lower multiplications are OK
all(all(...
    BBstarl == BBstarlx &...
    CCstarl == CCstarlx  &...
    AAstarl == AAstarlx...
 )) && ...
all(all(...
    DDstarl == DDstarlx...
 ))

%% the other projections
AstarAlx = mmp.l.mtimes(Axinv,Ax);
BstarBlx = mmp.l.mtimes(Bxinv,Bx);
CstarClx = mmp.l.mtimes(Cxinv,Cx);
DstarDlx = mmp.l.mtimes(Dxinv,Dx);

%% %Check that lower multiplications are OK
all(all(...
    BstarBl == BstarBlx &...
    AstarAl == AstarAlx...
 )) && ...
all(all(...
    CstarCl == CstarClx...
 )) && ...
all(all(...
    DstarDl == DstarDlx...
 ))

%% min encoding and lower multiply
AAstarln = mmp.l.mtimes(An,Aninv);
BBstarln = mmp.l.mtimes(Bn,Bninv);
CCstarln = mmp.l.mtimes(Cn,Cninv);
DDstarln = mmp.l.mtimes(Dn,Dninv);

%% Check that lower multiplications are OK
all(all(...
    BBstarl == BBstarln &...
    CCstarl == CCstarln  &...
    AAstarl == AAstarln...
 )) && ...
all(all(...
    DDstarl == DDstarln...
 ))
%%% SO FAR 09/09/09
%% max encoding for upper multiply
AAstarux = mmp.u.mtimes(Ax,Axinv);
BBstarux = mmp.u.mtimes(Bx,Bxinv);
CCstarux = mmp.u.mtimes(Cx,Cxinv);
DDstarux = mmp.u.mtimes(Dx,Dxinv);

%%%Check that lower multiplications are OK
all(all(...
    BBstaru == BBstarux &...
    CCstaru == CCstarux  &...
    AAstaru == AAstarux...
 )) && ...
all(all(...
    DDstaru == DDstarux...
 ))

%% min encoding and lower multiply
AAstarun = mmp.u.mtimes(An,Aninv);
BBstarun = mmp.u.mtimes(Bn,Bninv);
CCstarun = mmp.u.mtimes(Cn,Cninv);
DDstarun = mmp.u.mtimes(Dn,Dninv);

%%%Check that lower multiplications are OK
all(all(...
    BBstaru == BBstarun &...
    CCstaru == CCstarun  &...
    AAstaru == AAstarun...
 )) && ...
all(all(...
    DDstaru == DDstarun...
 ))

% %% MXPLUS encoding upper multiply and check
% 
% full(AAstarlx.Reg)
% %full(p.x.sparse.plus@p.x.sparse(Ax,Ax')== (Ax + Ax'))
% Axct = Ax'
% An = mmp.n.sparse(A)
% 
% %multiply two full matrices
% tic; A2=mmmmp.l.mtimes(A,A); toc
% 
% %%multiply two maxplus sparse matrices
% tic; A2x=mmmmp.l.mtimes(Ax,Ax); toc
% tic; A2n=mmmmp.l.mtimes(An,An); toc
% 
% %A2prime=p.full(A2x)
% tic
% all(all(A2==A2x))
% toc
% %A2nprime=p.full(A2n)
% tic
% all(all(A2n==A2n))
% toc
% %% tests for equality in different representations
% all(all(A2x==A2n))
% all(all(A2n==A2x))
% all(all(A2 == A2x))
% all(all(A2n==A2))
% all(all(A2==A2n))
% 
% 
% %mpower: full matrices
% %caveat, the equalities below work with matrix powers!!
% all(all(mmp.l.mtimes(10,B)==A))
% all(all(mmp.l.mtimes(B,10)==A))
% 
% %% Tests for sparse and full primitives
% %A with INf, -Inf
% %TODO: prepare  a checkeq primitive.
% A=[0 -Inf -Inf; Inf 0 -Inf; Inf Inf 0]
% Ax=p.x.sparse(A);
% if ~all(Ax==A),
%     warning('p.x.sparse strange');
% end
% An=p.n.sparse(A);
% if ~all(An==A),
%     warning('p.n.sparse strange');
% end
% 
% % Test scalar operations
% InfA=mmp.l.mtimes(Inf,A);
% AInf=mmp.l.mtimes(A,Inf);
% if ~all(InfA==AInf),
%     warning('mmp.l.mtimes strange');
% end
% 
% mInfA=mmp.l.mtimes(-Inf,A)%==xp_zeros(3)
% mAInf=mmp.l.mtimes(A,-Inf)%==xp_zeros(3)
% if ~all(mInfA==mAInf),
%     warning('mmp.l.mtimes strange');
% end
% if ~all(-Inf(size(A))==mAInf),
%     warning('mmp.l.mtimes strange');
% end
% 
% % %Check patterns in maxplus convention
% % [nzA,uA,tA]=xp_patterns(A);
% % [nzAxp,uAxp,tAxp]=xp_patterns(Ax);
% % if any(any(nzA~=nzAxp)), warning('A non-zero maxplus patterns strange'); end
% % if any(any(uA~=uAxp)), warning('A unit maxplus  patterns strange'); end
% % if any(any(tA~=tAxp)), warning('A top maxplus  patterns strange'); end
% % 
% % [nzAnp,uAnp,tAnp]=xp_patterns(An);
% % if any(any(nzA~=nzAnp)), warning('A non-zero maxplus  patterns strange'); end
% % if any(any(uA~=uAnp)), warning('A unit maxplus  patterns strange'); end
% % if any(any(tA~=tAnp)), warning('A top maxplus  patterns strange'); end
% % 
% % %Check patterns in minplus convention
% % [nzA,uA,tA]=np_patterns(A);
% % [nzAxp,uAxp,tAxp]=np_patterns(Ax);
% % if any(any(nzA~=nzAxp)), warning('A non-zero maxplus patterns strange'); end
% % if any(any(uA~=uAxp)), warning('A unit maxplus  patterns strange'); end
% % if any(any(tA~=tAxp)), warning('A top maxplus  patterns strange'); end
% % 
% % [nzAnp,uAnp,tAnp]=np_patterns(An);
% % if any(any(nzA~=nzAnp)), warning('A non-zero maxplus  patterns strange'); end
% % if any(any(uA~=uAnp)), warning('A unit maxplus  patterns strange'); end
% % if any(any(tA~=tAnp)), warning('A top maxplus  patterns strange'); end
% 
% %% Tests for mmp.l.mtimes
% %B with INf, -Inf
% B=A'
% Bx=p.x.sparse(B);
% Bn=p.n.sparse(B);
% 
% tic
% AB  = mmp.l.mtimes(A,B)
% ABx  = mmp.l.mtimes(A,Bx)
% ABn  = mmp.l.mtimes(A,Bn)
% AxB  = mmp.l.mtimes(Ax,B)
% AnB  = mmp.l.mtimes(An,B)
% AxBx= mmp.l.mtimes(Ax,Bx)
% AxBn= mmp.l.mtimes(Ax,Bn)
% AnBx= mmp.l.mtimes(An,Bx)
% AnBn= mmp.l.mtimes(An,Bn)
% toc
% 
% AB==ABx & ...
% AB==AxB & ...
% AB==ABn & ...
% AB==AnB
% 
% AB==AxBx & ...
% AB==AxBn & ...
% AB==AnBx & ...
% AB==AnBn
