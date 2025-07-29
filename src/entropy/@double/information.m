function [I,EI] = information(P)%
%[I,EI] = information(P)
%
% Obtains the information (pointwise) and its expectation from a distribution of 1
% or two variables, hence:
% - for Pxy a bivariate distribution:
%  [I_Pxy,H_Pxy] = information(Pxy) 
% obtains I_Pxy = log Pxy and H_Pxy is joint entropy
%
% - for Px a (row,column) univariate distribution
%  [I_Px,H_Px] = information(Px)
% obtains the self-information and the entropy.
%
% If P is a cell array of distributions, then so is I, while EI is an array
% of expectations.
%
% Authors: FVA; CPM, 2009-2014

error(nargchk(1,1,nargin));
error(nargchk(1,2,nargout));

%if input is a cell array, recurse on individuals

if iscell(P)%dispatch
    n=length(P);
    I=cell(1,n);
    if nargout == 2; EI=zeros(1,n); end
    for i=1:n
        if (nargout == 2)
            [I{i}, EI(i)] = information(P{i});
        else
            [I{i}] = information(P{i});
        end
        
%         I{i} = -log2(P{i});
%         if nargout == 2
%             EI=zeros(1,n);
%             lp = logical(P{i});
%             if any(size(P{i}) == 1)%row distribution or column distribution, resp
%                 EI(i) = sum(P{i}(lp) .* I{i}(lp));
%             else%bivariate, be very careful
%                 EI(i) = sum(sum(P{i}(lp) .* I{i}(lp)));
%             end
%         end
    end
else
    [L M N] = size(P);
    if (N==1)%REally solve
            lp = logical(P);
%         if (issparse(P))
%             I = spfun(@(f) -log2(f),P);
%             I(not(lp)) = -Inf;%%Too costly!!! Avoid at all costs!
%         else
            I = -log2(P);
%         end 
        if nargout == 2
            if any([L M] == 1)%row distribution or column distribution, resp
                EI = sum(P(lp) .* I(lp));
            else%bivariate, be very careful
                EI = sum(sum(P(lp) .* I(lp)));
            end
        end
    else%multidimensional array: dispatch
        I = zeros(L,M,N);
        if nargout == 2, EI = zeros(1,1,N); end
        for n=1:N
            if (nargout == 2)
                [I(:,:,n),EI(1,1,n)] = information(P(:,:,n));
            else
                I(:,:,n) = information(P(:,:,n));
            end
        end
    end
end
return%I,EI

