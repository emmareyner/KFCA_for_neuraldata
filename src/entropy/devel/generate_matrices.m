function [C, T, P]=generate_matrices(nvec,k)
% function [C, T, P]=generate_matrices(nvec,k)
%
% Produces the indexes for the generation of every possible integer matrix 
% of size nxk with row counts [nvec] where length(nvec)==n. If only [nvec]
% is supplied, k=length(nvec)
%
% INPUT: 
% nvec: is a vector specifying the sum of the nth row of the matrix (counts
%of the input distribution)
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
% To generate all the possible matrices do (not done here to avoid using too
% much space).
%
% A) Generate as a cell array
% Total = prod(T);
% M = cellarray(1,Total);
% for i=1:Total
%     M{i}=zeros(n,k);
%     for j=1:n
%         M{i}(j,:)=C{j}(P(i,j),:);
%     end
%     M{i}
% end
%
% B) Generate as an array
% Total = prod(T);
% M = zeros(n,k,Total);
% for i=1:Total
%     for j=1:n
%         M(j,:,i) = C{j}(P(i,j),:);
%     end
% end
% Ref: Basic Combinatorics (Chapter 5), Carl G. Wagner, Department of 
% Mathematics, The University of Tennessee
%
% http://www.math.utk.edu/~wagner/papers/comb.pdf
%
% Modified by CPM, FVA 

%IMPLEMENTATION NOTES:
% [nvec] can also be generated using WeakComp

error(nargchk(1, 3, nargin));
n = length(nvec);%# of rows
if (nargin==1), k = n; end;% #of cols
% if size(nvec,1)~=k
%     disp('Error')
% end

%First compute the weak compositions for each element of the nvec (the
%input distribution)
C=cell(1,n);
T=zeros(1,n);
inputpars=cell(1,n);
% Go over row sums generating weakCompositions.
for i=1:n
    C{i}=weakComp(nvec(i),k);
    T(i)=size(C{i},1);
    inputpars{i}=1:T(i);
end
%Now we need the cartesian product of the rows of the k matrices generated.
P = combinations(inputpars{:});
return