function [matrices]=generate_matrices2(N,n,k,spur)
% function [C, T, P]=generate_matrices2(N,n,k,spur)
%
% function [C, T, P]=generate_matrices2(N,n,k)
% function [C, T, P]=generate_matrices2(N,n)
%
% Produces the indexes for the generation of every possible integer matrix 
% of size nxk with total count N. If only [n] is supplied, k=n.
%
% if [spur] is supplied, only matrices with that spur (aka trace aka
% diagonal sum) are obtained. 
%
% INPUT: 
% N: the total number to be distributed in the matrix
% k: is the number of columns in the output distribution.
%
% OUTPUT: 
% C: is a cell array of k matrices each with the weak composition of 
% k integers that sum each element of nvec
% T: is a vector containing the number of possible combinations of each
% weak composition
% P: each row of p is a vector of indexes for the selection of all possible
% rows from the k matrices of C
%
% Example: [C, T, P]=generate_matrices([2 3]',2) generates all possible 2x2
% matrices distributing 5 samples: 2 in the first input class, 3
% in the second.
%
% Ref: Basic Combinatorics (Chapter 5), Carl G. Wagner, Department of 
% Mathematics, The University of Tennessee
%
% http://www.math.utk.edu/~wagner/papers/comb.pdf
%
% To generate all the possible matrices do (not done here to avoid using too
% much space).
%
% for i=1:Total
%     M{i}=zeros(k,k);
%     for j=1:k
%         M{i}(j,:)=C{j}(P(i,j),:);
%     end
%     M{i}
% end

% IMPLEMENTATION NOTES
%FVA: do NOT use cell arrays to muster args to and from provider functions.
%num2cell is *extremely* costly.
debug = 5;

error(nargchk(2, 4, nargin));
if (N < 0) 
    error('entropy:generate_matrices2: negative count')
end    
if (nargin < 3), k = n; end;
if (k < 0 || n < 0) 
    error('entropy:generate_matrices2: negative dimension')
end
withSpur = nargin > 3;
if (withSpur && (spur < 0 || spur > N))
    error('entropy:generate_matrices2:unexpected trace')
end

%% Using GENERATE-THEN-TEST
%1.- Generate input distributions
%nvec can also be generated using WeakComp
%    Px=weakComp(N,k);%CAVEAT: there is no need to repeat all of them...
Px=zeros(n,0);
%go over possible number of factors, generating partitions...
for g=1:n
    mult = partitions(N,1:N,N,g); %in terms of factor multiplicity
    [multm ~] = size(mult);
    %transform to real factors
    thesePx = zeros(n,multm);
    for i=1:multm
%        thesePx(:,i) =find(mult(i,:));
        factors = find(mult(i,:));
        thesePx(1:length(factors),i) = factors;%Yes, reverse in the process
%         j=0;
%         for f=find(mult(i,:))
%             thesePx(i,j+(1:mult(i,f)))=f;
%             j=j+mult(i,f);
%         end
        
    end
    Px = [Px thesePx]; %#ok<AGROW>
end
numDistEntrada = length(Px);
if (debug > 3) 
    fprintf('*There are %d input distributions of length %d.\n',numDistEntrada,n);
end

%% Now use each to generate output distributions
matrices = uint16(zeros(n,k,0));%this is a "tube" of matrices instead of a cell array.
%still the problem is that we don't know home many of these are there.
%isSpur = @(mat) trace(mat)==spur;
%alts = cell(k,1);
%Go over the individual rows obtaining 
for l=1:numDistEntrada
    thisPx = Px(:,l);%Choose one input distribution
    %Nk = sum(thisPx);
    %generate output distributions
    %FVA: DO NOT PASS ANYTHING TO combinations as a CELL ARRAY: TOO COSTLY!
%     for i=1:k
%         if (thisPx(i) == 0) 
%             alts{i} = {zeros(1,m)};
%         else
%             alts{i}=num2cell(WeakComp(thisPx(i),m),2);%redistribute the counts among m
%         end
%     end
    [C, T, P]=generate_matrices(thisPx,k);
    thisTotal = prod(T);
    %M = zeros(n,k,thisTotal);
    M=uint16(zeros(n,k,0));
    if withSpur
        %spurFilter = false(1,thisTotal);%filter to select matrices
        spurFilterIdx=0;
        for i=1:thisTotal
            candidate=uint16(zeros(n,k));
            for j=1:n
            %get matrix
                 %M(j,:,i) = C{j}(P(i,j),:);
                 candidate(j,:) = uint16(C{j}(P(i,j),:));
            end
            if (sum(diag(candidate))== spur)
                spurFilterIdx=spurFilterIdx+1;
                M(:,:,spurFilterIdx)=candidate;
            end
            %spurFilter(i) = withSpur && (sum(diag(candidate))== spur);
        end  
        %M = M(:,:,spurFilter);
    else
        for i=1:thisTotal
            for j=1:n
            %get matrix
                 M(j,:,i) = C{j}(P(i,j),:);
            end
        end  
    end
    %fprintf('***There are %d output distributions for it.\n', length(M));
    fprintf('***There are %d output distributions for it.\n', spurFilterIdx);
    matrices = cat(3,matrices, M); 
%     fprintf('**Feasible matrices for dist %i: %d\n', j,length(constrainedMatrices));
%     matrices=[matrices{:} constrainedMatrices]; %#ok<AGROW>
%     for i=1:k
%         if (thisPx(i) == 0) 
%             alts{i} = zeros(1,m);
%         else
%             alts{i}=WeakComp(thisPx(i),m);%redistribute the counts among m
%         end
%     end
%     % Now combine every sub set of these
%     newMatrices= combinations(alts{:});
%     constrainedMatrices = {};
%     idx = 0;
%     %filterIn=false(1,length(newMatrices));
%     for i=1:length(newMatrices)
%         %newMat = cat(1,newMatrices{i,1}, newMatrices{i,2});
%         newMat = cat(1,newMatrices{i,:});
% %        if (trace(newMat)==spur)
%         if (sum(diag(newMat))==spur)
%             idx=idx+1;
%             constrainedMatrices{idx} = newMat; %#ok<AGROW>
%         end
%     end
%     fprintf('**Feasible matrices for dist %i: %d\n', j,length(constrainedMatrices));
%     matrices=[matrices{:} constrainedMatrices]; %#ok<AGROW>
end
return
