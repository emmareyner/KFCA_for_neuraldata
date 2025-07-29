function rclos = rclosure(r)
%maxplus upper reflexive closure for a double matrix
%rclos=mmp.n.Sparse();
%rclos.Reg=mmp_u_nXnZ_rclosure(r.Reg);
rclos = mmp.n.Sparse(mmp_u_nXnZ_rclosure(r.Reg));
return
