function Z = mmp_l_square_raw(Y)
% raw lower maxminplus squaring primitive
% see http://en.wikipedia.org/wiki/Repeated_squaring, naive first algorithm

Z = mmp_l_mtimes_raw(Y,Y);
% [m,n]=size(Y);%and we presuppose m==n
% %solve in basic domain : cast to supertype
% X=Y.';%Transpose (negligible cost) to make row extraction easier.
% %produce X*Y with both in column-major form
% if issparse(Y)
%     Z=sparse(m,n);%return sparse matrix
%     eps2=eps(2);
%     for i=1:m
%         rowX=X(:,i);%Extract as much work out of the loop as possible
%         Xnz = (rowX ~= 0.0);%Preassign
%         for j=1:n
%             %locate places that would go to -Inf
%             colY=Y(:,j);
%             nz= Xnz & (colY ~= 0.0);
%             %if there are any places not going to -Inf
%             if any(nz)
%                 %FVA: Q: why not first do the max, then detect 0 or 2*eps
%                 %and correct? A: The following takes less time!
%                 %res=max(pom);
%                 res=max(rowX(nz)+colY(nz));
%                 %detect generated zeros
%                 if abs(res) > eps2
%                     %if ((res~=0) && (res~=eps2))
%                     Z(i,j)=res;
%                 else
%                     Z(i,j)=eps;
%                 end
%                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             end
%         end
%     end
% else%full multiplication
%     Z=-Inf(m,n);%return full, matrix.
%     for i=1:m
%         rowX=X(:,i);%Extract as much work out of the loop as possible
%         Xnz = (rowX ~= -Inf);%Filter non-zero elements
%         if any(Xnz)
%             for j=1:n
%                 colY=Y(:,j);%Just one extraction
%                 XYnz = Xnz & (colY ~= -Inf);
%                 if any(XYnz), Z(i,j)=max(rowX(XYnz)+colY(XYnz)); end
%                 %Just ignore coordinates in which X or Y show a zero: these go
%                 %to zero
%             end
%         end
%     end
% end
return%Z
