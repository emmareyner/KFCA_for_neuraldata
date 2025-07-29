function [L,lab] = list (pm,abd)

% LIST retrieves specified entries of a PHONMAT as a vector
%
%	[L,lab] = list (pm,abd)
%
%	if pm.diagx is a character and isn't all zero, diagonal
%	elements of pm.mat are included in L.
%
%	lab is a cell array of 2-char strings that goes with L.
%	lab{i} = 'xy' means that L(i) was the ('x','y')-th entry of pm.
%
%       abd is a string that can contain the letters 'a','b' or 'd' in 
%        any order. Other letters are ignored. 'abd' stand for whether
%        the belowdiagonal, abovediagonal and/or diagonal entries should
%        be returned. If pm has no meaningful diagonal entries (i.e. 
%        pm.hasdiag = 0) then an argument including 'd' is ignored. 
%       If abd is not supplied, a default value is used, as indicated in the
%        example below.
%       
%       e.g. suppose you have three PHONMAT objects W,X,Y,Z.
%            W and X have meaningul diagonal entries.
%            X and Y are symmetric. 
%
%       W  a b c    X  a b c     Y  a b c      Z  a b c
%        a 1 2 3     a 1 2 3      a . 2 3       a . 2 3
%        b 4 5 6     b . 5 6      b . . 6       b 4 . 6
%        c 7 8 9     c . . 9      c . . .       c 7 8 .
%
%      list (W), like list (W,'abd'), returns [2 3 6 4 7 8 1 5 9].
%      list (W,'ba') returns [4 7 8 2 3 6]
%      list (W,'baba') returns [4 7 8 2 3 6 4 7 8 2 3 6]
%      list (W,'baa') returns [4 7 8 2 3 6 2 3 6]
%      list (W,'ad') returns [2 3 6 1 5 9]
%      list (X), like list (X,'ad'), returns [2 3 6 1 5 9]
%      list (X,'ab') returns [2 3 6 2 3 6]
%      list (X,'d') returns [1 5 9]
%      list (Y), like list (Y,'a'), returns [2 3 6]
%      list (Y,'ab') returns [2 3 6 2 3 6]
%      list (Y,'d') returns  []
%      list (Y,'bd') returns [2 3 6]
%      list (Z), like list (Y,'ab'), returns [2 3 6 4 7 8]
%      list (Z,'abd') returns [2 3 6 4 7 8]
%      list (Z,'db') returns [1 5 9 4 7 6]
%
%      While all the above examples return a single value, that's 
%      only because a single one was asked for. If you say  for example
%      [L,lab] = list (Y,'bd'), you get
%         L = [2 3 6], 
%         lab = {'ba','ca','cb'}

if nargin == 1
  abd = '';
  if pm.hasdiag, 
    abd = 'd';
  end;
  if pm.symmetric
    abd = ['a' abd];
  else
    abd = ['ab' abd];
  end;
end;
	
lb = pm.labels;
n = size(pm.mat,1);
 
lab = {};
L = [];

S.type = '()';

for k = abd
  if k == 'a'
     for i = 1 : n
        for j = i+1 : n
	    S.subs = {i,j};
	    L (length(L)+1) = subsref (pm, S);
%            L (length(L)+1) = pm.mat(i,j);
	    lab {length(lab)+1} = charcat (lb{i},lb{j});
         end;
      end;
  elseif k == 'b'
     for i = 2 : n
        for j = 1 : i-1
            S.subs = {i,j};
            L (length(L)+1) = subsref (pm, S);
%            L (length(L)+1) = pm.mat(i,j);
            lab {length(lab)+1} = charcat (lb{i},lb{j});
        end;
     end;
  elseif k == 'd' & pm.hasdiag
     for i = 1 : n
       S.subs = {i,i};
       L (length(L)+1) = subsref (pm, S);
%       L (length(L)+1) = pm.mat(i,i);
       lab {length(lab)+1} = charcat (lb{i},lb{i});
     end;
  end;
end;
