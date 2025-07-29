function [A,labels]=IntersectionExtents(I)
%Finds the system of extents by intersection
% I should already be clarified.
% A = IntersectionExtents(I) only find the extents
% [A,latt] = IntersectionExtents(I) produces a reduced labelling
% for the attribute concepts (really their extents). For attribute i,
% latt(i) points at the extent of the attribute concept in A.
%
% See concepts.m

% FVA: listing of Changes
%1) Changed so that extents and extents are column vectors, to agree with
%polars in mpfca_ primitives
%2) Decide whether the clarification/reduction is done in this primitive
%or elsewhere! DONE: Clarification is done in clarify.m; some reduction is done here.
%3) Change for operation on either full or sparse matrices.
% 4)Changedinto a primitive for logical matrices and invoke from
% Contexts.
% 5) change to return labels of reduced labelling. DONE
[g, m] =size(I);

%% Initialize variables
%INVARIANT: A(:,1) is the full intent.
%On exit size(A,2) is also the number of concepts.
issparseA = issparse(I);
if issparseA
    A=sparse(true(g,1));%first intent is the full one
else
    A=true(g,1);
end
% Concept index, but actually indexing extents. 
ci=1;
cextent =sparse([g]);%Cardinal of extents. Using sparse helps sometimes.
% array relating attribute id. to extent (concept) id.
labels=zeros(1,m);%There are only m labels to be assigned, one for each column
%c_att_extents = sum(I);%cardinal of att extents for easy pickup!

pending=sum(I);%all pending cols are those with some true bit.
%storing the number of ones allows us to order candidates by maximality

%% Detect null columns
zcols=(pending==0);%detect empty columns. No need to erase them.
% if all(zcols)%empty matrix:
%     %two concepts, top and bottom, all atts at bottom
%     A=[A false(g,1)];%first intent is the full one: second the null one
%     labels(zcols)=2;%all attributes are in the bottom concept
%     return%early termination on empty matrices
% end

%% Detect full columns and erase
% CAVEAT: full column detection should be done AFTER void column detection
tcols=(pending==g);%detect full collumns
if any(tcols)%some top columns, but not all
    labels(tcols)=1;%store labels
    %on any other matrix, erase full columns from pending list of cols
    pending(tcols)=0;%
end

%% early termination for matrices with only full or empty cols.
if all(pending==0)
    if any(zcols)%on empty columns, just add the bottom
        %two concepts, top and bottom, all atts at bottom
        A=[A false(g,1)];%first intent is the full one: second the null one
        labels(zcols)=2;%all attributes are in the bottom concept
    end
    return
end

%% Otherwise, visit partially-filled columns
[nels,m]=sort(full(pending),2,'descend');%m indexes in descending weight order
m=m(nels~=0);%%Take away indices of already erased elements
%nels=nels(nels~=0);%%do not consider erased elements
% PRECONDITION: full or empty extent cannot be in pending cols
for cand = m%heuristic: explore candidate attribute extents by decreasing cardinality
    candextent=I(:,cand);%candidate attribute extent
    card=pending(cand);%its cardinal as a set of objects
    comparable = (cextent == card);%find candidates of same cardinality
    if any(comparable)
        nomatch = any(xor(A(:,comparable),repmat(candextent,1,sum(comparable))));
        if any(~nomatch)%funny way to describe an actual match
            %nomatch has one null position: the intent for cand is already in A,
            pos=find(comparable);%remember full intent was not observed
            %         if any(labels==pos)%that position is already pointed at...
            %             %shouldn't happen if I is column-clarified, but you never know)
            %             warning('fca:logical:concepts',...
            %                 'Matrix is not column-clarified: cols %i and %i are equal',pos,cand);
            %         end
            labels(cand)=pos(~nomatch);
            continue;%go to next cand
        end
    end
    %find all possible new non-void extents. TO DO: take away duplicates?
    %find intersections with all previous extents and include new
    nextents = A;%select all previous extents including full set
    nextents(~candextent,:)=false;%erase where cand tells to! This mimics intersection
    cnextents=sum(nextents);%cardinalities of next extents
    %dispose of empty extents and duplicates
    not_repeated = (cnextents ~=0) & (cnextents ~= card);
    not_repeated(1)=true;
    if all(not_repeated)
        %at least one is non-null, the first one!
        % Add newextent and possibly intersections
        A=[A nextents];
        cextent=[cextent cnextents];
    else
        A=[A nextents(:,not_repeated)];
        cextent=[cextent cnextents(:,not_repeated)];
    end

    % The first added column is the new extent
    ci=ci+1;%promote candidate to new extent %DON'T MOVE UPWARDS BEYOND nextents
    labels(cand)=ci;%annotate for reduced labelling
    
    %Start from the next candidate extent onwards
    while ci < size(A,2)%test the size of the candidate set
        n=ci+1;%for next candidate
        comparable=(cextent == cextent(n));%pre-choose by extent cardinalities.
        nomatch=any(xor(A(:,comparable),repmat(A(:,n),1,sum(comparable))));%at least the candidate itself
        realmatches=find(comparable);%comparable(realmatches(nomatch))=false;
        realmatches=realmatches(~nomatch);
        cextent(realmatches(realmatches > n))=0;%erase candidate extents that match. May be empty.
        if any(realmatches<n)%repeated!this may be only one!
            cextent(n)=0;%mark for erasing candidate too
            tokeep = cextent~=0;
            A=A(:,tokeep);
            cextent=cextent(tokeep);
        else%really a new extent: intersect and extend
            nextents = A(:,2:ci);
            nextents(~A(:,n),:)=false;%erase where cand tells to! This mimics intersection
            ci=n;%just increase by one
            %keep only non-null extensions,but not clones
            tokeep=any(nextents) & (sum(nextents) ~= cextent(n));
            if ~all(tokeep)
                nextents=nextents(:,tokeep);
            end
            tokeep = cextent~=0;
            if ~all(tokeep)
                A=[A(:,tokeep) nextents];
                cextent=[cextent(tokeep) sum(nextents)];
            else
                % Add newextent and possibly intersections
                %The way this addition is done controls the exploration of the
                %lattice!
                A=[A nextents];
                cextent=[cextent sum(nextents)];
            end
        end
    end%While ci 
end%for cand

%% Add the empty intersection only at the end.
% The empty extent is generated unless I has one full row
intersection=all(I,2);
if ~any(intersection)
    if issparseA
        A=[A sparse(g,1)];
    else
        A=[A zeros(g,1)];
    end
    % If there are zero cols, set their labels.
    ci=ci+1;
    if any(zcols), labels(zcols)=ci; end
end
% %Since the empty extent might be generated (not if there are full rows,
% %though) we have to look for it when zero cols exist, to annotate
% if any(zcols)
%     emptyext = (cextent == 0);
%     if any(emptyext)
%         n=find(emptyext);%already extant: just label appropriately.
%     else%there is no empty extent but there should be
%         if issparseA
%             A=[A sparse(g,1)];
%         else
%             A=[A zeros(g,1)];
%         end
%         n=ci+1;
%     end
%     labels(zcols)=n;
% end

%this is the index of the last intent which is only known on exit
%Check that all attributes have been given a concept label.
if any(labels==0)
    error('logical:IntersectionExtents','Not every attribute is  attached to an extent! %i',find(labels==0));
end
return%A,labels

