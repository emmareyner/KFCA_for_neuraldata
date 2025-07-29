function [S] = of_digraph(A,maskperm)
%function [S] = mmp.l.Spectrum.UFNF_3.of_digraph(A)
%
% A function to obtain the lower maxminplus spectrum [S] of a  matrix.
%
% Input parameters:
% - [A]: matrix whose spectrum is requested.
% A has the least requisites for any such primitive: it can have zero
% lines, diagonal blocks,  reducible or irreducible form.
%
% Output parameters:
% -[S]: the spectrum itself
%
%Implementation notes:
% - The algorithm tries to find a UFNF_3 for the matrix, that is finding zero
% rows and columns, then invoking itself to do the rest. The permutation to find the UFNF3 is
% stored in S.nodes

% CAVEAT: IMPLEMENTATION NOTES
% This should be turned into a function that obtains the spectra and
% another that generates the eigenvalues much in the spirit of
% mmp.l.Spectrum.of_UFNF_2 and
% mmp.l.Spectrum.UtSV below.

%% Check input matrix and build empty spectrum
switch nargin
    case 1
        %if nargin == 1, %only do once!
        A = mmp.x.Sparse(A);%Sparsify before processing
        S = mmp.l.Spectrum.UFNF_3(A);%First time processing
        %else%Otherwise nargin = 2
    case 2%For processing successive UFNF_3 forms
        %This has to be created even if the matrix accepts an UFNF_2
        S = mmp.l.Spectrum.UFNF_3(A,maskperm);
    otherwise
        error(nargchk(1,2,nargin))
end
%Detect any non-null lines
Vb = ~(S.zrows | S.zcols);

%if ~any(S.zrows|S.zcols)
if all(Vb)%if all are non-null lines, it accepts an UFNF_2
    S.embedded = mmp.l.Spectrum.UFNF_2.of_digraph(A,Vb);
    %There is no need to translate any information, since it is all in
    %S.embedded!
%         if Aplusrequested%Only work out the transitive closure if requested.
%             [spectra,AApp] = mmp.l.Spectrum.of_UFNF_2(A);
%         else
%             [S.spectra] = mmp.l.Spectrum.of_UFNF_2(A);
%         end%Otherwise, don't find Aplus
%     K= length(spectra);%Number of different blocks,
%     if K==1%Only one: just replace and return.
%         S=spectra{1};
%         if Aplusrequested
%             Aplus = AApp{1};
%         end
%     else%many spectra: store and construe new infos.
%         S.embedded=spectra;
%         if Aplusrequested
%             wsupp=0;
%             for k = 1:K
%                 m=size(AApp{k},1);
%                 ran=wsupp+(1:m);
%                 Aplus(ran,ran)=AApp{k};
%                 wsupp=wsupp+m;
%             end
%         end
%     end%if K==1
            
else%it accepts UFNF_3: call recursively with nargin==2
    %Prepare left and right zero eigenvalues and their eigennodes if
    %this is the outermost spectrum.
    %either S.lenodes or S.renodes may be empty
    if nargin ==1
        S.lenodes={{find(S.zrows)}};%
        S.lambdas = mmp.l.zeros(1,length(S.lenodes));
        S.renodes= {{find(S.zcols)}};%
        S.rhos = mmp.l.zeros(1,length(S.renodes));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %non-initial, non-terminal, non-isolated nodes
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if any(Vb) %there might be a cyclic part, call recursively
        %Call recursively to find possible spectra.
        ES = mmp.l.Spectrum.UFNF_3.of_digraph(A, Vb);
        S.embedded{1} = ES;
 
        Vb = find(Vb);
        %1) Detect and store non-null lambdas of embedded spectrum an their
        %left eigennodes.
        nn_levs = (ES.lambdas ~= mmp.l.zeros);
        if any(nn_levs)
        S.lambdas = [S.lambdas ES.lambdas(nn_levs)];
        %Since they are in the local numbering, we have to renumber them
        %according to Vb
        S.lenodes=[S.lenodes Vb(ES.lenodes(nn_levs))];%
        end
        
        % 2) repeat with right eigenvalues and eigennodes
        nn_revs = (ES.rhos ~= mmp.l.zeros);
        if any(nn_revs)
        S.rhos = [S.rhos ES.rhos(nn_revs)];
        %Since they are in the local numbering, we have to renumber them
        %according to Vb
        S.renodes=[S.renodes Vb(ES.renodes(nn_revs))];%
        end
    %else%Otherwise, there are no cycles in the spectrun, so no non-null evs and evectors.
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
