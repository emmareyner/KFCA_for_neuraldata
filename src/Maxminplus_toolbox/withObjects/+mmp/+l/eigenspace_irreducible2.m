function [Slplus,lambda,ccindex] = eigenspace_irreducible2(lcycles,S)
%function [Slplus,lambda,ccindex] = mmp.l.eigenspace_irreducible2(lcycles,S)
%
% A function to calculate the eigenspace and eigenvalue of a square
%IRREDUCIBLE matrix in the maxplus algebra using the method by Gaubert et
%al. CAVEAT! If S is reducible, the result maybe senseless, or an error.
%
% The difference with mmp.l.eigenspace_irreducible is that we now supply the
% lcycles for matrix [S].
%
%INPUT:
% - [S] is an n x n irreducible maxplus matrix.
% - [lcycles]: the lcycles of [S]. Since S is irreducible, size(lcycles) is
% not null!
%
%OUTPUT:
% - [lambda]: the single eigenvalue of the matrix
% - [Slplus] is (S_\lambda)^+, that is the pseudoinverse of the matrix
% normalized in the eigenvalue.
% - [ccindex] : indices of the critical circuits in lcycles.
%
% The implementation tries to follow [Akian,Bapat and Gaubert, 2006]
%
% Author: fva, 22/11/06
%
% See also: mmp.l.eigenspace_irreducible

%warning(sprintf('el número de argumentos es %i\n', nargin));
error(nargchk(2,2,nargin));
%% For early termination check on the matrix size
[m,p]=size(S);
if m~=p,
    error('p:l:eigenspace_irreducible2','non-square argument');
end
%% Sanity check! check input values
% If matrix is completely reducible, then give an error.
nlcycles = size(lcycles,2);
if nlcycles == 0,
    error('p:l:eigenspace_irreducible2','matrix is not irreducible');
end


%% 3) For saturated matrices, at least one finite value per row, col.
%TODO: see to treating this in the code below. Inf eigenvalue?
% $$$     all(any(S ~= mpm_zero))  && all(any((S ~= mpm_zero),2)) ||...
% $$$         error('matrix with row or column filled with Inf');
%so m==p
switch p

case 0
    error('p:l:eigenspace_irreducible2','Dimension of input matrix is %i\n',p);

case 1
    %Then it is solved already, but may generate lambda = Inf
    lambda=double(S);%The weight of the single cycle in the matrix. this can't be mmp.l.zero
    if lambda==-Inf%this is totally reducible: should not happen in THIS function
        error('p:l:eigenspace_irreducible2','totally reducible matrix');
    elseif lambda <= eps%lambda <= 0, Slplus exists in maxplus
        Slplus=S;%Slplus = S*Sltar = S*one = S
    else%if lambda > 0
        Slplus = Inf;%Slplus = S*Sltar = S*Inf = Inf
    end
    ccindex=[1];%The single cycle (actually a loop) in the matrix.
    
otherwise%At least one cycle marks matrix as irreducible
        
%% Using the method in the tutorial by Gaubert
%     %0.- Using toolkit get one eigenvector and the eigenvalue
%     [ev,lambda] = mmp.l.egv4(S,mmp.l.ones(p,1));%This is really quick!
%     %%mmp.l.multi(S,S)==mmp.l.multi(S,Inf)
%% Get the lambda by maximizing cycle weight & find crit. lcycles
% THe following formulae should be expressed in maxminplus calculus
% with a productory and a root: it is essentially the mmp geometrical
% mean,which is the arithmetical mean in normal calculus.
% since maxminplus is selective, the addition at the end finds out argsums
% too (argmaxes in normal notation).
%     cweight = @(cy) sum(full(S(sub2ind([p,p],cy(1:end-1),cy(2:end)))));
%     cmeans = cellfun(@(c) cweight(c)/(length(c)-1), lcycles);
    % 1 The following has problems when considered a method of mmp.l.double
   S=double(S);%step up to parent to enable subsreferencing
   cmean = @(cy) mean(S(sub2ind([p,p],cy(1:end-1),cy(2:end))));
    % 2. The subsref solution: whew!
%     cmean = @(cy) mean(subsref(S,substruct('()',{sub2ind([p,p],cy(1:end-1),cy(2:end))})));
    cmeans = cellfun(@(c) cmean(c), lcycles);%nonsense, it is uniform
    %Calculate the lambda and the critical lcycles indices
%    [lambda,ccindex]=mmp.l.sum(cmeans);%max and argmaxes: ev and crit. cycle
    lambda=max(cmeans);
    ccindex=find(abs(cmeans-lambda)<=eps(16));%Do not test for equality
    
%% Consider an Inf eigenvalue for this irreducible matrix            
    if lambda==Inf

%% Top value for eigenvalue 
        %There's no metric-matrix: it goes to Inf: encode in minplus
        %Slplus = mmp.u.zeros(p);
        Slplus = Inf(p);%only use alt representations in mmp.x.sparse primitives
        %What about normalizing with...?:
        % Sn=mmp.l.rdiv(S,mmp.l.diag(mpm_zeros(1,p)))
        % Slplus = mmp.l.definite_metric_matrix(Sn)
        % Slplus = mmp.l.star(Sn)


%% 
    else%lambda ~= Inf
%% Finite value for eigenvalue, since lambda==-Inf is ruled out in
%  irreducible matrices

        % Normalize with eigenvalue => Sn is definite.
        % FVA: CAVEAT: This normalization is strange.
        %Sn = mmp.l.div(S,lambda);%Normalized matrix

        % 5A) Find the metric matrix
        % Since Sn is definite by construction we can use the quick closure
        % Check that this produces a FULL matrix most of the time!
        %Slplus=mmp.l.trclosure(mmp.l.mrdivide(S,lambda));
        %cast back to subclass
        Slplus=trclosure(mrdivide(mmp.l.Double(S),lambda));
        %Slplus=mmp.l.multi(Sn,mmp.l.star2(Sn));%Use quick closure operation

    end%if lambda==Inf
end%switch p

return%Slplus,lambda,ccindex
