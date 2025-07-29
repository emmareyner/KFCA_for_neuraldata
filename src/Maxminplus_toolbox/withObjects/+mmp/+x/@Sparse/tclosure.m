function Rplus= tclosure(R)
% OO lower maxplus transitive closure of R
% Warning: on non-definite matrix, this will diverge!
%tclos=mtimes(r,trclosure(r));
Rplus = mtimes(R,trclosure(R));
end
