function [varargout] = mmp_l_paq(a)
% PAQ decomposition of Pathi's
%
% [P,Q]=paq(A), Finds P,Q cell arrays such that A(cell2mat(P),cell2mat(Q))
% is block diagonal maxplus matrix.
%
% [P,Q] are coindexed blocked permutation matrices for the rows and columns
% of A, such that A(P{i},Q{i}) is a block.
% [P,Q,zrows,zcols] = paq(a), finds also the zero rows and columns.
% If length(cell2mat(P))<size(a,1), then A has as many null-rows as the
% difference between the lengths, and these are the missing row numbers in
% [zrows] And likewise, mutatis mutandis with col names and Q, for [zcols].
%
% Author fva: 2005-2009 Based in Pathi's PAQ decomposition.
%
% IMPLEMENTATION NOTE: Although a direct algorithm might be quicker,
% casting to logical and using logical/paq is much simpler

if issparse(a)%we pressupose it is a double.
    la = logical(a);
else
    la = logical(mmp_l_sparse(a));
end
%varargout{:}=paq(la);
% nargout
%l = length(varargout);
switch nargout
    case 2
        [varargout{1},varargout{2}] = paq(la);
    case 4
        [varargout{1},varargout{2},varargout{3},varargout{4}] = paq(la);
    otherwise
        error('Double:mmp_l_paq','Wrong number of output parameters');
end
return

% %test for *both* to be higher than 0 otherwise, early
% %termination.
% [m,n]=size(a);
% %We now operate from 1:m in rows and 1:n in columns only.
% P={};Q={};
% if (m == 0) || (n==0)
%     warning('Double:mmp_l_paq','Already in PAQ form');
%     if m > 0, P={(1:m)}; end
%     if n > 0, Q={(1:n)}; end
%     return
% end
% % zrows=false(1,m);%Holds empty rows
% % bn = 0;%Block number
% % block={};
% % blkidx=[];%stores lower righhand downcorner of block
% % s=0;c=0;%s ranges over rows, c over columns. They signal the righthand
% % %downcorner of block.
% % % At the end c has advanced until the last column of the block
% % % and all the non-nulls in a(s1,:) have been compacted into a
% % % block, and similarly with s and rows.
% % %while s<mnz && c<nnz%mnz, nnz cannot change during this
% % %iteration!
% 
% %while any(rowsleft)% && any(colsleft)
% rowsleft=true(m,1);
% colsleft=true(1,n);
% zrows=sparse(1,m);%Holds empty rows
% while any(rowsleft) && any(colsleft)
% %    bn = bn+1;%New block
%     % find first non empty row left
%     for r=find(rowsleft)',
%         cols=any(a(r,:)~=mp_zero,1);%find non-zero cols
%         if any(cols), break; end
%         zrows(r)=true;%otherwise accumulate in zero rows
%         rowsleft(r,1)=false;%erase from leftrows
%     end
%     %Exit while when cols is empty, we have explored all rowsleft and
%     %found no element. The empty cols are in colsleft
%     if ~any(cols), break; end
%     % find rows of non-zero cols
%     rows=any(a(:,cols)~=mp_zero,2);%non-empty by definition
%     %expand columns until they stabilize
%     exp_cols=any(a(rows,:)~=mp_zero,1);
%     while any(cols ~= exp_cols)
%         cols = exp_cols;
%         rows=any(a(:,cols)~=mp_zero,2);
%         exp_cols=any(a(rows,:)~=mp_zero,1);
%     end
%     %cols,rows have the block columns, rows
%     block{bn}=a(rows,cols);%store the block itself
%     P=[P find(rows')];Q=[Q find(cols)];%store the permutation indices
%     s=s+sum(rows);%indexes of block rows
%     c=c+sum(cols);%indexes of block column
%     blkidx=[blkidx; s c];
%     %Update rows and columns left unexplored
%     colsleft=colsleft & ~cols;
%     rowsleft=rowsleft & ~rows;
% end
% 
% %Finally add zero rows and columns to permutations;
% zrows(rowsleft')=true;%%Add all left pending zero rows
% P=[P find(zrows)];
% Q=[Q find(colsleft)];
% %if sum(zrows)==0 there are no empty rows (but may be empty cols)
% %if sum(colsleft)===0 there are no empty cols (but may be empty rows)
% %% In particular, do NOT ADD an empty block at the end.
% % $$$   s=s+sum(zrows);%indexes of block rows
% % $$$   c=c+sum(colsleft);%indexes of block column
% % $$$   blkidx=[blkidx; s c];%Add last, empty block (may be null matrix)
% b=a(P,Q);%Permute the matrix
% 
% return %P,Q,b,block,blkidx
