function [Len,Ren,Lev,Rev]=top_FEVs(A)
%[Len,Ren,Lev,Rev]=top_FEVs(A)
%
%To produce the eigennodes and FEVs of the top eigenvalue of a strongly
%connected matrix. 
%
% It doesn't return the eigenvectors if they are not requested.
error(nargchk(nargin,1,1));
returnLeftFEVs = (nargout > 2);
returnRightFEVs = (nargout > 3);

if returnLeftFEVs
    [Len,Lev]=mmp.l.top_right_FEVs(A');
else
    [Len]=mmp.l.top_right_FEVs(A');
end

if returnRightFEVs
    [Ren,Rev]=mmp.l.top_right_FEVs(A);
else
    [Ren]=mmp.l.top_right_FEVs(A);
end
        
return%[Len,Ren,Lev,Rev]
