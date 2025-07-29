function [spectrum] =of_UFNF_0(S,lcycles)
%function [spectrum] = mmp.l.of_UFNF_0(S,lcycles)
%
% A function to calculate the eigenspace and eigenvalue of a square
%IRREDUCIBLE matrix in the maxplus algebra using the method by Gaubert et
%al. It returns correct values even on S = Inf.
%
% TRIES to return an error on reducible matrices.
%
%INPUT:
% - [S] is an n x n irreducible maxplus matrix.
% - [lcycles]: the lcycles of [S]. Since S is irreducible, size(lcycles) is
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
error(nargchk(2,2,nargin));
[m,p]=size(S);
if m~=p,
    error('mmp:l:Spectrum0:of_UFNF_0','non-square argument');
end
%% Sanity check! check input values
% If matrix is completely reducible, then give an error.
nlcycles = size(lcycles,2);
if nlcycles == 0%nocycles entails completely reducible
    error('mmp:l:Spectrum0:of_UFNF_0','Impossible: strongly connected component with no cycles!');
end%if lambda~=Inf
spectrum = mmp.l.Spectrum0();
spectrum.cycles = lcycles;
spectrum.nodes = p;

%% 3) For irreducible matrices, at least one non-null value per row, col.
switch spectrum.nodes

case 0
    error('mmp:l:Spectrum0:of_UFNF_0','Zero-dimension input matrix.');

case 1
    spectrum.lambda = double(S);%normal encoding, single value
    if spectrum.lambda > mmp.l.zeros
       spectrum.enodes=[1];
       spectrum.lenodes=spectrum.enodes;
        %nSplus=mmp.l.ones;
        %For lambda <= mmp.ltops, this is standard knowledge
        if S.lambda < mmp.l.tops%lambda <= e
            S.levs = mmp.l.ones;%lambda - lambda
         else%if lambda > 0
            S.levs = mmp.l.tops;%nSplus = S*Sltar = S*Inf = Inf
        end
   else
        error('mmp:l:Spectrum0:of_UFNF_0','zero-matrix');
%         ccindex=[];%No cycles
%         nSplus = S;
    end
    spectrum.revs = spectrum.levs;
    
%% Get the lambda by maximizing cycle weight & find crit. lcycles
otherwise%At least one cycle marks matrix as irreducible  
    % TODO: The following formulae should be expressed in maxminplus calculus
    % with a %productory and a root: it is essentially the mmp geometrical
    % mean,which is the arithmetical mean in normal calculus.
    % since maxminplus is selective, the addition at the end finds out argsums
    % too (argmaxes in normal notation).
    weights = @(cy) S(sub2ind([p,p],cy(1:end-1),cy(2:end)));
    if issparse(S)
        cmeans = cellfun(@(c) mean(double(weights(c))), lcycles);
    else
        cmeans = cellfun(@(c) mean(weights(c)), lcycles);
    end
    %Calculate the lambda
    % Perhaps using an [ccindex,lambda]=mmp.l.argplus(cmeans)
    %[lambda,ccindex]=mmp.l.sum(cmeans);%max and argmaxes: ev and crit. cycle
    spectrum.lambda=max(cmeans);
    
    % Finite value for eigenvalue, since lambda==-Inf is ruled out in
    if spectrum.lambda < mmp.l.tops%Finite lambdas
        % Normalize with eigenvalue => Sn is definite.
        % Since Sn is definite by construction we can use the quick
        % closure
        %nSplus=mmp.l.finite_tclosure(mmp.l.mrdivide(S,lambda));
        spectrum.Splus = mmp.l.finite_tclosure(mmp.l.mrdivide(S,lambda));
        spectrum.ccycles=find(abs(cmeans-lambda)<=eps(2));%test for undifferentiability rather than equality
        spectrum.enodes=cell2mat(lcycles(spectrum.ccycles));
        %TODO: check for maximal circuits with this lambda!
    else%lambda == Inf%% Consider an Inf eigenvalue for this irreducible matrix
        %There's no metric-matrix: it goes to Inf:
        % but the eigenvectors of the fullspace come form the upper
        % identity
        spectrum.Splus = mmp.l.tops(p);%only use alt representations in mmp.x.sparse primitives
        spectrum.ccycles=find(cmeans==mmp.l.tops);
        %nSplus = mmp.u.zeros(p);%note the nice similarity with the eigenvectors of the nullspace below!
        %The choice of the eigennodes generating FEVs  in the critical
        %cycle is different, though: see next primitive!
        %ccindex=find(cmeans==lambda);%Check that these do not include each
        %other!!
        %FVA: this will generate and error when invoked on mmp.x.Sparse
        %matrices.
        spectrum.enodes=mmp_l_top_right_FEVs(A);%find the FEVs for lamda=top, do not request
    end
end%switch p

return%nSplus,lambda,ccindex
