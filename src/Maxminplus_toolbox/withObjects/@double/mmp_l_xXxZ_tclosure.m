function Rplus = mmp_l_xXxZ_tclosure(R)
% function Rplus = mmp_l_tclosure(R)
%
% Returns the lower transitive (aka metric matrix, A+) closure of a
% non-null square matrix. It uses the transitive reflexive closure, as of
% now. tclosure(X)==mtimes(X,trclosure(X))
%
% For strictly positive elements, it uses an iterative algorithm
% and it may take forever! (A warning is issued.)  
%
% TODO: iterative version of algorithm
% TODO: write iterative version of tclosure, then develop trclosure from
% it. trclosure(X)==tclosure(rclosure(X))
if issparse(R)
    Rplus = mmp_l_xXxZ_mtimes(R,mmp_l_xXxZ_trclosure(R));
else
    error('Double:mmp_l_xXxZ_tclosure','sparse maxplus encoding required');
end
end%Rplus
