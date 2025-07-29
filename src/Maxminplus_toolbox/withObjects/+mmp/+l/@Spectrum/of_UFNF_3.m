function [S,Aplus] = of_UFNF_3(A)
%function [Lev,lambdas,Len,Rev,rhos,Ren,P3,Aplus] = mmp.l.Spectrum.of_UFNF_3(A,rmask,cmask)
%
% A function to obtain all possible left [Lev] and right [Rev] fundamentel
% eigenvectors of a matrix, along with its correlative eigenvalues
% [lambdas, rhos] and left and right eigennodes [Len,Ren].   
%
% Input parameters:
% - [A]: matrix whose spectrum is requested.
% A has the least requisites for any such primitive: it can have zero
% lines, diagonal blocks,  reducible or irreducible form.
%
% - [rmask,cmask]: list of rows, columns to process in A.
%
% Output parameters:
% -[lambdas,rhos]: lists of left, right eigenvalues.
% -[Lev,Rev]: matrices of left(row) and right(column) Fundamental
% eigenvectors.
% -[Len,Ren]: lists of left, right fundamental eigennodes
% -[P3] is the simultaneous row and column permutation rendering A in UFNF_3
% -[Aplus]: transitive closure of A in UFNF_3.
%
%Implementation notes:
% - The algorithm tries to find a UFNF_3 for the matrix, that is finding zero
% rows and columns, then invoking itself to do the rest. 
%
% Invariants, on exit, the eigenequations hold as:
% mmp.l.mtimes(Lev,A(P3,P3))==mmp.l.mtimes(mmp.l.diag(lambdas), Lev)
% mmp.l.mtimes(A(P3,P3),Rev)==mmp.l.mtimes(Rev,mmp.l.diag(rhos))

% CAVEAT: IMPLEMENTATION NOTES
% This should be turned into a function that obtains the spectra and
% another that generates the eigenvalues much in the spirit of
% mmp.l.Spectrum.of_UFNF_2 and
% mmp.l.Spectrum.all_evs below.

error(nargchk(1,1,nargin))
[m,n]=size(A);
if nargin == 1%On a first sweep, test the squareness and class of A
    if m~=n
        error('mmp:l:Spectrum:of_digraph','Not a square matrix');
    elseif m == 0
        error('mmp:l:Spectrum:of_digraph','Empty matrix');
    else
        switch class(A)
            case 'double'
                if issparse(A)
                    error('mmp:l:Spectrum:of_digraph','Direct sparse input not allowed to prevent formatting confusions. Use mmp.x.Sparse, etc.');
                else
                    %A = mmp_x_sparse(A);%Full matrices transformed into sparse ones!
                    A = mmp.x.Sparse(A);
                end
            case 'mmp.x.Sparse'%Do nothing
                %A = A.Reg;%MX sparse encoding
            otherwise
                error('mmp:l:Spectrum:general_spectrum','Wrong input class');
        end
    end
end%if nargin===1
% if nargin < 2%do not believe in partial parameter application
%     rmask=logical(sparse(true(1,m)));%use all rows
% end
% if nargin < 3%do not believe in partial parameter application
%     cmask=logical(sparse(true(1,n)));%use all columns
% end
Aplusrequested =nargout >1;

%Build empty spectrum and Aplus
S = mmp.l.Spectrum();
if Aplusrequested
    Aplus=mmp.l.zeros(m);
end

%find zero rows and cols to see if UFNF_2 is possible
%[zrows,zcols]=findzeros(A(rmask,cmask));
[S.zrows,S.zcols]=findzeros(A);

%%% Create a new one spectrum with no empty lines. This is the product of
%%% the spectra inside
if ~any(S.zrows|S.zcols)%Accepts an UFNF_2
        if Aplusrequested%Only work out the transitive closure if requested.
            [spectra,AApp] = mmp.l.Spectrum.of_UFNF_2(A);
        else
            [S.spectra] = mmp.l.Spectrum.of_UFNF_2(A);
        end%Otherwise, don't find Aplus
    K= length(spectra);%Number of different blocks,
    if K==1%Only one: just replace and return.
        S=spectra{1};
        if Aplusrequested
            Aplus = AApp{1};
        end
    else%many spectra: store and construe new infos.
        S.embedded=spectra;
        if Aplusrequested
            wsupp=0;
            for k = 1:K
                m=size(AApp{k},1);
                ran=wsupp+(1:m);
                Aplus(ran,ran)=AApp{k};
                wsupp=wsupp+m;
            end
        end
    end%if K==1
            
