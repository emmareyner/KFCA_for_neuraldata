function [Y] = diag(vec,offset)
% mmp.u.diag min-plus diagonal matrices and diagonals of a matrix. Tries to
% follow the diag convention. mmp.u.diag tries to keep the base type of
% vec.
%
%     mmp.u.diag(V,K) when V is a vector with N components is a square matrix
%     of order N+ABS(K) with the elements of V on the K-th diagonal. K = 0
%     is the main diagonal, K > 0 is above the main diagonal and K < 0
%     is below the main diagonal. The result is min-plus sparse.
%  
%     mmp.u.diag(V) is the same as mmp.u.diag(V,0) and puts V on the main diagonal.
%  
%     mmp.u.diag(X,K) when X is a matrix is a column vector formed from
%     the elements of the K-th diagonal of X, inheriting the sparse of full
%     status from the parent matrix.
%  
%     mmp.u.diag(X) is the main diagonal of X. mmp.u.diag(mmp.u.diag(X)) is a
%     diagonal min-plus sparse matrix. 
  
%%Author: fva, 25/02/09
 
% Validate and preprocess args
switch nargin
    case 1
        offset=0;
    case 2%Do nothing
        if ~isscalar(offset)
            error('mmp:n:Sparse:diag','Non-scalar diagonal selection parameter');
        end
    otherwise%at least two arguments.
        error(nargchk(1,2,nargin));
end

% dispatch
% dispatch
Y = mmp.n.Sparse();
switch class(vec)
    case 'double'
        Y.Reg = mmp_u_spdiag(vec,offset);
    case 'mmp.n.Sparse'
        Y.Reg = mmp_u_spdiag(vec.Reg,offset);
    otherwise
        error('mmp:n:Sparse:diag','Wrong input class type');
end
return%Y


%process first argument.
% spinput=isfield(vec,'xpsp');
% if spinput,
%     siz = size(vec.reg);
% else
%     siz = size(vec);
% end
siz = size(vec);
%process second arg
switch nargin
    case 1
        offset=0;
    otherwise%at least two arguments.
        if ~isscalar(k),
            error('mmp.u.diag: non-scalar K parameter');
        end
        offset=k;
end

%1) Construction primitives
if any(siz==1)%it IS a vector: return a diagonal matrix
    %process third argument: Sparse return by default
    spoutput = (nargin < 3) || ~strcmp(type,'full');

    nm=max(siz);
    co=1:nm;
    dim=nm+abs(offset);
    if offset >= 0%Build a linear index
        idx=sub2ind([dim dim],co,(co+offset));
    else
        idx=sub2ind([dim dim],co+abs(offset),co);
    end
    if spoutput,
        [Vregp,Vunitp,Vtopp]=mmp.u.patterns(vec);
        Y=mmp.u.zeros(dim);%Adequate dimensions
        Y.Topp(idx(Vtopp))=true;
        Y.Unitp(idx(Vunitp))=true;
        if isa(vec,'mmp.sparse')
            Y.Reg(idx(Vregp))=vec.Reg(idx(Vregp));
        else
            Y.Reg(idx(Vregp))=vec(idx(Vregp));
        end
    else
        Y =Inf(dim);%Square matrix all Infs
        Y(idx)=vec;
    end

%2 Extraction primitives
else%Consider case where extraction occurs, i.e. vec is not a vector
    if isa(vec,'mmp.sparse')
        Y=mmp.u.zeros(size(vec));
        Y.Reg=diag(vec.Reg,offset);
        Y.Unitp=diag(vec.Unitp,offset);
        Y.Topp=diag(vec.Topp,offset);
%         Y.xpsp=vec.xpsp;
%         Y.reg=diag(vec.reg,offset);
%         Y.unitp=diag(vec.unitp,offset);
%         Y.topp=diag(vec.topp,offset);
    else
        spoutput=(nargout ==3) && strcmp(type,'sparse');
        if spoutput
            Y=mmp.n.sparse(diag(vec,offset));
        else
            Y = diag(vec,offset);%return diag, but full!
        end
    end
end
return%Y

