function [Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = of_general_digraph(A,rmask,cmask, zrows,zcols)
%function [Lev,Ldiag,Rev,Len,Ren,nodes,Aplus] = of_general_digraph(A,rmask,cmask,zrows,zcols)
%
% A function to obtain all possible left (U) and right
% (V) eigenvectors of a list of spectra belonging to the same matrix, and
% its correlative [nodes] and left and right eigennodes [Len,Ren]. 

%The algorithm tries to find a UFNF_1 for the matrix, that is finding zero
%rows and columns, then invoking itself to do the rest
error(nargchk(1,5,nargin))
[m,n]=size(A);
Aplus=mmp.l.zeros(m);%Build the Aplus, just in case
if nargin == 1%On a first sweep, test the squareness and class of A
    if m~=n
        error('mmp:l:Spectrum:of_general_digraph','Not a square matrix');
    elseif m == 0
        error('mmp:l:Spectrum:of_general_digraph','Empty matrix');
    elseif m == 1%Process directly
        Llamb = A;
        Rlamb=A;
        Lev = 0;
        Rev = 0;
        nodes =1;
        Len = 1;
        Ren = 1;
        return%early termination for scalars
    else
        switch class(A)
            case 'double'
                if issparse(A)
                    error('mmp:l:Spectrum:of_general_digraph','Direct sparse input not allowed to prevent formatting confusions. Use mmp.x.Sparse, etc.');
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
if nargin <= 2%do not believe in partial parameter application
    rmask=sparse(1,1:m,1);%use all rows
    cmask=sparse(1,1:n,1);%use all columns
end
if nargin <= 4%do not believe in partial paramenter application
    [zrows,zcols]=findzeros(A.Reg(rmask,cmask));%find zero rows and cols
end

%May be a raw version is needed from here onwards!
%When there are null columns or rows we build the General Normal Form
if any(zrows | zcols)
    Vi = zrows & zcols;%isolated nodes
    Va = zcols & ~zrows;%initial nodes
    Vw = zrows & ~zcols;%terminal nodes
    Vb = ~(zrows | zcols);%non-initial, non-terminal, non-isolated nodes
    %Either Vi or Va or Vb or any combination of them are non-null
    Na=sum(+Va);
    Ni = sum(+Vi);
    %Nb = sum(+Vb);
    Nw = sum(+Vw);

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %Process isolated vertices
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %Theorem on right and left eigenvectors a) and a') at Vi
%     Len=find(Vi);
%     Ren=Len;%Just copy from one to the other
%     Lev=mmp.l.eye(Ni,m);
%     Rev = Lev.';%Just copy from one to the other
%     Llamb = -Inf(1,Ni);
%     Rlamb = Llamb;%Just copy from one to the other
    
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % process totally initial vertices
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if any(Va)
%         %Theorem on right eigenvectors a) at Va
%         Rlamb=[Rlamb -Inf(1,Na)]; %#ok<NASGU>
%         Ren=[Ren Va];
%         Rev=[Rev mmp.l.eye(m,Na)];
%     end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %process non-initial, non-terminal vertices
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if any(Vb)
        %There might be left eigenvectors for initial nodes and
        %right eigenvectors for terminal nodes
        Leva = mmp.l.zeros(Na,m);
        Revw = mmp.l.zeros(m,Nw);
        %Work out the spectrum of the non-null part
        [Levb,Llambb,Lenb,Revb,Rlambb,Renb,nodesb,Abplus] = mmp.l.Spectrum.of_general_digraph(A(Vb,Vb),Vb,Vb);
        %all return nodes are in the local set, so transform into parent set
        Vb = find(Vb);
        Renb=Vb(Renb);%right critical
        Lenb=Vb(Lenb);%left critical
        nodesb=Vb(nodesb);%This is Vb arranged in Generic and UFNF
        Aplus(nodesb,nodesb)=Abplus;%Store this part of transitive closure
         %THeorem on right eigenvectors, b.1): if Aab is null, only the part due to the Revs of Ab is here 
        extRevb = mmp.l.zeros(m,length(Renb));
        extRevb(nodesb,:)= Revb;
         %THeorem on left eigenvectors, b'.1): if Abw is null, only the part due to the Revs of Ab is here 
        extLevb = mmp.l.zeros(length(Lenb),m);
        extLevb(:,nodesb) = Levb;
        
        % Go on to prepare other eigenvalues
        Aab = A(Va,nodesb);
        nullAab = ~any(Va) | all(all(Aab==mmp.l.zeros));
        %find the conditions where eigenvectors may exist!
        if ~nullAab%When it is not, other conditions need to be tested
            %Theorem on right ev, b.2) a, b and c, all at the same time
            extRevb(Va,:)=mmp.l.mrdivide(mmp.l.mtimes(Aab,Revb), mmp.l.diag(Rlambb));
            Aplus(Va,nodesb)=mmp.l.mtimes(Aab,mmp.l.rclosure(Abplus));
        end
        Abw = A(nodesb,Vw);
        nullAbw = ~any(Vb) | all(all(Abw == mmp.l.zeros));
        if ~nullAbw%when it is not, other conditions need to be tested
            %Theorem on left ev, b'.2) a, b and c, all at the same time
            extLevb(:,Vw)=mmp.l.mldivide(mmp.l.diag(Llambb),mmp.l.mtimes(Levb,Abw));
            Aplus(nodesb,Vw)=mmp.l.mtimes(mmp.l.rclosure(Abplus), Abw);
        end
        
        %default values: may be overwritten below
        Llamba=[];
        Rlambw=[];
        Lena=[];
        Renw=[];
        if ~nullAab && ~nullAbw && all(all(mmp.l.diag(Abplus) >= mmp.l.ones))%this last one is cond2
            Aabw = mmp.l.mtimes(Aab,mmp.l.mtimes(Abplus,Abw));%The reflexive closure is not needed, after cond2
            Aplus(Va,Vw)=mmp.l.plus(Aabw,A(Va,Vw));
            if all(all(Aabw >= A(Va,Vw)))%Condition 1
                %Theorem on left evs. c')
                if any(Va)
                    Lena = find(Va);
                    Llamba = mmp.l.ones(1,Na);
                    Leva=Aplus(Va,:);
