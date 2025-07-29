function pv = subrc (pm,rownum,sublabels,notetitle)

% SUB member function of class PHONMAT. Used to extract a submatrix.
%    pv = subrc (pm, rownum, slabels, [notetitle] )
%
%    pm is of type PHONMAT and slabels a k-long string with k onelabels 
%     of the rownum'th row of pm to be included in pv. rownum is a char or int.
%    The title of pv is the same as that of pm, with possibly one difference.
%     If notetitle = 1, then information about the original set of
%     phones (and rownum) is added to the title of subpm. 
%     The dafault value of notetitle is 0 or 1 depending on whether
%     sublabels is simply a rearrangement of pm.labels or a proper
%     subset of it, respectively. 

%  FIRST ARG

if ~isa (pm, 'phonmat')
   error ('first argument should be of type PHONMAT')
end;

%  SECOND ARG

LAB = pm.labels;
rowchar = LAB{rownum};
if length (rownum) ~= 1
  error ('third argument should represent a row in the first argument');
end;

%  THIRD ARG

if nargin < 3
  sublabels = removeelem (LAB.phones,rowchar);
end;
if ~ischar (sublabels) 
   error ('third argument should be a string');
end;

L = findcommon (sublabels,LAB.phones);

%  FOURTH ARG

T = pm.title;
if nargin < 4
  notetitle = length (L) ~= length (get(pm,'phones'));
end;
if notetitle
  subtitle = sprintf ('%s (EXTRACTED FROM ROW %s OF MATRIX INVOLVING %s)',  pm.title, rowchar,  pm.labels.phones);
end;

% now make sure sublabels only has elements that are in pm.labels.
% where(i) has the index in pm.labels of where the i-th valid member
%   of sublabels is.

V = [];
S.type = '()';
for i = 1 : length (L)
  S.subs = {rowchar, L(i)};
  a = subsref (pm,S);
  V = [V a];
end;

pv = phonvec (L,V,T);





