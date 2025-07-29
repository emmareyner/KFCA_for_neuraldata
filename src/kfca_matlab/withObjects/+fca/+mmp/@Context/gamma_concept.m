function [a,b] = gamma_concept(K, phi, objs)
%function [a,b] = fca.mmp.gamma_concept(K, phi, objs)
%
% A function to find the phi-concept given a set of objects (row vector).
% Input:
% - phi: the minimum degree of existence for the concept.
% - K: a formal k-Concept
% - objs: a set (COLUMN vector) of objects
% Output:
% - a: the extent of the phi-concept
% - b: the intent of the phi-concept
if ~isscalar(phi)
    error('mmp:kfca:Contexts:gamma_concept','not a valid phi parameter')
end
if (size(objs,1) ~= K.g)
    error('mmp:kfca:Contexts:gamma_concept','input is not a valid object set')
end

% Don't do checking here, since it is done in primitives below!
% if ~isscalar(phi)
%     error('mmp:kfca:Contexts:gamma_concept','not a valid phi parameter')
% end
% if (size(objs,1) ~= K.g)
%     error('mmp:kfca:Contexts:gamma_concept','input is not a valid object set')
% end
% 1) This is the formula that uses the conjugate of K.R
%b = -mp_multi(-K.R',mp_multi(objs',phi));
%a = -mp_multi(phi,mp_multi(a',-K.R'));
% 2) This is the formula that uses minplus calculus
%b = (mpm_multi(-phi,mpm_multi(-objs,K.R(K.iG,K.iM))))';
%a = (mpm_multi(K.R(K.iG,K.iM),mpm_multi(-b,-phi)))';
% 3) This is the formula that uses minplus calculus

%CPM
%Kinverse = -K.R(K.iG,K.iM)';
%b = mpm_multi(Kinverse, mpm_multi(-objs,phi));
%a = (mpm_multi(phi,mpm_multi(-b',Kinverse)))';
b = intent(K, phi,objs);
a = extent(K, phi, b);
return%[a,b]
