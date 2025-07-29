function [enodes,V]=mmp_l_top_right_FEVs(A)
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
error(nargchk(nargin,1,1));
%% try to detect places with an Inf in every FEV
%infpat = A==Inf
%insatsupp = any(infpat,2)
%TODO: transform to sparse form!
%finA=sparse(A~=-Inf);%prepare to use many times
%tobecovered=sparse(~any(A==Inf,2));
satsupp=any(A==Inf,2);
tobecovered=(~satsupp);
finA=(A~=-Inf);%prepare to use many times
suppcount=sum(finA,2);%returns the support count
while any(tobecovered)
    %supcount =sum (finA,2)./tobecovered;
    [thismin,selrows]=min(suppcount./tobecovered);%select rows with the minimal support
    %maybe select rows with the *least* support bigger than zero, of course
    selcols=any(finA(selrows,:));%select the cols where those are
    tobecovered= tobecovered|~any(finA(:,selcols),2);
end
enodes=~selcols;
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
    n=size(A,1);
    V=mmp.u.eye(n);
    V=V(:,enodes);
end
return
