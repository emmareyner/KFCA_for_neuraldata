function r = round10 (s,down)

% ROUND10 (rounds up - or down - x to nearest power of 10)
%
%	r = round10 (s,down)
%
%	if down = 0 (default), r is rounded down, else up.
%

if nargin < 2, down = 0; end;

if down, f = @floor; else f = @ceil; end;

% rounding should be to 100, 200, 300, 400, 500 or 1000. 

r = 10 ^ feval(f, log10(s));

if down
  for t = [0.7 0.5  0.4 0.2 0.1]
     if s > t * r, 
       r = t * r;
       break;
     end;
   end; 
else 
  for t = [0.1 0.2  0.4 0.5 0.7]
     if s < t * r, 
       r = t * r;
       break;
     end;
   end; 
end;


