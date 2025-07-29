function d = private_finddp (M,smallest)

%    Suppose MAX is the largest entry in M
%    and MINnz the smallest nonzero entry in magnitude:
%      if MAX <= 1
%        MAX = a x 10^d, for a in 1..9
%      else
%        MINnz = a x 10^d, for a in 1..9
%      endif
%
%    Any entries below smallest are assumed to be zero.

Mp = abs(M);
MAX = fullmax (Mp);
d = 0;
if MAX > 1 
  if MAX > smallest
    MIN = min (Mp (Mp > smallest));
    while (MIN < 1)
      MIN = MIN * 10;
      d = d + 1;
    end;
  else
    d = floor (log10(smallest));
  end;
else
  d = floor (log10 (MAX));
end;
