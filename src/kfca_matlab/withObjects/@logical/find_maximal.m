function mprime=find_maximal(I)
%Find maximal column in boolean matrix I.
[kk,mprime]=max(sum(I));
mprime=mprime(1);%if several maxima, choose first
return
%Maybe this would better be done with bits.
% [s1,s2]=size(I);
% i=2;
% mprime=1;
% while i<=s2
%  if any((I(:,mprime)-I(:,i))==-1)
%     if ~any((I(:,i)-I(:,mprime))==-1)
%         mprime=i;
%     end
%  end
%  i=i+1;
% end
