function yes = private_eqnum (x,y)

% Assumes x,y are numeric, doesnt check that (for speed).
% Returns 1 (true) if both x,y are NaN xor x==y. 

yes = (isnan (x) & isnan (y)) | (x==y);
