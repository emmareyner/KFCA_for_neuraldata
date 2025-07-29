function [Z]=plus(X,Y);
%  mmp.u.plus   maxminplus upper matrix addition operation
%     upper-adds (takes min of) matrices X and Y.  X and Y 
%     must have the same dimensions unless one is a scalar (a 1-by-1
%     matrix). A scalar may be added to anything.
%
% Accepts: double, mmp.x.Sparse, mmp.n.Sparse
% Results is:
% - if both double, double
% - else if both mmp.x.Sparse then the result is mmp.x.Sparse (MXPLUS
% encoding) by means of Z=-(mmp.l.plus(-X,-Y))
% - else if any is mmp.xnSparse, then the result is mmp.n.Sparse (MNPLUS encoding)
%
% See also, mmp.l.plus, mmp.n.Sparse.plus, mmp.x.Sparse.plus
%
% FVA, CPM: 28/07/09

error(nargchk(2,2,nargin));
%FVA: 27/26/09. package and oo version
switch class(X)
    case 'double'
        switch class(Y)
            case 'double'
                Z = mmp_u_plus(X,Y);
            case 'mmp.n.Sparse'
                Z = X + Y;%Defaults to mm.n.plus which is upper addition
            case 'mmp.x.Sparse'
                Z = X + flipflop(Y);%a flipflop and an upper addition
            otherwise
                error('mmp:u:plus','unknown second input parameter type %s', class(Y))
        end
    case 'mmp.n.Sparse'
        switch class(Y)
            case {'double', 'mmp.n.Sparse'}
                Z = X + Y;%Defaults to mm.n.plus which is upper addition
            case 'mmp.x.Sparse'
                Z = X + flipflop(Y);
            otherwise
                error('mmp:u:plus','unknown second input parameter type %s', class(Y))
        end
    case 'mmp.x.Sparse'
        switch class(Y)
            case {'double', 'mmp.n.Sparse'}
                Z = flipflop(X) + Y;%Defaults to mm.n.plus which is lower addition
            case 'mmp.x.Sparse'%stranger, Why not upper-add them?
                Z = flipflop(X) + flipflop(Y);
                %this should be equivalent to, but it isn't since the
                %result should be re-maxplus encoded.
                %Z = mmp.x.Sparse(-(mmp_u_plus(-X.Reg,-Y.Reg)));
            otherwise
                error('mmp:u:plus','unknown second input parameter type %s', class(Y))
        end
    otherwise
        error('mmp:u:plus','unknown first input parameter type %s', class(X))
end

% %% conformance analysis
% %sizX=size(X);
% %sizY=size(Y);
% [mX nX]=size(X);
% [mY nY]=size(Y);
%     
% %Conformance analysis drives the case-sifting
% %% 1. X is scalar
% %if all(sizX==1)
% if (mX == 1) && (nX == 1)
%     Xscalar = mmp.full(X);%TODO: maybe inline.
%     switch Xscalar
%         case Inf%minplus zero
%             Z=Y;
%         case -Inf%minplus top
%             Z=mmp.x.zeros(mY,nY);
%         otherwise
%             if isa(Y,'mmp.sparse')
%                Z=min(Xscalar,mmp.full(Y));%TODO: maybe inline
%             else%Y is full
%                Z=min(Xscalar, Y);%allowed in matlab
%             end
%     end
%     return
% 
%     
% %2. Y is scalar
% elseif (mY == 1) && (nY == 1)
%     Yscalar = mmp.full(Y);%TODO maybe inline.
%     switch Yscalar
%         case Inf%minplus zero
%             Z=X;
%         case -Inf%minplus top
%             Z=mmp.x.zeros(mX,nX);
%         otherwise%in any othe case, we have a scalar/full matrix.
%             if isa(X,'mmp.sparse')
%                 Z=min(Yscalar,mmp.full(X));%TODO: maybe inline
%             else%X is full
%                 Z=min(X, Yscalar);%allowed in matlab
%             end
%     end
%     return
% 
% 
% elseif (mX ~= mY) || (nX ~= nY)%any(sizX~=sizY)
%     error('mmp:u:plus','Non-conformant matrices!');
% 
% %% 3. Conformant, i.e. non-scalar.% all(sizX==sizY)%
% %If any is in maxplus, result is in maxplus
% elseif isa(X,'mmp.x.sparse')
%     Z=mmp.x.sparse.plusu(X,Y);
% elseif isa(Y,'mmp.x.sparse')
%     Z=mmp.x.sparse.plusu(Y,X);
% %otherwise if any is full, result is full
% elseif isa(X,'double') || isa(Y,'double')
%     if ~isa(Y,'double'), Y=mmp.full(Y); end
%     if ~isa(X,'double'), X=mmp.full(X); end
%     Z=min(X,Y);
% else%both minplus, result is minplus
%     Z=X+Y;%overloaded to mmp.n.sparse.plus
% end

return%Z
