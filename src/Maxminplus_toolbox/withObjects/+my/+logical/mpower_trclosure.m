function Astar = mpower_trclosure(A)
% A function to calculate the TR closure by calculating the n-th power of
% the reflexive closure.

n=size(A,1);
% if m~=n,
%     error('logical:trclosure','Not a square matrix');
% end
% Gondran and Minoux, 2008. Chap. 4 Sec. 2.3. p. 119
Astar = my.logical.mpower_raw(my.logical.rclosure(A),n-1);
return
