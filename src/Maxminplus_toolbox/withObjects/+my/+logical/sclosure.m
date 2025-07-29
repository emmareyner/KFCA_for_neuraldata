function sclos = sclosure(r)
%reflexive closure for a logical matrix

sclos = r | r.';
return
