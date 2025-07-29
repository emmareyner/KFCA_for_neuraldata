function [Kout]=clarify(Kin)
%function [Kout]=clarify(Kin)
%
% Clarifies a maxplus formal context. Clarification, in K-FCA refers to
% the incidence not having full bottom rows or columns. These are
% always sent to the bottom or top concept.
%
% - Kin is the input boolean context
% - Kout is the output boolean context with:
%    - Kout.R is the same as K.R
%    - Kout.iG and Kout.iM are the indexes that allow to select the
%    clarified matrix from Kout.I
%    - Kout.g and Kout.m are also modified to reflect the dimensions of
%    the clarified context.
%    - Kout.qG and Kout.qM 
%       - Kout.qG is a (1 x size(Kout.R,1) row each of whose cells says to
%       which class the row indexed by that cell belongs. Those cols
%       tagged with -Inf are rows initially set to mp_zero in Kout.R
%       - Kout.qM is a (1 x size(Kout.R,2) row each of whose cells says to
%       which class the column indexed by that cell belongs. Those cols
%       tagged with -Inf are columns initially set to mp_zero in Kout.R
%
if Kin.clarified
    warning('fca:mmp:Context:clarify','Input context already clarified: nothing done');
    Kout = Kin;
    return
end
Kout = clarify@fca.Precontext(Kin);


%% Do a PAQ decomposition, in blocks
[P,unused,zrows,zcols]=mmp.l.paq(Kout.R);%works on doubles and mmp.x.Sparse

%% process the -Inf on rows and cols
if any(zrows)
    Kout.iG(zcols)=false;%Clarify -Inf rows
    Kout.qG(zrows)=-Inf;%just a funny indicator
end
if any(zcols)
    Kout.iM(zcols)=false;%Clarify -Inf cols
    Kout.qG(zcols)=-Inf;%just a funny indicator
end

%% Testing for full rows, i.e. rows filled with TOPS (hence trows)
nblocks = length(P);%number of diagonal blocks
%when there is more than just one block or any zero col, there can be no
%full rows, so crows are just those returned by P.
if (nblocks == 1) && ~any(zcols)
    trows=all(Kout.R(Kout.iG,Kout.iM)==Inf,2);%referring to crows%Kin.R(crows,ccols)
    if any(trows)%These have to be clarified, i.e. disappear.
        crows=find(Kout.iG);
        trows=crows(trows);%translate to global indices
        Kout.iG(trows)=false;
        Kout.qG(trows)=Inf;%just a mnemonic
    end
end
%crows=xor(crows,trows);

%And similarly with cols
if (nblocks ==1) && ~any(zrows)
    tcols=all(Kout.R(Kout.iG,Kout.iM)==Inf,1)';%referrring to ccols
    if any(tcols)%these have to be clarified
        ccols=find(Kout.iM);
        tcols=ccols(tcols);
        Kout.iM(tcols)=false;
        Kout.qM(trows)=Inf;%just a mnemonic
    end
end

%FVA: 25/05/2011, there is no real reason to do the clarification for
%maxplus matrices. On average there is not going to real any real speed
%gain in this case, as opposed to the boolean case.
return

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.- For the remaining rows and columns: collapse identical ones
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Process the rows to obtain the actually clarified rows
prows=Kout.iG;%copy in pending rows, prows
pcols=Kout.iM;%Avoid indexing
grows=find(prows);%global rows
crows=logical(sparse(Kout.g,1));%stores non-clarified rows
%while any(prows)
for row=grows'
    if prows(row)
        crows(row)=true;%this will be rep of clarified rows
        prows(row)=false;
        eqrows=all(Kout.R(prows,pcols)==repmat(Kout.R(row,pcols),sum(prows),1));
%         eqrows=all(...
%             (Kout.R(prows,pcols) == (ones(sum(prows),1) * Kout.R(row,pcols))),2);
        if any(eqrows)
            eqrows=grows(eqrows);%global equal rows now
            Kout.qG(eqrows)=row;%And Kout.qG(row)=row already   done
            prows(eqrows)=false;%not including row
        end
    end
end
Kout.iG = crows;%new virtual index
%Kout.g = sum(crows);

%% Now repeat with columns and attribute index
%crows is already equal to Kout.iG, pcols==Kout.iM
prows=crows;
gcols=find(pcols);%global cols before clarification
ccols=logical(sparse(Kout.m,1));
for col=gcols'%this is the only place where this is valid, since there is no clarification done as yet.
    if pcols(col)
        ccols(col)=true;%keep col and its name for clarification class
        pcols(col)=false;
        eqcols=all((Kout.R(prows,pcols) == Kout.R(prows,col) * ones(1,sum(pcols))));
        if any(eqcols)
            eqcols=gcols(eqcols);%global equal cols now
            Kout.qG(eqcols)=col;%always done, including row
            pcols(eqcols)=false;%not including row
        end
    end
end
Kout.iM = ccols;
%Kout.m = sum(ccols);
return


