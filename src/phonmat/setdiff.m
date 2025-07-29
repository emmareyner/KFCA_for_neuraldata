function A = setdiff (B,C)

% A,B,C are all vectors of integers
% A has all elements of B not in C, ie B-C

A = [];
for i = 1:length(B)
    found = 0;
    for j = 1:length(C)
	if B(i) == C(j)
	  found = 1;
          break;
        end;
    end;
    if ~found
       A = [A B(i)];
    end;
end;
