function display (lab)

% DISPLAY contents of lab, which is of type LABELS 

init = '    ';      % initial spacing

fprintf('\n');

fprintf (1,' %s (object of type LABELS) = \n', inputname(1));
fprintf (1,'\n');

fprintf (1,charcat(init, private_allphones (lab), '\n'));

