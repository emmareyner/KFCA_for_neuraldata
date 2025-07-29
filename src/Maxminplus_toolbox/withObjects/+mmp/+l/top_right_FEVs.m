function [enodes,V]=top_right_FEVs(A)

error(nargchk(nargin,1,1));
switch class(A)
    case 'double'
        if issparse(A)
            error('mmp:l:top_right_FEVs','Direct sparse input not allowed to prevent formatting confusions. Use mmp.x.Sparse, etc.');
        else
            %A = mmp_x_sparse(A);%Full matrices transformed into sparse ones!
            [enodes,V]=mmp_l_top_right_FEVs(A);
        end
    case 'mmp.x.Sparse'%Do nothing
        %This is a wasteful kludeg
        % TODO: build actual primitive for mmp.x.Sparse
        [enodes,V]=mmp_l_top_right_FEVs(double(A));
    otherwise
        error('mmp:l:top_right_FEVs','Wrong input class');
end
return
