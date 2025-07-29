function Y=mmp_n_to_x(X)
%Transforms MNPLUS encoded sparse matrix into a MXPLUS encoded sparse
%matrix.
if issparse(X)
    Y=X;%transport all non-zero,non-top,non-unit
    Y(X==-eps)=eps;%transform old units
    Y(X==0)=Inf;%transform old zeros
    Y(X==-Inf)=0;%Delete old tops
else
    error('double:mmp_n_to_x','Non-sparse input matrix!');
end
return%Y in sparse MNPLUS representation
