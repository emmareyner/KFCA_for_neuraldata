function [Ut,Ldiag,V,lcnodes,rcnodes,Aplus]=UtSV_of_UFNF_1(S,allevs)
% function [Ut,LDiag,V,lcnodes,rcnodes,Aplus]=mmp.l.Spectrum.UtSV_of_UFNF_1(S,allevs)
%
% function [Ut,LDiag,V,lcnodes,rcnodes,Aplus]=mmp.l.Spectrum.UtSV_of_UFNF_1(S,allevs)
%
% A function to obtain the transposed left eigenvectors [Ut], possibly
% repeated eigenvalues [Ldiag] conindexed with them, right eigenvectors [V] and
% left and right critical nodes [lcnodes,rcnodes], of spectrum [Sp].
%
% Input:
% - [Sp]: a single spectrum structure.
% - [allevs]: an optional parameter demanding to obtain all eigenvectors if
% true and only a basis of eigenvectors for Sp if false. Default is true.
%
% Output:
% - [Ut] : transposed (row indexed) list of left eigenvectors, coindexed with Ldiag.
% If ~allevs, this is a basis for the left eigenspace.
% - [Ldiag]: a list of eigenvalues coindexed with the left and right
% eigenvectors, in descending value order.
% - [V] : column-indexed list of right eigenvectors.
% eigenvectors, coindexed with Ldiag.  If ~allevs, this is a basis for the
% left eigenspace.
% - [cnodes]: the list of critical vectors referred to the original
% columns in A, generating each of the eigenvalues and
% eigenvectors when lambda is finite. Consult Sp.nodes.
%
% If lambda is the top, return the left and right eigennodes in different
% vars.
%
% The eigenequations are (where A is a matrix part of whose spectrum is Sp:
% let Lambda = mpm.l.diag(S);
% mmp.l.eq(mmp.l.mtimes(Ut,A(Sp.nodes,Sp.nodes)),mmp.l.mtimes(Lambda,Ut))
% mmp.l.eq(mmp.l.mtimes(A(Sp.nodes,Sp.nodes),V),mmp.l.mtimes(V,Lambda))
%
%
% FVA, Apr.-Jun. 2008, Sep. 2010
    
% check input values
error(nargchk(1,2,nargin));%unnecessary for objects
%A flag to make comparisons quicker.
if nargin < 2, allevs = true; end%By default produce all eigenvectors
Aplusrequested =nargout >5;

% %% Start real work
% lcnodes = S.lenodes;
% rcnodes = S.enodes;
% 
% if allevs
%         Ut = S.Splus(lcnodes,:);
%         V = S.Splus(:,rcnodes);
%         Ldiag=mmp.l.diag(repmat(S.lambda,1,length(lcnodes)));
% else
%     error('mmp:l:Spectrum:UtSV_of_UFNF_1','Basis selection not implemented');
% end

%% Initialize when Aplus is requested
if Aplusrequested
    %A final sweep to obtain the transitive closure matrix:
    %FVA: this can be done during the initial exploration!! TODO!
    Aplus=mmp.l.zeros(m);
    % wsupp=0;%width of support, to index Aplus
    supp=false(1,m);%support to index A
    wsupp=0;
end

%% We have to do two passes in order to be able to do both left and right
% eigenvalues in this second pass.
%class support holds downstream classes in row csupp(c,:) and upstream
%classes in colum csupp(:,c)
%Only upstream classes are important for the support of revs
nC = length(S.embedded);
for c = 1:nC
    %First we build a support pattern matrix, then we store the
    %eigenvectors and their cycles
    %compsc=comps{c};%sccs nodes
    S0 = S.embedded{c};
    %compsc = S0.nodes;
    nN = size(S0.nodes,2);%Number of nodes in component
    
    %%Now build the eigenvalue piece-wise: insaturated support is
    %%introduced by default in the initialization
    rpat =mmp.l.zeros(m,nN);
    %upstream and unrelated classes belong to the left insaturated support
    lpat = mmp.l.zeros(nN,m);
    
    lambda = Sp.lambdas(c);
    %find upstream and downstream classes
    usc=Sp.order(:,c)';
    dsc=Sp.order(c,:);
    %%downstream classes and unrelated belong to the right
    %%insaturatedsupport
    %rins = ~usc;
    
    if lambda == mmp.l.tops
        %  no dominating classes up- or down-stream.
        domc = (Sp.lambdas == mmp.l.tops);
        %detect all other Inf since they will contribute saturated
        %coordinates.
        if any(~domc)%if there are dominating classes...
            %Choose the biggest lambda as normalizer
            norm = max([Sp.lambdas(~domc) mmp.l.ones]);%Ensure not -Inf!
        else%otherwise, all classes have Inf evalues or this is a single class!
            norm = 0;
        end
        domc(c) = false;%do not consider the present class!
    else%Finite eigenvalue is the most complicated case...
        %find dominating classes for c
        domc = (Sp.lambdas > lambda);
        norm = lambda;
    end
    
    %find dominating upstream & downstream classes
    % For Inf classes these will be other Inf classes
    dom_usc = usc & domc;
    dom_dsc = dsc & domc;
    Sp.ec_above(c)=any(dom_usc);%whether c is upstream dominated
    Sp.ec_below(c)=any(dom_dsc);%whether c is downstream dominated
    
    % To process the support we do not take into consideration
    % this class because we have already calculated its transitive
    % closure (righthand left corner in UFNF).
    rpat(Sp.g2l(compsc),:)=Sp.embedded{c}.Splus;
    usc(c)=false;
    %The values for the finite support of this class
    if any(usc)%if it has any upstream support
        rn = length([S.comps{usc}]);
        rnStar=mmp.l.zeros(rn,rn);
        classes=find(usc);
        k=classes(1);
        supp=S.comps{k};
        nsupp=length(supp);
        ran=(1:nsupp);
        if dom_usc(k)
            %on dominating downstream class: saturate
            rnStar(ran,ran)=Inf;%mmp.l.tops, actually
        else
            %on non-dominated downstream class: finite closure
            %exists!
            rnStar(ran,ran)=mmp.l.finite_trclosure(mmp.l.mrdivide(A(supp,supp),norm));
        end
        ugnsupp=supp;
        gsupp=nsupp;
        %do the rest of the classes, in case there is any!
        for k = 2:length(classes)
            supp = S.comps{classes(k)};
            nsupp=length(supp);
            ran = gsupp+(1:nsupp);
            if dom_usc(classes(k))
                %on dominating downstream class: saturate
                rnStar(ran,ran)=Inf;%mmp.l.tops, actually
            else
                %on non-dominated downstream class: finite closure
                %exists!
                rnStar(ran,ran)=mmp.l.finite_trclosure(mmp.l.mrdivide(A(supp,supp),norm));
            end
            rnStar(1:gsupp,ran)=mmp.l.mtimes(rnStar(1:gsupp,1:gsupp),mmp.l.mtimes(mmp.l.mrdivide(A(ugnsupp,supp),norm),rnStar(ran,ran)));
            ugnsupp=[ugnsupp supp]; %#ok<AGROW>
            gsupp=gsupp+nsupp;
        end
        rpat(Sp.g2l(ugnsupp),:)=mmp.l.mtimes(mmp.l.mtimes(rnStar,mmp.l.mrdivide(A(ugnsupp,compsc),norm)),...
            mmp.l.rclosure(Sp.embedded{c}.Splus));
        %lpat(:,Sp.g2l(dgnsupp))=mmp.l.mtimes(metric_matrices{c},mmp.l.mtimes(mmp.l.mrdivide(A(compsc,dgnsupp),norm),lnStar));
    end%If any(usc)
    
    %Repeart mutatis mutandis for downstream dominated classes and left
    %eigenvectors
    %Store the values for the present class
    lpat(:,Sp.g2l(compsc))=Sp.embedded{c}.Splus;
    dsc(c)=false;%do not consider this class for processing
    if any(dsc)
        ln=length([S.comps{dsc}]);%size of downstream local matrix being built
        lnStar=mmp.l.zeros(ln,ln);
        classes=find(dsc);%non empty
        k=classes(1);
        supp = S.comps{k};
        nsupp=length(supp);
        ran = (1:nsupp);
        if dom_dsc(k)
            %on dominating downstream class: saturate
            lnStar(ran,ran)=Inf;%mmp.l.tops, actually
        else
            %on non-dominated downstream class: finite closure
            %exists!
            lnStar(ran,ran)=mmp.l.finite_trclosure(mmp.l.mrdivide(A(supp,supp),norm));
        end
        dgnsupp=supp;
        gsupp=nsupp;
        %do the rest of the classes, in case there is any!
        for k = 2:length(classes)
            supp = S.comps{classes(k)};
            nsupp=length(supp);
            ran = gsupp+(1:nsupp);
            if dom_dsc(classes(k))
                %on dominating downstream class: saturate
                lnStar(ran,ran)=Inf;%mmp.l.tops, actually
            else
                %on non-dominated downstream class: finite closure
                %exists!
                lnStar(ran,ran)=mmp.l.finite_trclosure(mmp.l.mrdivide(A(supp,supp),norm));
            end
            lnStar(1:gsupp,ran)=mmp.l.mtimes(lnStar(1:gsupp,1:gsupp),mmp.l.mtimes(mmp.l.mrdivide(A(dgnsupp,supp),norm),lnStar(ran,ran)));
            dgnsupp=[dgnsupp supp]; %#ok<AGROW>
            gsupp=gsupp+nsupp;
        end
        lpat(:,Sp.g2l(dgnsupp))=mmp.l.mtimes(mmp.l.rclosure(S0.Aplus),mmp.l.mtimes(mmp.l.mrdivide(A(compsc,dgnsupp),norm),lnStar));
    end
    
    % Find eigennodes and eigenvectors
    for cy=1:size(S.ccycles{c},2)%Go over critical cycles for class
        %Sp.cycles{c}{cy}=compsc(lccycles{cy});
        cn=S.ccycles{c}{cy}(1:end-1);%# cnodes 1 less than cycle size
        S.enodes{c}{cy}=cn;%all critical nodes are eigennodes
        if lambda == Inf
            %Only one different eigenvector per class, only sat or insat
            %support is found, but we keep them for completion's sake
            S.revs{c}{cy}=rpat(:,Sp.g2ml(cn));%All revs are the same
            S.levs{c}{cy}=lpat(Sp.g2ml(cn),:);%all levs are the same
        else
            S.revs{c}{cy}=rpat(:,Sp.g2ml(cn));
            S.levs{c}{cy}=lpat(Sp.g2ml(cn),:);
        end
    end
    %CAVEAT: for each class with apparently some finite support, there
    %is a non-finite support eigenvector for the Inf eigenvalue, the
    %result of multiplying any of the eigenvalues by Inf!
    if Aplusrequested
%         for c=1:nC
%             compsc=comps{c};
            base=1:wsupp;
            ran=wsupp+(1:length(compsc));
            if S.lambdas(c) > 0
                Aplus(ran,ran)=mmp.l.tops;
            else
                Aplus(ran,ran)=S0.Aplus;%metric_matrices{c};
            end
            Aplus(base,ran)=mmp.l.mtimes(Aplus(base,base),mmp.l.mtimes(A(supp,compsc),Aplus(ran,ran)));
            supp(compsc)=true;
            wsupp=ran(end);
%         end
    end%
end%for c=1:nC
return%Lt, Ldiag, R, cnodes

