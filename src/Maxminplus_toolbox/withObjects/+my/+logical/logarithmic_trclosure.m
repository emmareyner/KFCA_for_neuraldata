function Astar = logarithmic_trclosure(A)
% function Astar = logarithmic_trclosure(A)
%
% Returns the transitive-reflexive (aka star, A*) closure of a
% non-null square logical matrix.

m=size(A,1);
% if m~=n,
%     error('logical:trclosure','Not a square matrix');
% end

switch m
    case 0
        error('my:logical:trclosure','0-dimension matrix!');
    case 1%early termination
        Astar(m,m)=true;
    otherwise
        %Hmmm, perhaps the iterative algorithm is interesting after all
        %star = sigma(R,m);
        % Gondran and Minoux, 2008. Chap. 4 Sec. 2.3. p. 119
        Astar = logical.mpower_raw(logical.rclosure(A),m-1);
        % The following has only sense in semimodules like max-min-plus.
        Astar_sq = logical.mtimes_raw(Astar,Astar);
        while any(any(Astar~=Astar_sq))
            Astar = Astar_sq;
            Astar_sq= logical.mtimes_raw(Astar,Astar);
        end
end
return%Astar
