function Rstar = mmp_u_trclosure(R)
% function star = mmp_u_trclosure(R)
%
% Returns the upper transitive-reflexive (aka star, A_*) closure of a
% non-null square double matrix. If all the elements in the matrix are
% non-negative this is waaaaay more quick than mp_star.
%
% For strictly negative elements, it uses an iterative algorithm
% and it may take forever! (A warning is issued.)  
%
% See also, mpm_star for the original version in the toolbox.
%
% TODO: iterative version of algorithm
[m n]=size(R);
if m~=n,
    error('Double:mmp_u_trclosure','Not a square matrix');
end
if issparse(R)
    error('Double:mmp_u_trclosure','full encoding required');
end

if m > 1
    Rstar = mmp_u_trclosure_raw(R);
elseif m == 1
    if (R(m,m) > 0.0)
        Rstar = -Inf;
    else
        Rstar = 0.0;
    end
else%if m == 0
    error('Double:mmp_u_trclosure','0-dimension matrix!');
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
