function z = stripext (fname)

% fname has an extension. remove it.
% extensions are assumed to have three characters only. (works for
% our needs!)

F = length(fname);
if F & strcmp (fname(F-3:F-3),'.'), 
   z = fname(1:F-4); 
else
   z = fname;
end;

  


