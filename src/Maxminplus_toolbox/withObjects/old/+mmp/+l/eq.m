function [Z]=eq(X,Y)
% equality testing primitive on lower representations


%Extend these switched with possible classes of arguments
switch class(X)
    case 'double'
        switch class(Y)
            case 'double'
                Z = eq(X,Y);
            case 'mmp.x.Sparse'
            case 'mmp.n.Sparse'
            otherwise
                error('mmp:l:eq','Wrong Y argument');
        end
    case 'mmp.x.Sparse'
    case 'mmp.n.Sparse'
    otherwise
        error('mmp:l:eq','Wrong Y argument');
end
return
