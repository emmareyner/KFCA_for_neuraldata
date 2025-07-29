function Y=mmp_x_to_n(X)
%Transforms MXPLUS encoded sparse matrix into a MNPLUS encoded sparse
%matrix. Use SPARINGLY: on really sparse matrices this can be very costly.

if issparse(X)
    Y=X;%transport all non-zero,non-top,non-unit
    Y(X==eps)=-eps;%transform old units
    Y(X==0)=-Inf;%transform old zeros
    Y(X==Inf)=0;%Delete old tops
else
    error('double:mmp_x_to_n','Non-sparse input matrix!');
end
return%Y in sparse MNPLUS representation
