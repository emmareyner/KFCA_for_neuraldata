function rclos = rclosure(r)
%maxplus lower reflexive closure for a double matrix
rclos=mmp.x.Sparse();
rclos.Reg=mmp_l_xXxZ_rclosure(r.Reg);
return
