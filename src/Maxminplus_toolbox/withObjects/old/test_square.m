function n = test_square(R)
% function n = test_square(R)
%
% A function to test if a matrix is square and non-null. Returns the dim
% of R if it is square non-null otherwise returns an error, either
% 'non-square matrix' or 'Null-matrix!' accordingly.
    [m,n] = test_non_null(R);
    (m == n) || error('non-square matrix');
    return