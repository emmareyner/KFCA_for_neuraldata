function ph = private_phones (lab)

% PRIVATE_PHONES private function of class LABELS. 
%  ph = private_phones (lab)
%
%  ph is string of onelabels in lab, which is of type LABELS.

ph = '';
for i = 1 : length (lab.data)
    ph = charcat (ph, lab.data{i}{1});
end;

