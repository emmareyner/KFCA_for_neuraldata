function [Z]=eye(X,Y)
% eye - max-plus algebraic identity matrix in maxplus encoding format.
%
%   eye(N) returns the N x N maxplus identity matrix.
%   eye returns the max-plus unit, 0.0
%   eye(X) or eye([X]) is an X-by-X max-plus identity matrix 
%       with max-plus ones (0's) on the main diagonal 
%       and max-plus zeros (Inf's) elsewhere,
%   eye(X,Y) or eye([X,Y]) is an X-by-Y matrix 
%       of max-plus ones on the main diagonal.
%   eye(SIZE(A)) is the same size as A.
%
%   See also mmp.x.ones, mmp.x.zeros, mmp.x.diag,

% FVA 25/02/09
switch nargin
    case 0
        Z=0.0;%early termination
        return
    case 1
        [mX,nX] = size(X);
        if (mX == 1)
            if (nX ==1)%single number
                Y=X;
            elseif (nX == 2)%pair of scalars
                X=mX;Y=nX;
            else
                error('mmp:x:sparse:eye','Wrong input argument');
            end
        else
            error('mmp:x:sparse:eye','Wrong input argument');
        end
    case 2
    if ~isscalar(X) || ~isscalar(Y)
        error('mmp:x:sparse:eye','Wrong input arguments');
    end
    otherwise
        error(nargchk(1,2,nargin));
end
X=max(X,0);Y=max(Y,0);%lower bound dims to 0
Z = mmp.x.sparse(X,Y);
co=1:min(X,Y);
%idx=sub2ind([X Y],co,co);
%Z.Unitp(idx)=true;
Z.Unitp(sub2ind([X Y],co,co))=true;
return%Z

