function  [Ut,Ldiag,V,Rdiag]=UtSV(S,allevs)

%% Decide whether we have to return lambda values or not.
Ldiag = mmp.l.diag(S.lambdas);
Rdiag = mmp.l.diag(S.rhos);

%         Vb_set=find(Vb);%global nodes
%         %Since it may have zerolines, we have to dispose of them adequately
%         %Select only non-null right eigenvectors and eigenvalues
%         rvalid = (rhosb ~= mmp.l.zeros);%These are referred to the order in Vb
%         %a) Add non-null eigenvalues
%         rhos=[rhos rhosb(rvalid)];
%         %b) Add eigennodes for non-null eigenvalues
%         Ren=[Ren Vb_set(Renb(rvalid))];
%         %c) complete FEVs for non-null eigenvalues
%         extendedRevb = mmp.l.zeros(m,sum(rvalid));
%         extendedRevb(nodesb,:)=Revb(:,rvalid);%Only work with the validated revs.
%         if Na~=0%only extend when Aab is of non-zero dim
%             %nbl=Renb(rvalid);%eigen-nodes of non-zero eigenvalues, local
%             %nbg=Vb_set(nbl);%eigen-nodes of non-zero eigenvalues, global
%             Aablocal = A(Va,nodesb);%select block and reorder 
%             for nb=find(rvalid)%eigen-nodes of non-zero eigenvalues, micro local 
%                 extendedRevb(Va,nb)=mmp.l.mtimes(Aablocal,mmp.l.mrdivide(Revb(:,nb),rhosb(nb)));
%             end
%         end
%         Rev=[Rev extendedRevb(P3,:)];
%         %[mmp.l.mtimes(A(P3,P3),Rev) mmp.l.mtimes(Rev,mmp.l.diag(rhos))]
%         %full(mmp.l.mtimes(A(P3,P3),Rev) ==mmp.l.mtimes(Rev,mmp.l.diag(rhos)))
%         
%         %Proceed similarly with left eigenvalues and eigenvectors.
%         lvalid = (lambdasb ~= mmp.l.zeros);
%         %a) Add non-null eigenvalues
%         lambdas=[lambdas lambdasb(lvalid)];
%         %b) Add eigennodes for non-null eigenvalues
%         Len=[Len Vb_set(Lenb(lvalid))];
%         %c) complete FEVs for non-null eigenvalues
%         %completedAbplus = [ mmp.l.zeros(Nb,Ni+Na) Abplus mmp.l.mtimes(Abstar,A(Vb,Vw))];
%         %Lev=[Lev completedAbplus(lvalid,:)];
%         extendedLevb = mmp.l.zeros(sum(lvalid),m);
%         extendedLevb(:,nodesb)=Levb(rvalid,:);%Only work with the validated revs.
%         if Nw~=0%only extend when Aab is of non-zero dim
%             %nbl=Renb(rvalid);%eigen-nodes of non-zero eigenvalues, local
%             %nbg=Vb_set(nbl);%eigen-nodes of non-zero eigenvalues, global
%             Abwlocal = A(nodesb,Vw);%select block and reorder 
%             for nb=find(rvalid)%eigen-nodes of non-zero eigenvalues, micro local 
%                 extendedLevb(nb,Va)=mmp.l.mtimes(mmp.l.mldivide(lambdasb(nb)),Levb(nb,:),Abwlocal);
%             end
%         end
%         Lev=[Lev; extendedLevb(:,P3)];
%         %[mmp.l.mtimes(Lev,A(P3,P3)); mmp.l.mtimes(mmp.l.diag(lambdas),Lev)]
%         %full(mmp.l.mtimes(Lev,A(P3,P3))==mmp.l.mtimes(mmp.l.diag(lambdas),Lev))
%         
%     else%if ~any(Vb) 

%% se generan los autovalores
n = length(S.nodes);
Ut = mmp.l.zeros(length(S.lenodes),n);
V=mmp.l.zeros(n,length(S.renodes));

return%[Ut,Ldiag,V,lenodes,renodes]
