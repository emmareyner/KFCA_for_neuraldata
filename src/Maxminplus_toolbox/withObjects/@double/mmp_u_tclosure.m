function Rplus = mmp_u_tclosure(R)
% function Rplus = mmp_u_tclosure(R)
%
% Returns the upper transitive (aka metric matrix, A_+) closure of a
% non-null square matrix. It uses the upper transitive reflexive closure,
% tclosure(X)==mtimes(X,trclosure(X))
%
% For strictly negative elements, it uses an iterative algorithm
% and it may take forever! (A warning is issued.)  
%
% TODO: iterative version of algorithm
% TODO: write iterative version of tclosure, then develop trclosure from
% it. trclosure(X)==tclosure(rclosure(X))
if issparse(R)
    %generate error on sparse matrices, which should be treated with
    %mmp_l_x???_tclosure primitives.
    error('Double:mmp_u_tclosure','full encoding required');
else
    Rplus = mmp_u_mtimes(R,mmp_u_trclosure(R));
end
end%Rplus
