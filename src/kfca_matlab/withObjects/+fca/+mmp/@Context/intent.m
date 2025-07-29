function [b] = intent(K,phi,objs)
%function [b] = fca.mmp.intent(K,phi,objs)
%
%Input: (order of parameters to suggest order of formula)
% - phi: the \varphi parameter of k-FCA
% - K: a maxplus formal context
% - objs: a maxplus object set, i.e. a COLUMN or matrix of COLUMNS.
%Output:
% - b: an intent, a maxplus-weighted attribute set (i.e. a column
% vector). If [objs] is a matrix of cols, then [b] is a matrix of columns
% coindexed by column with [objs].

%FVA: intent formula checked Feb 2010 obj sets are columns too!
%FVA: intent formula checked May2009. obj sets are columns too.
if ~isscalar(phi)
    error('mmp:kfca:Contexts:intent','not a valid phi parameter');
end
%   if ~isscalar(phi)
%     error('not a valid phi parameter')
%   end
%if (size(objs,2) ~= K.g)
 %   error('mmp:kfca:Contexts:intent','input is not a valid object set');
%end
%   if (size(objs,1) ~= K.g)%But we allow matrices here!
%     error('input is not a valid object set')
%   end

% The formulae using COLUMNS for objects are:
% 1) This is the formula that uses the transpose of K.R
% b = mmp.u.mtimes(mmp.u.mtimes(K.R(K.iG,K.iM)',-objs),phi)
% 2) The formula that transposes at the end:
b = mmp.u.mtimes(phi,mmp.u.mtimes(-objs',K.R(K.iG,K.iM)))';
%b = mmp.u.mtimes(-(mmp.l.mtimes(objs',K.R(K.iG,K.iM)))',phi);


% 3) This is the formula that works in maxplus (same as 2 but negated)
%b = -mmp.l.mtimes(-phi,mmp.l.mtimes(objs',-K.R(K.iG,K.iM)))';
return%b

%OLD FORMULAE; PRE-INS paper
  % 1) This is the formula that uses the conjugate of K.R
  %b = -mp_multi(-K.R(K.iG,K.iM)',mp_multi(objs',phi));
  % 2) This is the formula that uses minplus calculus
  %b = mpm_multi(K.R(K.iG,K.iM)',mpm_multi(-objs',-phi));
  % 3) This is the formula for bracket <y|x>=y' \otimesl R \otimesl x
  % using the polars expressed in the minplus calculus...
  %b = mpm_multi(-K.R(K.iG,K.iM)', mpm_multi(-objs,phi));
  %or the maxplus calculus...  
%b = -mmp.l.mtimes(-phi',mmp.l.mtimes(objs',K.R(K.iG,K.iM)));
% if issparse(K.R) && issparse(objs)
%     if ~issparse(objs), objs=mmp_l_sparse(objs); end
%     if ~issparse(K.R), K.R = mmp_l_sparse(K.R); end
%     b= -(mmp_l_mtimes(-phi',mmp_l_mtimes(objs', K.R(K.iG,K.iM))))';
% else
%   b = -(mmp_l_mtimes(-phi',mmp_l_mtimes(objs', K.R(K.iG,K.iM))))';
% end
