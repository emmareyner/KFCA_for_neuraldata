function [a,b] = mu_concept(K,phi,atts)
% function [a,b] = fca.mmp.mu_concept(K,phi,atts)
% A function to find the phi-concept given a set of attributes (column
% vectors). 
% Input:
% - phi: the minimum degree of existence for the concept.
% - K: a formal k-Concept
% - atts: sets of attribute (column vectors) 
% Output:
% - a: the extents of the phi-concepts (read as rows)
% - b: the intents of the phi-concepts (read as columns)

if ~isscalar(phi)
    error('mmp:kfca:Contexts:mu_concept','not a valid phi parameter')
end
if (size(atts,1) ~= K.m)
    error('mmp:kfca:Contexts:mu_concept','input is not a valid attribute set')
end
% 1) This is the formula that uses the conjugate of K.R
%a = mp_multi(phi,mp_multi(atts',-K.R'));
%b = -mp_multi(-K.R',mp_multi(a',phi));
% 2) This is the formula that uses minplus calculus
%a = (mpm_multi(K.R(K.iG,K.iM),mpm_multi(-atts,-phi)))';
%b = (mpm_multi(-phi,mpm_multi(-a,K.R(K.iG,K.iM))))';
% 3) This is the formula for bracket <y|x>=y' \otimesl R \otimesl x
% using the polars expressed in the minplus calculus.

%CPM
%Kinverse = -K.R(K.iG,K.iM)';
%a = (mpm_multi(phi,mpm_multi(-atts',Kinverse)))';
%b = mpm_multi(Kinverse, mpm_multi(-a,phi));
a = extent(K,phi, atts);
b = intent(K,phi, a);

%aa = mpfca_extent(phi, K, b)

return%a,b
