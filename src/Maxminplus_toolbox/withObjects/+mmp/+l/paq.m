function [varargout] = paq(a)
% PAQ decomposition of Pati's
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

%generic way of doing things: transform to logical form with a zero were
%-Inf is in the original.
switch class(a)
    case {'double'}
        la = sparse(a ~= Inf);%Normal encoding
%         if issparse(a)%we pressupose it is a double.
%             la = logical(a);
%         else% it is full
%             %la = logical(mmp_x_sparse(a));
%             la = sparse(a ~= Inf);%Another way of doing the same
%         end
    case 'mmp.x.Sparse'
        la = logical(a.Reg);
%         a = double(a);
%         if issparse(a)%we pressupose it is a double.
%             la = logical(a);
%         else
%             la = logical(mmp_x_sparse(a));
%         end
    otherwise
        error('mmp:l:paq','Unrecognized input object class %s',class(a))
end
%varargout{:}=paq(la);
% nargout
%l = length(varargout);
switch nargout
    case 2
        [varargout{1},varargout{2}] = my.logical.paq(la);
    case 4
        [varargout{1},varargout{2},varargout{3},varargout{4}] = my.logical.paq(la);
    otherwise
        error('mmp:l:paq','Wrong number of output parameters');
end
return
