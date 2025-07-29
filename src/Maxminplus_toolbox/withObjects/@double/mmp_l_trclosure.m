function Rstar = mmp_l_trclosure(R)
% function star = mmp_l_trclosure(R)
%
% Returns the lower transitive-reflexive (aka star, A*) closure of a
% non-null square mmp.l.Double matrix. If all the elements in the matrix are
% non-positive this is waaaaay more quick than mp_star.
%
% For strictly positive elements, it uses an iterative algorithm
% and it may take forever! (A warning is issued.)  
%
% See also, mp_star for the original version in the toolbox.
%
% TODO: iterative version of algorithm
if issparse(R)
        error('Double:mmp_l_trclosure','full encoding required');
end
[m n]=size(R);
if  m==n
    if m > 1
        Rstar = mmp_l_trclosure_raw(R);
    elseif m == 1
            if R > 0, Rstar = Inf; else Rstar = 0; end
    else%m==0
            error('Double:mmp_l_trclosure','undefined on empty matrix');
    end
else
        error('Double:mmp_l_trclosure','Not a square matrix');
end
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
