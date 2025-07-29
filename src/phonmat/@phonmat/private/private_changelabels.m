function private_changelabels (pm, L)

% PRIVATE_CHANGELABELS private mamber function of class PHONMAT
% 
%       newpm = private_changelabels (pm, L)
%
%	pm is a PHONMAT object and L a LABELS object. 
%       newpm is a PHONMAT object that is pm with pm.labels = L

N = L.size;
ph = L.phones;
oldL = pm.labels;
NewMat = repmat (pm.default, N, N);

S.type = '()';
for i = 1 : N
    for j = 1 : N
	a = oldL (ph(i));
	b = oldL (ph(j));
	S.subs = {ph(i), ph(j)};
	if a & b
	  NewMat (i,j) = subsref (pm, S);
	else
	  NewMat (i,j) = NaN;
        end;
    end;
end;

pm.labels = L;
pm.mat = NewMat;

assignin ('caller', inputname(1), pm);
