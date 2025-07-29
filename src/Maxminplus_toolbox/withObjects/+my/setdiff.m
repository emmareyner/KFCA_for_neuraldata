function C = setdiff(A,B)
% MYSETDIFF Set difference of two sets of positive integers (much faster than built-in setdiff)
% C = my_setdiff(A,B)
% C = A \ B = { things in A that are not in B }

%  by Leon Peshkin pesha at ai.mit.edu 2004, inspired by BNT of Kevin Murphy
% Adapted by FVA to package +my, OCT  2010, R2008b

if isempty(A)
    C = [];
elseif isempty(B)
    C = A;
else % both non-empty
    bits = false(1, max(max(A), max(B)));
    bits(A) = true;
    bits(B) = false;
    C = A(bits(A));
end
return
