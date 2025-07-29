function a = extent(I,b)
% Works out the extents of a matrix with columns that are intents.
[mb nb] = size(b);
[g m] = size(I);
if (m ~= mb)
    error('logical:extent','Non-conformant incidence and intents');
end
if issparse(b)
    a=logical(sparse(g,nb));
else
    a=false(g,nb);
end
for bi = 1:nb
    a(:,bi)=all(I(:,b(:,bi)),2);
end
return
