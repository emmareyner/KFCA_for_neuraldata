% Maxminplus upper operations and special matrices
%
% 1. Relations
% mmp.u.eq
%
% 2. Special matrices (0-ary constructors)
% mmp.u.eye - upper identity matrix (diagonal zero, rest is -Inf)
% mmp.u.diag - diagonal building and extracting primitive
% mmp.u.ones - all-mmp.ones matrix (all 0)
% mmp.u.zeros - all-mmp zeros matrix (all -Inf)
%
% 3. Operations:
% 3. 1) unitary
% mmp.u.rclosure - upper reflexive closure (i.e. A+I)
% mmp.u.tclosure - upper transitive closure (i.e. A+)
% mmp.u.uplus - upper unary plus aka mmp.u.tclosure (i.e. A+)
% mmp.u.trclosure - upper transitive-reflexive closure (i.e. A*)
% 3.2) external
% mmp.u.stimes - scalar x matrix multiplication
% mmp.u.mpower - upper matrix power (only scalar exponents)
% 3.3) Binary ops
% mmp.u.mtimes - upper matrix multiplication
% mmp.u.plus - upper matrix addition
% mmp.u.sum - upper matrix accumulation function
% mmp.u.mldivide - upper left matrix divide (residuation)
% mmp.u.mrdivide - upper right matrix divide (residuation)
%
% 4. Decompositions
% mmp.u.paq - Patil's PAQ decomposition (diagonal of non-zero blocks)
%
% 5. Not to be used by casual users:
% mmp.u.eigenspace_irreducible2 - Irreducible space decomposition operator
%

