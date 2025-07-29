function Rstar = mmp_l_xXxZ_trclosure(R)
% function star = mmp_l_xXxZ_trclosure(R)
%
% Returns the lower transitive-reflexive (aka star, A*) closure of a
% non-null square sparse maxplus encoded matrix. If all the elements in the matrix are
% non-positive this is waaaaay more quick than mp_star.
%
% For strictly positive elements, it uses an iterative algorithm
% and it may take forever! (A warning is issued.)  
%
% See also, mp_star for the original version in the toolbox.
%
% TODO: iterative version of algorithm
[m n]=size(R);
if m~=n,
    error('Double:mmp_l_xXxZ_trclosure','Not a square matrix');
end
if ~issparse(R)
    error('Double:mmp_l_xXxZ_trclosure','sparse maxplus encoding required');
end

if m > 1
    Rstar = mmp_l_xXxZ_trclosure_raw(R);
elseif m == 1
    if (R(m,m) > eps)
        Rstar = Inf;
    else
        Rstar = eps;
    end
else%if m == 0
   error('Double:mmp_l_xXxZ_trclosure','0-dimension matrix!');
end
% switch m
%     case 0
%         error('Double:mmp_l_trclosure','0-dimension matrix!');
%     case 1%early termination
% %        if issparse(R), unit=eps; else unit = 0.0; end
%         if (R(m,m) > 0.0)
%             star = Inf;
%         else
%             star = 0.0;
%         end
%     otherwise
%         %Hmmm, perhaps the iterative algorithm is interesting after all
%         %star = sigma(R,m);
%         star = mmp_l_mpower(mmp_l_rclosure(R),m);
%         star_sq = mmp_l_square_raw(star);
%         %if any(any(star ~= star_sq))%this suggest encoding in minplus.
%             %Alternative 1: incredibly this goes really fast
%             %star = mp_star(star);
%             %alternative 2: not so fast
% %            warning('Double:mmp_l_trclosure','Might diverge!');
%             %star=mmp.n.sparse(star);
%             %star_sq=mmp.n.sparse(star_sq);
%             while any(any(mmp_l_ne(star,star_sq)))
%                 star = star_sq;
%                 %star_sq = mmp.l.mtimes(star,star);
%                 %star_sq = mmp.n.sparse.mtimesl(star,star);
%                 star_sq= mmp_l_square_raw(star);
%             end
%         %end
% end
return%Rstar
%end

% %%%This function here creates the actual closure without passing arguments!
% function star = sigma(R,m)
% %THis should be global
% %refClos = mp_eye(size(R));%The reflexive closure of R
% star = sig(R,m);
% return
% 
%     function star = sig(R,n)
%         % function star = sig(R,n)
%         % Builds the sum of powers from 0 to n
% 
%         switch n
%             case 0
%                 %star = refClos;
%                 star = mmp_l_eye(m);
%             case 1
%                 star = mmp_l_rclosure(R);
%                 %star = I+R
%             case 2
%                 star = mmp_l_rclosure(mmp_l_mtimes(R,mmp_l_rclosure(R)));
%                 %star = I+R+R^2=I+R(I+R)
%             otherwise
%                 R2 = mmp_l_square_raw(R,R);
%                 if (mod(n,2) == 0)%Even n
%                     newn = n/2 - 1;
%                     %newstar = sig(R2,newn);
%                     star = mmp_l_rclosure(mmp_l_mtimes(mmp_l_plus(R,R2),sig(R2,newn)));
%                     %star = I+(R+R^2)*sig(R2,newn)
%                 else%n is odd
%                     newn = (n-1)/2-1;
%                     %newstar = sig(R2,newn);
%                     star = mmp_l_mtimes(mmp_l_rclosure(R),mmp_l_mtimes(R2,sig(R2,newn)));
%                     %star = (I+R)*R^2*newstar
%                 end
%         end
%         return
%     end
end
