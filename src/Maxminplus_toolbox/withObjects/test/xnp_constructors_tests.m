%Script to test basic constructors of xp and np matrices
mX=8;nX=4;

%%%% ZERO CONSTRUCTORS
X=xp_zeros(mX);
if all(all(xnp_full(X)==-Inf(mX)))
    warning('%s: %s %s','xp_zeros','with one scalar argument', 'seems ok')
else
    warning('%s: %s %s','xp_zeros','with one scalar argument','is WRONG')
end

X=xp_zeros(mX,nX);
if all(all(xnp_full(X)==-Inf(mX,nX)))
    warning('%s: %s %s','xp_zeros','with one scalar argument', 'seems ok')
else
    warning('%s: %s %s','xp_zeros','with one scalar argument','is WRONG')
end

%%%%UNIT CONSTRUCTORS
X=xp_ones(mX);
if all(all(xnp_full(X)==zeros(mX)))
    warning('%s: %s %s','xp_ones','with one scalar argument', 'seems ok')
else
    warning('%s: %s %s','xp_ones','with one scalar argument','is WRONG')
end

X=xp_ones(mX,nX);
if all(all(xnp_full(X)==zeros(mX,nX)))
    warning('%s: %s %s','xp_ones','with one scalar argument', 'seems ok')
else
    warning('%s: %s %s','xp_ones','with one scalar argument','is WRONG')
end

%%%Diagonal extractions, constructions
mX=8
tic
zs=xp_ones(mX);
dzs=xp_diag(zs);
xp_diag(dzs);
toc
if all(all(xnp_isequal(xp_diag(dzs),xp_eye(mX))))
