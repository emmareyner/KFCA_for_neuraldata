function z = comb(A,r)

% returns n-choose-r x r matrix with all combinations of elements of the n-element vector A

n = length(A);

if r == 0 
  z = zeros(n,0);
elseif r == 1
  z = A;
elseif n < r
  z = zeros(0,r) ;
else
  withn = comb (A(1:n-1),r-1);      % a (n-1)choose(r-1) x r-1 array
  withoutn = comb (A(1:n-1),r);     % a (n-1)choose(r-1) x r array
  [a b] = size(withn);
  [an bn] = size(withoutn);
  if a*b,
    tmp = horzcat (withn,A(n)*ones(a,1)); 
    if an*bn, 
      z = vertcat (tmp, withoutn);
    else 
      z = tmp;
    end;
  else
    if an*bn
      z = withoutn;
    end;
  end;
end;





