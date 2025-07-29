function [regp,unitp,topp]=pattern(S)
% [regp,unitp,topp]=p.n.patterns(S) Return the minplus pattern matrices of
% matrix S:
% - [regp], a sparse matrix with the regular elements' pattern (finite
% non-zero).
% - [unitp], a sparse matrix with the pattern of unit elements (0).
% - [topp], a sparse matrix with the pattern of top elements (-Inf).
%
% Note that the pattern of zeroes (Inf) is ~(regp|unitp|topp)
%
% see also: np_sparse, xp_sparse, xnp_full
%
% NOTE: the whole purpose of this primitive is to represent the matrix
% concisely. Hence all results should be sparse, even on full input
% matrices. If you want to make them full for some purpose, do it out of
% this primitive.

% original coding:  FVA 3/03/2009

error(nargchk(1,1,nargin));

if isa(S,'p.sparse')
    regp=logical(S.Reg);%return logical index to regulars
    unitp=S.Unitp;%find units
    if isa(S,'p.n.sparse')%sparse in minplus convention
        topp=S.Topp;%find -Infs
    else%sparse in maxplus convention: CHANGE RESULTS
        topp=~(regp|unitp|S.Topp);%minplus tops are maxplus bottoms
    end
else% full, use minplus convention
    if issparse(S)
        unitp=(S==0.0);
        topp=(S==-Inf);
        botp=(S==Inf);
        regp=~(unitp | botp | topp);
    else%full
        unitp=sparse(S==0.0);
        topp=sparse(S==-Inf);
        regp=(sparse(S~=Inf) & ~unitp & ~topp);%caveat with the zero pat
        %regp=~((S==Inf)|unitp|topp);%S==Inf might be HUGE here
    end
end
return%regp,unitp,topp
