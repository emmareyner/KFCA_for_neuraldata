 function [H_Pxy, H_Px,H_Py, EMI_Pxy, I_Pxy, I_Px, I_Py, M_Pxy]=entropies(Pxy)
%
%[H_Pxy, H_Px,H_Py, EMI_Pxy, I_Pxy, I_Px, I_Py, MI_Pxy]=entropies2(Pxy)
%
% A function to calculate and explore all possible empirical entropies from a bivariate
% probability distribution. If Pxy is a  num array, then the  
% outputs are also arrays with as many entries as Pxy
% 
% It obtains only:
% - the self information of X (I_Px) and Y (I_Py), and their averages, the
% marginal entropies (H_Px and H_Py).
% - the joint information distribution (I_Pxy) and its average, their 
% (expected joint) entropy (H_Pxy),
% - the pointwise mutual information (MI_Pxy) and  the
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
% if iscell(Pxy)
%     argOut = cell(1,nargout);
%     [argOut{1:nargout}] = cellfun(@(P) entropies2(P),Pxy);
%     switch nargout
%         case 1
%             H_pxy = argOut{1};
%     return;
% end
    
%% Obtain the entropies
[M P K] = size(Pxy);%Dimensions of experiment
if issparse(Pxy)
    H_Pxy = zeros(1,K);
    H_Px = zeros(1,K);
    H_Py = zeros(1,K);
    EMI_Pxy = zeros(1,K);
    I_Pxy = zeros(M, P, K);
    I_Px = zeros(M,1,K);
    I_Py = zeros(1,P,K);
    M_Pxy = zeros(M,P,K);
else
    H_Pxy = sparse(1,K);
    H_Px = sparse(1,K);
    H_Py = sparse(1,K);
    EMI_Pxy = sparse(1,K);
    I_Pxy = sparse(M, P, K);
    I_Px = sparse(M,1,K);
    I_Py = sparse(1,P,K);
    M_Pxy = sparse(M,P,K);

end
if (K > 1)%Not a cell, but multiple matrices together: return matrices of results
    for k = 1:K
        switch nargout
            case 1
                [H_Pxy(k)]= entropies2(Pxy(:,:,k));
            case 2
                [H_Pxy(k), H_Px(k)]= entropies2(Pxy(:,:,k));
            case 3
                [H_Pxy(k), H_Px(k), H_Py(k)]= entropies2(Pxy(:,:,k));
            case 4
                [H_Pxy(k), H_Px(k), H_Py(k), EMI_Pxy(k)]= entropies2(Pxy(:,:,k));
            case 5
                [H_Pxy(k), H_Px(k), H_Py(k), EMI_Pxy(k),I_Pxy(:,:,k) ]= entropies2(Pxy(:,:,k));                
            case 6
                [H_Pxy(k), H_Px(k), H_Py(k), EMI_Pxy(k),I_Pxy(:,:,k), I_Px(:,:,k) ]=...
                    entropies2(Pxy(:,:,k));                
            case 7
                [H_Pxy(k), H_Px(k), H_Py(k), EMI_Pxy(k),I_Pxy(:,:,k), I_Px(:,:,k), I_Py(:,:,k) ]=...
                    entropies2(Pxy(:,:,k));                                
            otherwise
                [H_Pxy(k), H_Px(k), H_Py(k), EMI_Pxy(k),I_Pxy(:,:,k), I_Px(:,:,k), I_Py(:,:,k), M_Pxy(:,:,k) ]=...
                    entropies2(Pxy(:,:,k));
        end
    end
%     argout = cell(1,nargout);
%     for j=1:min(nargout,4); varargout{j} = zeros(1,1,K); end
%     if nargout > 4; argout{5} = zeros(M,P,K); end
%     if nargout > 5; argout{6} = zeros(M,1,K); end
%     if nargout > 6; argout{7} = zeros(1,P,K); end
%     if nargout == 8; argout{8} = zeros(M,P,K); end
%     for i = 1:K
%         [outArgs{1:nargout}] = entropies2(Pxy(:,:,K));
%         for j =1:nargout
%             argout{i}(:,:,i) = outArgs{j};
%         end
%     end
    return
end
%Else, this is just a simple matrix!
% the coding strategy is ugly, but effective
[wIxy,Pxy] = weightedInformation(Pxy);%Pxy might be counts but is changed into probs.
H_Pxy = full(sum(sum(wIxy)));
if nargout == 1; return; end

%Now work out H_Px and h_Py on the same principle.
Px = full(sum(Pxy,2));%Column density
[wPx] = weightedInformation(Px);
H_Px = full(sum(wPx));
if nargout == 2; return; end

Py = full(sum(Pxy));%Row density
[wPy] = weightedInformation(Py);
H_Py = sum(wPy);

%This is no big deal, so we carry it out.
EMI_Pxy = H_Px + H_Py - H_Pxy;%On average. These are arrays
if nargout <= 4; return; end


%% obtain the mutual information
I_Pxy = wPxy ./ Pxy;%Shouldn't be problematic
if nargout == 5; return; end

I_Px = wPx ./ Px;%Shouldn't be problematic
if nargout == 6; return; end

I_Py = wPy ./ Py;%Shouldn't be problematic
if nargout == 7; return; end

%So this last is beautiful...
 M_Pxy  = repmat(I_Px,1,P) + repmat(I_Py,M,1) - I_Pxy;%Definition formula
% if iscell(Pxy)
%     M_Pxy=cell(1,n);
% else
%    [n,p] = size(Pxy);
%end
return