%         [Lev,lambdas,Rev,Len,P3]=mmp.l.Spectrum.all_evs(SSPP);
%         rhos = lambdas;%on reducible matrices all classes are right and left spectral
%         Ren = Len;
else%accepts UFNF_3: call recursively
    %Process null-lines: these generate boolean masks
    Vi = S.zrows & S.zcols;%isolated nodes
    Va = S.zcols & ~S.zrows;%initial nodes
    Vw = S.zrows & ~S.zcols;%terminal nodes
    Vb = ~(S.zrows | S.zcols);

%     %Either Vi or Va or Vb or any combination of them are non-null
%     Na=sum(+Va);
%     Ni = sum(+Vi);
%     Nw = sum(+Vw);
%     Nb=m-Ni-Na-Nw; %prepare processing other eigenvalues
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %Process null eigenvalue
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %Theorem on right null-FEVs eigenvectors at zcols
%     Ren=find(S.zcols);%Maybe null
%     Rev=mmp.l.eye(m,Ni+Na);
%     rhos = mmp.l.zeros(1,Ni+Na);
%     %Theorem on left null-FEVS eigenvectors at zrows
%     Len=find(S.zrows);
%     Lev = mmp.l.eye(Ni+Nw,m);%Just copy from one to the other
%     lambdas = mmp.l.zeros(1,Ni+Nw);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %non-initial, non-terminal, non-isolated nodes
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if Nb ~=0%a cyclic part
        
        %Call recursively to find spectrum of inner Abb matrix
        if Aplusrequested
            [S.embedded,Aplusembedded] = mmp.l.Spectrum.of_UFNF_3(A(Vb,Vb));
        else
            [S.embedded] = mmp.l.Spectrum.of_UFNF_3(A(Vb,Vb));
        end
        
        S.nodes=[find(Vi) find(Va) S.embedded{1}.nodes find(Vw)];%global permutation
        %double(A(nodes,nodes))%is  in UFNF_3
        %Aplus should be in this order?

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
    else
         S.nodes=[find(Vi) find(Va) find(Vb) find(Vw)];%Complete permutation
    end
end

return

