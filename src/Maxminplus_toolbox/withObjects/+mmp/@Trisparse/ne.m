function ts = eq(X,Y)
% function ts = mmp.sparse.ne(A,B)
%
% A function to test if two max-min-plus matrices are UNequal. For that to
% happen their dimensions should be equal and the elements in which they
% differ should differ by more than 2*eps.

% Mmp adaptation: FVA 24/02/2009
% object conversion: FVA 16/03/2009

error(nargchk(2,2,nargin));
try
    ts=~(X==Y);
catch Me
    if strcmp(Me.message,'Incomparable sizes')
        error('mmp:ne', Me.message);
    else
        rethrow(Me)
    end
end
return