function Rplus = finite_tclosure(R)
% function Rplus = finite_tclosure(R)
%
% Returns the transitive (aka, A+) closure of a non-null square
% matrix for matrices guaranteed to have a finite one (max cycle 
% mean less than 0.
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
    Rplus = mmp_l_finite_tclosure(R);
elseif isa(R,'mmp.x.Sparse')
    Rplus = finite_tclosure(R);
else
    error('mmp:l:trclosure','wrong input data type')
end

return
