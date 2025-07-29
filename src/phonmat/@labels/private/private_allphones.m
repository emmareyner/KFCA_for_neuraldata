function ph = private_allphones (lab)

% PRIVATE_ALLPHONES is a private function of class LABELS

ph = '';

for i = 1 : length (lab.data)
  n = length (lab.data{i});
  ph = charcat (ph,' ', lab.data {i}{1} );
  AlternativeLabels = lab.data{i} (2 : n);
  if n > 1
    ph = charcat (ph, ' (');
    for j = 1 : n-1
      ph = charcat (ph, AlternativeLabels{j});
      if j < n-1, ph = charcat (ph, ' ');  end;
    end;
    ph = charcat (ph, ')');      
  end;
end;
  

