function Rstar = trclosure(R)
% function Rstar = trclosure(R)
%
% Returns the transitive-reflexive (aka star, A*) closure of a non-null square
% matrix. If all the elements in the matrix are non-positive this is
% waaaaay more quick than mp_star.
%
% For strictly positive elements, it uses an iterative algorithm
% and it may take forever! (A warning is issued.)  
%
% See also, mp_star for the original version in the toolbox.
error(nargchk(1,1,nargin));

% Two considerations pulling in different directions:
% - Stars with positive elements will almost always end up with a
%number of Infs. Sometimes it will be better to represent them in
%minplus encoding
% - Since stars are almost always almost full, we transform as soon
% as possible into full doubles

if isa(R,'double')
    Rstar = mmp_l_trclosure(R);
elseif isa(R,'mmp.x.Sparse')
    Rstar = trclosure(R);
else
    error('mmp:l:trclosure','wrong input data type')
end

return
