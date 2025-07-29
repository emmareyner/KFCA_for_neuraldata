% Maxminplus lower operations and special matrices
%
% 1. Relations
% mmp.l.eq
%
% 2. Special matrices (0-ary constructors)
% mmp.l.eye - lower identity matrix (diagonal zero, rest is -Inf)
% mmp.l.diag - diagonal building and extracting primitive
% mmp.l.ones - all-mmp.ones matrix (all 0)
% mmp.l.zeros - all-mmp zeros matrix (all -Inf)
%
% 3. Operations:
% 3. 1) unitary
% mmp.l.rclosure - lower reflexive closure (i.e. A+I)
% mmp.l.tclosure - lower transitive closure (i.e. A+)
% mmp.l.uplus - lower unary plus aka mmp.l.tclosure (i.e. A+)
% mmp.l.trclosure - lower transitive-reflexive closure (i.e. A*)
% 3.2) external
% mmp.l.stimes - scalar x matrix multiplication
% mmp.l.mpower - lower matrix power (only scalar exponents)
% 3.3) Binary ops
% mmp.l.mtimes - lower matrix multiplication
% mmp.l.plus - lower matrix addition
% mmp.l.sum - lower matrix accumulation function
% mmp.l.mldivide - lower left matrix divide (residuation)
% mmp.l.mrdivide - lower right matrix divide (residuation)
%
% 4. Decompositions
% mmp.l.paq - Patil's PAQ decomposition (diagonal of non-zero blocks)
%
% 5. Not to be used by casual users:
% mmp.l.eigenspace_irreducible2 - Irreducible space decomposition operator
%
