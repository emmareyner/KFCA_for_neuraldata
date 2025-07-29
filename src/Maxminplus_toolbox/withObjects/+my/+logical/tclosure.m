function [C]=tclosure(A,params)
% Finds the transitive closure of a logical matrix, aka A+.
%
% CAVEAT: this is NOT the transitive reflexive closure!
%
% CAVEAT: a logarithmic scheme would be better for this!
%
% Empty or zero positions in A(i,j) marks the inexistence of an arc from
% vertex i to vertex j. All other positions should be positive. Encoding
% different information in positions return different applications:
% -For binary information it just returns a connectivity matrix.
% -For numerical information it returns the all-weighted paths problem in
% algebras where the bottom or zero element is 0.0
%
% example: to find the transitive closure of a *logical* array:
% order=logical(tclosure(double(order)))
%The double type cast is because my_grTclosure needs a numerical array.
%
% CAVEAT: Transitive closures most probably are *not* sparse, so even if A
% is sparse, its transitive closure C is not.
error(nargchk(1,2,nargin));

[m n]=size(A);
if (m==n) && (n ~= 0)
    %Decide on the algorithm to do the closure
    if nargin < 2
        C = my.logical.mpower_tclosure(A);
    elseif isfield(params,'alg')
        switch params.alg
            case 'iterative'
                C = my.logical.iterative_tclosure(A);
            case 'logarithmic'
                C = my.logical.logarithmic_tclosure(A);
            case 'mpower'
                C = my.logical.mpower_tclosure(A);
            otherwise
                error('logical:tclosure','Unknown algorithm %s',params.alg);
        end
    else
        error('my:logical:tclosure','Unrecognized parameter structure name');
    end
elseif n~=0,
    error('my:logical:tclosure','undefined result for zero-dimension matrices');
else
    error('my:logical:tclosure','not a square matrix');
end
return%C is numerical!
