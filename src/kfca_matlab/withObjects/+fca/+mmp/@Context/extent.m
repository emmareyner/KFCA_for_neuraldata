function [a] = extent(K,phi,atts)
%function [a] = fca.mmp.extent(K,phi,atts)
%
%Input:
% - phi: the \varphi parameter of k-FCA
% - K: a maxplus formal context,
% - atts: a maxplus attribute set, i.e. a column or matrix of columns.
%
%Output:
% - a: an extent, a maxplus-weighted object set (i.e. a
% column vector).  If [atts] is a matrix of cols, then [a] is a matrix of
% columns coindexed by column with [atts].

%FVA: either don't check here or in the primitives!
% if ~isscalar(phi)
%     error('mmp:kfca:Contexts:extent','not a valid phi parameter')
% end
% %[g m] =  size(K);
% if (size(y,1) ~= K.m)
%     error('mmp:kfca:Contexts:extent','input is not a valid attribute set')
% end

%FVA: extent formula checked Feb 2010 obj sets are columns too!
%FVA: intent formula checked May2009. obj sets are columns too.
% The formulae using COLUMNS for objects are:
% 1) This is the formula that uses the transpose of K.R
%a = mmp.u.mtimes(phi,mmp.u.mtimes(-atts',K.R(K.iG,K.iM)'));
% 2) This is the formula that uses K.R
%a = mmp.u.mtimes(mmp.u.mtimes(K.R(K.iG,K.iM),-atts),phi);%output is already transposed!

a = mmp.u.mtimes(-mmp.l.mtimes(K.R(K.iG,K.iM),atts),phi);
assert(all(size(a) == [K.g size(atts,2)]))

% 3) This is the formula that works in maxplus (same as 2 but negated)
%a = -mmp.l.mtimes(-K.R(K.iG,K.iM),mmp.l.mtimes(atts,-phi));
return%a
% 1) This is the formula that uses the conjugate of K.R
%a = mp_multi(phi,mp_multi(-atts',-K.R'));
% 2) This is the formula that uses minplus calculus
%a = (mpm_multi(K.R(K.iG,K.iM),mpm_multi(-y,-phi)))';
% 3) This is the formula for bracket <y|x>=y' \otimesl R \otimesl x
% using the polars expressed in the minplus calculus...
%a = (mpm_multi(-K.R(K.iG,K.iM),mpm_multi(-atts,phi')))';
%  or maxplus calculus...
%a = -mmp.l.mtimes(K.R(K.iG,K.iM),mmp.l.mtimes(y,-phi'));
