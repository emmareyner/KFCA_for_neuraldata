function MM = fevalarray (M,fn_handle,verbose)

% fn is a function taking a Fx1 vector to a fx1 vector
% M is a FxN matrix
% MM is a fxN matrix
% verbose = 1 causes some progress reports.

if nargin < 3, verbose = 0; end;

[F,N] = size(M);

N10 = ceil(N/10);           
if verbose, fprintf (1,'['); end;
for i=1:N
  MM(:,i) = feval (fn_handle, M(:,i));
  if verbose & ~mod (i,N10), fprintf (1,'.'); end;
end;
if verbose, fprintf (1,']\n'); end;
