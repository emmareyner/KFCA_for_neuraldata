function Y = mpower_raw(X,n)
% matrix power for square matrices and positive integer exponents WITHOUT
% parameter checking

mX = size(X,1);
%Change the parameter switching to favour normal cases
if n > 0
    %use n for i, Y to accumulate result, X to accumulate
    %factor. This does some extra work when n == 1
    %The first factor is the Y matrix.
    if issparse(X)
        Y = logical(speye(mX));
    else
        Y = logical(eye(mX));
    end
    while n > 0
        if bitget(n,1)%first bit to 1 => odd
            Y = my.logical.mtimes_raw(Y,X);%use a raw primitive!
        end
        %X = mmp_l_square_raw(X);%use a squaring primitive!
        X = my.logical.mtimes_raw(X,X);
        n = bitshift(n,-1);%divide by two
    end
elseif n == 0
    Y = my.logical.rclosure(false(mX,mX));
else%n <0
    error('my:logical:mpower','undefined matrix power on negative exponent');
end
return
