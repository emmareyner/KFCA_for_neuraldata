function pm2 = convert (pm1, fn_handle1, fn_handle2, title)

% CONVERT converts one PHONMAT object to another
%
%       pm2 = convert (pm1, fn_handle1, fn_handle2, [title])
%
%	pm1 and pm2 are both PHONMAT objects
%       fn_handle1 = @f, where f is a function of the form
%       f (A,i,j) = value based on A(i,j), possibly using entire A, 
%	            where A is a numeric matrix, producing a single
%		    argument that g can take
%       fn_handle2 = @g, where g is a function of the form
%       g (A,i,j) = takes argument produced by f and returns real number
%       pm2.title = pm1.title if no title is supplied.

if nargin == 3
  title = pm1.title;
end;

if ~isa(pm1, 'phonmat')
  error ('first argument should be of type PHONMAT');
end;

n = pm1.labels.size;
for i = 1 : n
  for j = 1 : n
    A (i,j) = feval (fn_handle2, feval (fn_handle1, pm1, i, j));
  end
end

pm2 = phonmat (A, pm1.labels, title);


