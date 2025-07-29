function [Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = spectra(A)%,str)
%function [Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = mmp.l.spectra(A,str)
%
% A function to build all the spectra and reorder eigenvalues and
% eigenvectors in the original order
%

%The entry point tries to build a UFNF_3 form
[Lev,Llamb,Len,Rev,Rlamb,Ren,nodes,Aplus] = mmp.l.Spectrum.of_digraph(A);
%TO return results wrt the original order, we permute according to nodes,
%Ren, Len
[nodes,perm]=sort(nodes);%permutation on the whole set of nodes
[Ren,cperm]=sort(Ren);%permutation on the critical nodes
%Rev=Rev(perm,cperm);
Rev=double(Rev(perm,cperm));
Rlamb=Rlamb(cperm);
% if ~all(all(full(mmp.l.mtimes(A,Rev) == mmp.l.mtimes(Rev,mmp.l.diag(Rlamb)))))
%     error('Right eigenvectors NOT correct for %s',str)
% else
%     fprintf('Right eigenvectors CORRECT for  %s\n',str);
% end
[Len,cperm]=sort(Len);%permutation on the critical nodes
Lev=double(Lev(cperm,perm));
Llamb = Llamb(cperm);
% if ~all(all(full(mmp.l.mtimes(Lev,A) == mmp.l.mtimes(mmp.l.diag(Llamb),Lev))))
%         error('Left eigenvectors NOT correct for %s',str)
% else
%     fprintf('Left eigenvectors CORRECT for  %s\n',str);
% end
return
