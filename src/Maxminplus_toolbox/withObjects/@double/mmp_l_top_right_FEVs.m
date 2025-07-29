function [enodes,V]=mmp_l_top_right_FEVs(A)
% function [enodes,V]=mmp_l_top_right_FEVs(A)
%
% A function to find the co-atom FEVs of the lattice of eigenvectors for
% the top eigenvalue of an irreducible matrix [A]
%
% V is the matrix of FEVs one on each column.
%
% This is a development primitive to prepare the way for the sparse ones:
% mmp_l_sp_find_top_right_FEVs
% 
% FVA: Apr 2011
%
% detect places with an Inf in every FEV aka part of the sat supp
%TODO: transform to sparse form!
%satsupp=sparse(any(A==Inf,2));
%satsupp=(any(A==Inf,2));
satsupp=(any(A==Inf,1));
if ~any(satsupp)%this is an error!
    error('double:mmp_l_top_right_FEVs','no top eigenvalue');
end
n = length(satsupp);
if all(satsupp)%a cycle full of tops need not be explored
    enodes=satsupp;
else
    colcovered=satsupp;
%    chosen=sparse(1,n);%null matrix
    chosen=false(1,n);%null matrix
%    finA=sparse(A~=-Inf);%prepare to use many times
    finA=(A~=-Inf);%prepare to use many times
    suppcount= sum(finA(:,colcovered),2);
    while any(suppcount==0)
        nonsuppcount=sum(finA(:,~colcovered),2);%returns the non-covered support count
        %supcount =sum (finA,2)./tobecolcovered;
        %thiscount=nonsuppcount./~suppcount;
        %thiscount(thiscount==0)=Inf;
        %thismin=min(thiscount(thiscount>0));%select rows with positive minimal support
        thismin=min(nonsuppcount(suppcount==0));
        %thismin=min(thiscount);%select rows with the minimal support
        %maybe select rows with the *least* support bigger than zero, of course
        selcols=any(finA(nonsuppcount==thismin,:),1);%select the cols where those are
        chosen=chosen|selcols;
        colcovered= colcovered|selcols;
        suppcount= sum(finA(:,colcovered),2);
    end
    enodes=~chosen;
end
% selcols=+selcols';
% selcols(find(selcols))=Inf;%#ok<FNDSB> %this is a minimal vector
% epos=find(selcols==mmp.l.ones);%positions of unit elements
% nes = size(epos,1);%number of units
% ndx=1:nes;%TO select all but one position of epos
% %All combinations of the basic selcols plus T/e
% %the meet irreducibles are the important ones, since it is a min-plus
% %semimodule.
% %V=repmat(selcols,1,nes+1);
% V=repmat(selcols,1,nes);
% for ne=1:nes
%     V(epos(ndx~=ne),ne)=Inf;
%     %V(epos(ne),ne)=Inf;
% end
if nargout > 1
    V=mmp.u.eye(n);
    V=V(:,enodes);
end
enodes=find(enodes);
return
