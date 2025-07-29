function [ wIxy,Pxy] = weightedInformation( Pxy )
% function [ wIxy ] = weightedInformation( Nxy )
% function [ wIxy,Pxy ] = weightedInformation( Nxy )
%
% A function to work out the weighted information [wIxy] 
% in a slightly more efficient way, specially for sparse distributions.
%
% Note that the input distribution [Nxy](on counts, probabilities) will be
% re-normalized if necessary and returned, hence this primitive can be supplied with a
% distribution over counts and it will return a probability distribution,
% as well [Pxy] as in the second usage suggested.
%
% Author: FVA, 01, 2014

% CAVEAT: The following might not be TRUE!
% from wPMIxy and Pxy you can obtain the pointwise mutual information as:
% PMIxy = wPMIXxy ./ Pxy;%Watch out, there will be infinites in here!
% PMIxy(Pxy == 0) = -Inf
%
error(nargchk(1,1,nargin));
error(nargoutchk(1,2,nargout));

%If the input is a cell array, dispatch to the individual cells
if iscell(Pxy)%dispatch
    N=length(P);
    wIxy=cell(1,N);
    %if nargout == 2; Pxy=zeros(1,n); end
    for i=1:N
        if (nargout == 2)
            [wIxy{i}, Pxy(i)] = weightedInformation(Pxy{i});
        else
            [wIxy{i}] = weightedInformation(Pxy{i});
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
    [L M N] = size(Pxy);
    if (N==1)%REally solve
        %renormalize P to include count matrices
        counts = full(sum(sum(Pxy)));
        if (counts ~= 1.0)
            Pxy = Pxy/counts;%P is now a probability distribution
        end
        % %marginalize
        % Px = sum(Pxy,2);
        % Py = sum(Pxy,1);
        % wPMIxy = Pxy ./ (Px * Py);%may generate NaNs
        % Lx = Px == 0;
        % if any(Lx); wPMIxy(Lx,:) = 0; end
        % Ly = Py == 0;
        % if any(Ly); wPMIxy(:,Py' == 0) = 0; end
        if issparse(Pxy)
            %Only apply the log at the non-zero points, since the wPMI is going to
            %be null at these!
            wIxy = spfun(@(p) -log2(p), Pxy);%this is now PMIxy with zeros for Inf.
        else
            wIxy = -log2(Pxy);%this is now PMIxy
            wIxy(Pxy == 0) = 0; 
        end
        wIxy = Pxy .* wIxy;
        %wPMIxy(Pxy == 0) = 0;%preempt NaNs
        %Correct incurred Inf * 0 = NaNs in full matrices
        %if ~(issparse(wPMI)); wPMI(isnan(wPMI)) = 0; end
    else
        wIxy = zeros(L,M,N);
        if nargout == 2, EI = zeros(1,1,N); end
        for n=1:N
            if (nargout == 2)
                [wIxy(:,:,n),Pxy(1,1,n)] = information(Pxy(:,:,n));
            else
                wIxy(:,:,n) = information(Pxy(:,:,n));
            end
        end
    end
end
return
end