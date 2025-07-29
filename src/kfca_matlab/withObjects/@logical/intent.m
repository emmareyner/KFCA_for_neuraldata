function b = intent(I,a)
% Works out the intents of a matrix with columns that are extents.
[ga na] = size(a);
[g m] = size(I);
if (g ~= ga)
    error('logical:intent','Non-conformant incidence and extents');
end
if issparse(a)
    b=logical(sparse(m,na));
else
    b=false(m,na);
end
for i = 1:na
    b(:,i)=all(I(a(:,i),:),1)';
end
return
