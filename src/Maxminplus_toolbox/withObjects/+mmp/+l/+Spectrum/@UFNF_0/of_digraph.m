function [S] =of_digraph(A,maskperm,lcycles)
%function [spectrum] = mmp.l.Spectrum.UFNF_0.of_digraphj(A,lcycles,maskperm)
%
% A function to calculate the eigenspace and eigenvalue of a square
%IRREDUCIBLE matrix in the maxplus algebra using the method by Gaubert et
%al. It returns correct values even on A = Inf.
%
% TRIES to return an error on reducible matrices.
%
%INPUT:
% - [A] is an n x n irreducible maxplus matrix.
% - [lcycles]: the lcycles of [A]. Since S is irreducible, size(lcycles) is
% not null!
%
%OUTPUT:
% [spectrum]: the basic spectrum of a strongly connected component, aka an
% irreducible matrix A.
%
% The implementation tries to follow [Akian,Bapat and Gaubert, 2006]
%
% Author: fva, 22/11/06
%
% See also: mmp.l.of_connected_digraph

%% For early termination check on the matrix size
error(nargchk(2,3,nargin));
% [m,n]=size(A);
% if m~=n,
%     error('mmp:l:Spectrum:UFNF_0:of_digraph','non-square argument');
% elseif n == 0
%     error('mmp:l:Spectrum:UFNF_0:of_digraph','zero-dimension input matrix.');    
% end
S = mmp.l.Spectrum.UFNF_0(A,maskperm,lcycles);
n = length(S.nodes);

%% 3) For irreducible matrices, at least one non-null value per row, col.
if n==1
    S.lambdas = double(A(maskperm,maskperm));%normal encoding, single value
    S.rhos=S.lambdas;
    if S.lambdas > mmp.l.zeros
       S.renodes=1;
       S.lenodes=S.renodes;
%         %nSplus=mmp.l.ones;
%         %For lambda <= mmp.ltops, this is standard knowledge
%         if S.lambdas < mmp.l.tops%lambda <= e
%             S.levs = mmp.l.ones;%lambda - lambda
%          else%if lambda > 0
%             S.levs = mmp.l.tops;%nSplus = S*Sltar = S*Inf = Inf
%         end
        S.ccycles=1;%Only possible
        if S.lambdas > mmp.l.ones
            S.Splus = mmp.l.tops;
        else
            S.Splus = mmp.l.ones;
        end
   else
        error('mmp:l:Spectrum:UFNF_0:of_digraph','zero-matrix');
    end
%% Get the lambda by maximizing cycle weight & find crit. lcycles
else%At least one cycle marks matrix as irreducible  
    % TODO: The following formulae should be expressed in maxminplus calculus
    % with a %productory and a root: it is essentially the mmp geometrical
    % mean,which is the arithmetical mean in normal calculus.
    % since maxminplus is selective, the addition at the end finds out argsums
    % too (argmaxes in normal notation).
    weights = @(cy) A(sub2ind([n,n],cy(1:end-1),cy(2:end)));
    if issparse(S)
        cmeans = cellfun(@(c) mean(double(weights(c))), lcycles);
    else
        cmeans = cellfun(@(c) mean(weights(c)), lcycles);
    end
    %Calculate the lambda
    % Perhaps using an [ccindex,lambda]=mmp.l.argplus(cmeans)
    %[lambda,ccindex]=mmp.l.sum(cmeans);%max and argmaxes: ev and crit. cycle
    lambda=max(cmeans);
    S.lambdas = lambda;%A single lambda per irreducible matrix...
    S.rhos = lambda;%on both spectra
    
    % Finite value for eigenvalue, since lambda==-Inf is ruled out in
    if lambda < mmp.l.tops%Finite lambdas
        % Normalize with eigenvalue => Sn is definite.
        % Since Sn is definite by construction we can use the quick
        % closure
        %nSplus=mmp.l.finite_tclosure(mmp.l.mrdivide(S,lambda));
        S.Splus = mmp.l.finite_tclosure(mmp.l.mrdivide(A,lambda));
        S.ccycles=(abs(cmeans-lambda)<=eps(2));%test for undifferentiability rather than equality
        S.renodes=cellfun(@(c) c(1:end-1), (lcycles(S.ccycles)),'UniformOutput',false);%Take away the last index in cycle
        S.lenodes=S.renodes;%Same eigennodes in both spectra.
        %TODO: check for maximal circuits with this lambda!
    else%lambda == Inf%% Consider an Inf eigenvalue for this irreducible matrix
        %There's no metric-matrix: it goes to Inf:
        % but the eigenvectors of the fullspace come form the upper
        % identity
        S.Splus = mmp.l.tops(n);%only use alt representations in mmp.x.sparse primitives
        S.ccycles=(cmeans==mmp.l.tops);%This is just a bitset for 
        %nSplus = mmp.u.zeros(p);%note the nice similarity with the eigenvectors of the nullspace below!
        %The choice of the eigennodes generating FEVs  in the critical
        %cycle is different, though: see next primitive!
        %ccindex=find(cmeans==lambda);%Check that these do not include each
        %other!!
        %FVA: this will generate and error when invoked on mmp.x.Sparse
        %matrices.
        S.renodes={mmp_l_top_right_FEVs(A)};%find the right critical nodes for A.
        S.lenodes={mmp_l_top_right_FEVs(A')};%find the right critical nodes for A'.
    end
end%if n>= 1

return%S, the spectrum
