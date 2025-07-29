function [varargout]=entropies2(Pxy)
%function [H_Pxy, H_Px,H_Py, EMI_Pxy, I_Pxy, I_Px, I_Py, M_Pxy]=entropies2(Pxy)
%  [H_Pxy, H_Px,H_Py, EMI_Pxy, I_Pxy, I_Px, I_Py, MI_Pxy]=entropies2(Pxy)
%
% A function to calculate and explore all possible entropies from a bivariate
% probability distribution. If Pxy is a cell array or num arrays, then the  
% outputs are also arrays with as many entries as Pxy
% 
% It obtains only:
% - the self information of X (I_Px) and Y (I_Py), and their averages, the
% marginal entropies (H_Px and H_Py).
% - the joint information distribution (I_Pxy) and its average, their 
% (expected joint) entropy (H_Pxy),
% - their pointwise mutual information (MI_Pxy) and  the
% (expected) mutual information (EMI_Pxy) 
%
%
% To calculate only the entropies and Mutual Information, do:
%  [H_Pxy, H_Px,H_Py, EMI_Pxy]=entropies(Pxy)
%
% NOTE: the relation between entropies is used to calculate the mutual
% information distribution MI_Pxy and its expectation EMI_Pxy
%
% Authors: FVA; CPM, 2009-2014

error(nargchk(1,1,nargin));
error(nargoutchk(1,8,nargout));
if iscell(Pxy)
    [varargout{1:nargout}] = cellfun(@(P) entropies2(P),Pxy);
    return;
end
end