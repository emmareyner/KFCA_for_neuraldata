function [maxes, I] = sum(a,dum,dim)
% Maxplus sum accumulation function. This function tries to follow the MAX
% function in its calling convention, reproduced below for convenience,
% except:
% - when returning the indices of the max arguments of a vector, mmp.l.sum
% tries to return the indices of *all* the maxes.
% - does not accept the maximization of two arguments (for that see
% mmp.l.plus)
%
% NOTE: sum works out the sum of matrix A in dimension DIM, like the usual
% sum. The name is taken in the maxplus semiring by the function that
% (maxplus) adds  matrices, hence the funny name.
%
%  MAX    Largest component.
%     For vectors, MAX(X) is the largest element in X. For matrices,
%     MAX(X) is a row vector containing the maximum element from each
%     column. For N-D arrays, MAX(X) operates along the first
%     non-singleton dimension.
%  
%     [Y,I] = MAX(X) returns the indices of the maximum values in vector I.
%     If the values along the first non-singleton dimension contain more
%     than one maximal element, the index of the first one is returned.
%  
%     [Y,I] = MAX(X,[],DIM) operates along the dimension DIM. 
%  
%     When X is complex, the maximum is computed using the magnitude
%     MAX(ABS(X)). In the case of equal magnitude elements, then the phase
%     angle MAX(ANGLE(X)) is used.
%  
%     NaN's are ignored when computing the maximum. When all elements in X
%     are NaN's, then the first one is returned as the maximum.

%
% Author fva: 3/11/2005
error(nargchk(1,3,nargin));
argmax=(nargout==2);%Detect if the argmax is requested

switch nargin
    case 1
        maxes=max(a);
%         if argmax,
%             if (m==1)||(n==1)
%                 maxes = max(a);
%             else
%                 maxes = mmp.l.multi(mmp.l.ones(1,m), a);
%             end
%         end
        if argmax%calculate the argument maxima
            [m,n]=size(a);
            if m==1 || n==1 %'twas a vector, do just looking up
                I=find(abs(a-maxes)<=eps(16));
            else%twas a matrix, do it colum-wise, into a row
                I=cell(1,n);
                for j=1:n
                    I(j)=find(abs(a(:,j)-maxes(j))<=eps(16));
                end
            end
        end
    case 3
        if ~isempty(dum)
            error('mmp:l:sum','Wrong second input argument');
        end
        if argmax
            [maxes,I]=max(a,[],dim);
        else
            maxes=max(a,[],dim);
        end
%         if (dim==2) || (m==1)
%             maxes = mmp.l.multi(a, mmp.l.ones(n,1));
%         end
%         if (dim==1) || (n==1)
%             maxes = mmp.l.multi(mmp.l.ones(1,m), a);
%         end
    otherwise
        error('mmp:l:sum','Calling pattern not allowed');
end
return
