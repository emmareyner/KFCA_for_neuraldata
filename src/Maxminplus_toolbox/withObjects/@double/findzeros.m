function [zr,zc]=findzeros(A)
%function [zr,zc]=findzeros(A)
% Finds the zero cols and rows of a matrix
%
% FVA: 12/11/2010

[m,n]=size(A);
%if issparse(A)
    zr=sparse(1,1:m,true);
    zc=sparse(1,1:n,true);
% else
%     zr=true(1,m);%Still a row although it masks cols
%     zc =true(1,n);%A mask for columns, hence a row
% end
[nzr,nzc]=find(A);%specially easy for sparse mats.
zr(nzr)=false;%zr=find(zr);
zc(nzc)=false;%zc=find(zc);
return%zr,zc