% if false
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %process non-initial, non-terminal vertices
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if any(Vb)
%         %There might be left eigenvectors for initial nodes and
%         %right eigenvectors for terminal nodes
%         Leva = mmp.l.zeros(Na,m);
%         Revw = mmp.l.zeros(m,Nw);
%         %Work out the spectrum of the non-null part
%         [Levb,lambdasb,Lenb,Revb,rhosb,Renb,nodesb,Abplus] = mmp.l.Spectrum.of_digraph(A(Vb,Vb),Vb,Vb);
%         %all return nodes are in the local set, so transform into parent set
%         Vb = find(Vb);
%         Renb=Vb(Renb);%right critical
%         Lenb=Vb(Lenb);%left critical
%         nodesb=Vb(nodesb);%This is Vb arranged in Generic and UFNF
%         Aplus(nodesb,nodesb)=Abplus;%Store this part of transitive closure
%          %THeorem on right eigenvectors, b.1): if Aab is null, only the part due to the Revs of Ab is here 
%         extRevb = mmp.l.zeros(m,length(Renb));
%         extRevb(nodesb,:)= Revb;
%          %THeorem on left eigenvectors, b'.1): if Abw is null, only the part due to the Revs of Ab is here 
%         extLevb = mmp.l.zeros(length(Lenb),m);
%         extLevb(:,nodesb) = Levb;
%         
%         % Go on to prepare other eigenvalues
%         Aab = A(Va,nodesb);
%         nullAab = ~any(Va) | all(all(Aab==mmp.l.zeros));
%         %find the conditions where eigenvectors may exist!
%         if ~nullAab%When it is not, other conditions need to be tested
%             %Theorem on right ev, b.2) a, b and c, all at the same time
%             extRevb(Va,:)=mmp.l.mrdivide(mmp.l.mtimes(Aab,Revb), mmp.l.diag(rhosb));
%             Aplus(Va,nodesb)=mmp.l.mtimes(Aab,mmp.l.rclosure(Abplus));
%         end
%         Abw = A(nodesb,Vw);
%         nullAbw = ~any(Vb) | all(all(Abw == mmp.l.zeros));
%         if ~nullAbw%when it is not, other conditions need to be tested
%             %Theorem on left ev, b'.2) a, b and c, all at the same time
%             extLevb(:,Vw)=mmp.l.mldivide(mmp.l.diag(lambdasb),mmp.l.mtimes(Levb,Abw));
%             Aplus(nodesb,Vw)=mmp.l.mtimes(mmp.l.rclosure(Abplus), Abw);
%         end
%         
%         %default values: may be overwritten below
%         lambdasa=[];
%         rhosw=[];
%         Lena=[];
%         Renw=[];
%         if ~nullAab && ~nullAbw && all(all(mmp.l.diag(Abplus) >= mmp.l.ones))%this last one is cond2
%             Aabw = mmp.l.mtimes(Aab,mmp.l.mtimes(Abplus,Abw));%The reflexive closure is not needed, after cond2
%             Aplus(Va,Vw)=mmp.l.plus(Aabw,A(Va,Vw));
%             if all(all(Aabw >= A(Va,Vw)))%Condition 1
%                 %Theorem on left evs. c')
%                 if any(Va)
%                     Lena = find(Va);
%                     lambdasa = mmp.l.ones(1,Na);
%                     Leva=Aplus(Va,:);
% %                     Leva(:,Vb)=mmp.l.mtimes(Aab,Abplus);
% %                     Leva(:,Vb)=Aplus(Va,Vb)
% %                     Leva(:,Vw)=Aabw;
%                 end
%                 %Theorem on right evs, c)
%                 if any(Vw)
%                     %obtain the right eigenvectors of the unit eigenvalue for Vw
%                     Renw = find(Vw);
%                     rhosw = mmp.l.ones(1,Nw);
%                     Revw=Aplus(:,Vb);
% %                     Revw(Va,:)=Aabw;
% %                     Revw(Vb,:)=mmp.l.mtimes(Abplus,Abw);
%                 end%else left rhos,Rev,Ren untouched
%             end
%         end
%         %Collect all results in a single place
%         % a) left and right eigenvectors
%         dummy=mmp.l.eye(m);%A dummy construction to select eigenvectors
%         Lev = [dummy(Vi,:); Leva(1:length(Lena),:); extLevb; dummy(Vw,:)];
%         Rev = [dummy(:,Vi) dummy(:,Va) extRevb Revw(:,1:length(Renw))];        
%         %Vb=find(Vb);%substitute characteristic set by set
%         Vi=find(Vi);Va=find(Va);Vw=find(Vw);
%         % b) Nodes orderes in Generic UFNF
%         nodes=[Vi Va nodesb Vw];%We also need the order here!
%         % c) Critical left and right eigenvectors
%         Len = [Vi Lena Lenb Vw];%We also need the order here!
%         Ren = [Vi Va Renb Renw];%We also need the order here!
%         % d) left and right eigenvalues
%         lambdas = [-Inf(1,Ni) lambdasa lambdasb -Inf(1,Nw)];
%         rhos = [-Inf(1,Ni) -Inf(1,Na) rhosb rhosw];
%     else%no Vb nodes
%         nodes=[find(Vi) find(Va) find(Vw)];
%         %Collect all results in a single place
%         Len = [find(Vi) find(Vw)];
%         Ren = [find(Vi) find(Va)];
%         lambdas = [-Inf(1,Ni) -Inf(1,Nw)];
%         rhos = [-Inf(1,Ni) -Inf(1,Na)];
%         Lev = [mmp.l.eye(Ni,m); mmp.l.eye(Nw,m)];
%         Rev = [mmp.l.eye(m,Ni) mmp.l.eye(m,Na)];
%     end%if there are no Vb nodes, then do nothing!
% else%no empty cols or rows: all are Vb we use the Upper Frobenius Normal Form
%     [SSPP, subgraphs, orders,AApp] = mmp.l.Spectrum.of_UFNF_2(A);
%     %[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
%     [Lev,lambdas,Rev,Len,nodes]=mmp.l.Spectrum.all_evs(SSPP);
%     rhos = lambdas;%on reducible matrices all classes are right and left spectral
%     Ren = Len;
%     wsupp=0;
%     for s = 1:length(AApp)
%         m=size(AApp{s},1);
%         ran=wsupp+(1:m);
%         Aplus(ran,ran)=AApp{s};
%         wsupp=wsupp+m;
%     end
% end
% 
% return% [Lev,lambdas,Len,Rev,rhos,Ren,nodes,Aplus]
