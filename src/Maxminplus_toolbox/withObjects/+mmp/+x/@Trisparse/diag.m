function [Y] = diag(vec,k,type)
% p.l.diag Maxplus diagonal matrices and diagonals of a matrix.
%     p.l.diag(V,K) when V is a vector with N components is a square matrix
%     of order N+ABS(K) with the elements of V on the K-th diagonal. K = 0
%     is the main diagonal, K > 0 is above the main diagonal and K < 0
%     is below the main diagonal. The result is maxplus sparse.
%  
%     p.l.diag(V) is the same as np_diag(V,0) and puts V on the main diagonal.
%  
%     p.l.diag(X,K) when X is a matrix is a full column vector formed from
%     the elements of the K-th diagonal of X.
%  
%     p.l.diag(X) is the main diagonal of X. p.l.diag(p.l.diag(X)) is a
%     maxplus diagonal matrix (elements off the diagonal are -Inf). 
  
%%Author: fva, 25/02/09
 
%check parameters
error(nargchk(1,3,nargin));

%process first argument.
% spinput=isfield(vec,'xpsp');
% if spinput,
%     siz = size(vec.reg);
% else
%     siz = size(vec);
% end

%process second arg
switch nargin
    case 1
        offset=0;
    otherwise%at least two arguments.
        if ~isscalar(k),
            error('p:l:diag','Non-scalar diagonal selection parameter');
        end
        offset=k;
end

%1) Construction primitives
siz=size(vec);
if any(siz==1)%it IS a vector: return a diagonal matrix built out of it
    %process third argument: Sparse return by except when emulating builtin
    %diag on full matrices
    spoutput = (nargin < 3) || ~strcmp(type,'full');
    %find the index on the diagonal elements in the matrix.
    nm=max(siz);
    co=1:nm;
    dim=nm+abs(offset);
    if offset >= 0%Build a linear index
        idx=sub2ind([dim dim],co,(co+offset));
    else
        idx=sub2ind([dim dim],co+abs(offset),co);
    end
    if spoutput,
        [Vregp,Vunitp,Vtopp]=p.x.patterns(vec);
        Y=p.l.zeros(dim);%Adequate dimensions
        Y.Topp(idx(Vtopp))=true;
        Y.Unitp(idx(Vunitp))=true;
        if isa(vec,'p.sparse')
            Y.Reg(idx(Vregp))=vec.Reg(idx(Vregp));
        else
            Y.Reg(idx(Vregp))=vec(idx(Vregp));
        end
    else
        Y =-Inf(dim);%Square matrix all Infs
        Y(idx)=vec;
    end

%2 Extraction primitives: create a vector with the idx
else%Consider case where extraction occurs, i.e. vec is not a vector
    if isa(vec,'p.sparse')
        Y=p.l.zeros(size(vec));
        Y.Reg=diag(vec.Reg,offset);
        Y.Unitp=diag(vec.Unitp,offset);
        Y.Topp=diag(vec.Topp,offset);
    else
        spoutput=(nargout ==3) && strcmp(type,'sparse');
        if spoutput
            Y=p.x.sparse(diag(vec,offset));
        else
            Y = diag(vec,offset);%return lower diag, but full!
        end
        %TODO: maybe better return maxplus encoded diagonal?
        %TODO: maybe better define indexing on maxplus encoded sparse
        %matrices?
    end
end
return%Y