%                     Leva(:,Vb)=mmp.l.mtimes(Aab,Abplus);
%                     Leva(:,Vb)=Aplus(Va,Vb)
%                     Leva(:,Vw)=Aabw;
                end
                %Theorem on right evs, c)
                if any(Vw)
                    %obtain the right eigenvectors of the unit eigenvalue for Vw
                    Renw = find(Vw);
                    Rlambw = mmp.l.ones(1,Nw);
                    Revw=Aplus(:,Vb);
%                     Revw(Va,:)=Aabw;
%                     Revw(Vb,:)=mmp.l.mtimes(Abplus,Abw);
                end%else left Rlamb,Rev,Ren untouched
            end
        end
        %Collect all results in a single place
        % a) left and right eigenvectors
        dummy=mmp.l.eye(m);%A dummy construction to select eigenvectors
        Lev = [dummy(Vi,:); Leva(1:length(Lena),:); extLevb; dummy(Vw,:)];
        Rev = [dummy(:,Vi) dummy(:,Va) extRevb Revw(:,1:length(Renw))];        
        %Vb=find(Vb);%substitute characteristic set by set
        Vi=find(Vi);Va=find(Va);Vw=find(Vw);
        % b) Nodes orderes in Generic UFNF
        nodes=[Vi Va nodesb Vw];%We also need the order here!
        % c) Critical left and right eigenvectors
        Len = [Vi Lena Lenb Vw];%We also need the order here!
        Ren = [Vi Va Renb Renw];%We also need the order here!
        % d) left and right eigenvalues
        Llamb = [-Inf(1,Ni) Llamba Llambb -Inf(1,Nw)];
        Rlamb = [-Inf(1,Ni) -Inf(1,Na) Rlambb Rlambw];
    else%no Vb nodes
        nodes=[find(Vi) find(Va) find(Vw)];
        %Collect all results in a single place
        Len = [find(Vi) find(Vw)];
        Ren = [find(Vi) find(Va)];
        Llamb = [-Inf(1,Ni) -Inf(1,Nw)];
        Rlamb = [-Inf(1,Ni) -Inf(1,Na)];
        Lev = [mmp.l.eye(Ni,m); mmp.l.eye(Nw,m)];
        Rev = [mmp.l.eye(m,Ni) mmp.l.eye(m,Na)];
    end%if there are no Vb nodes, then do nothing!
    
    
else%no empty cols or rows: all are Vb we use the Upper Frobenius Normal Form
    [SSPP, subgraphs, orders,AApp] = mmp.l.Spectrum.of_digraph(A);
    %[Levt,Ldiag,Rev,enodes]=mmp.l.Spectrum.UtSV(SSpp{nS})%Cuando hay un sólo componente desconectado.
    [Lev,Llamb,Rev,Len,nodes]=mmp.l.Spectrum.all_evs(SSPP);
    Rlamb = Llamb;%on reducible matrices all classes are right and left spectral
    Ren = Len;
    wsupp=0;
    for s = 1:length(AApp)
        m=size(AApp{s},1);
        ran=wsupp+(1:m);
        Aplus(ran,ran)=AApp{s};
        wsupp=wsupp+m;
    end
end

return% [Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus]
