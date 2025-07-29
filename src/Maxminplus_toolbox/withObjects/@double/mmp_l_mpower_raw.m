function Y = mmp_l_mpower_raw(X,n)
% matrix power for FULL square matrices and positive integer exponents
% WITHOUT parameter checking

mX = size(X,1);
%Change the parameter switching to favour normal cases
if n >= 1
    Y = mmp_l_eye(mX);
    %use n for i, Y to accumulate result, X to accumulate
    %factor. This does some extra work when n == 1
    %The first factor is the Y matrix.
    while n > 0
        if bitget(n,1)%first bit to 1 => odd
            Y = mmp_l_mtimes_raw(Y,X);%use a raw primitive!
        end
        %X = mmp_l_square_raw(X);%use a squaring primitive!
        X = mmp_l_mtimes_raw(X,X);
        n = bitshift(n,-1);%divide by two
    end
elseif n == 1
    Y = X;
elseif n == 0
    Y = mmp_l_eye(mX);
else%n <0
    error('double:mmp_l_mpower_raw','undefined matrix power on negative exponent');
end
return
