function [Z]=plus(X,Y)
%  oplusl   Maxplus lower addition operation
%     mmp.l.plus(X,Y) lower-adds (takes max) matrices X and Y.  X and Y
%     must have the same dimensions unless one is a scalar (a 1-by-1
%     matrix). A scalar can be added to any matrix.
%
% Accepts: double, mmp.x.Sparse, mmp.n.Sparse
% Results is:
% - if both double, double
% - else if both mmp.n.Sparse then the result is mmp.n.Sparse (MNPLUS
% encoding) by means of Z=-(mmp.u.plus(-X,-Y))
% - else if any is mmp.x.Sparse, then the result is mmp.x.Sparse (MXPLUS encoding)
%
% See also, mmp.u.plus, mmp.n.Sparse.plus, mmp.x.Sparse.plus
% FVA, CPM: 28/07/09

error(nargchk(2,2,nargin));
%FVA: 27/26/09. package and oo version
switch class(X)
    case 'double'
        switch class(Y)
            case 'double'
                Z = mmp_l_plus(X,Y);
            case 'mmp.x.Sparse'
                Z = X + Y;%Defaults to mm.x.plus which is lower addition
            case 'mmp.n.Sparse'
                Z = X + flipflop(Y);%a flipflop and a lower addition
            otherwise
                error('mmp:l:plus','unknown second input parameter type %s', class(Y))
        end
    case 'mmp.x.Sparse'
        switch class(Y)
            case {'double', 'mmp.x.Sparse'}
                Z = X + Y;%Defaults to mm.x.plus which is lower addition
            case 'mmp.n.Sparse'
                Z = X + flipflop(Y);
            otherwise
                error('mmp:l:plus','unknown second input parameter type %s', class(Y))
        end
    case 'mmp.n.Sparse'
        switch class(Y)
            case {'double', 'mmp.x.Sparse'}
                Z = flipflop(X) + Y;%Defaults to mm.x.plus which is lower addition
            case 'mmp.n.Sparse'%stranger, Why not upper-add them?
                Z = flipflop(X) + flipflop(Y);
                %this should be equivalent to: ( but it isn't since the
                %result should be re-maxplus encoded.)
                %Z = mmp.n.Sparse(-(mmp_l_plus(-X.Reg,-Y.Reg)));
            otherwise
                error('mmp:l:plus','unknown second input parameter type %s', class(Y))
        end
    otherwise
        error('mmp:l:plus','unknown first input parameter type %s', class(X))
end
% %% conformance analysis
% %sizX=size(X);
% %sizY=size(Y);
% [mX nX]=size(X);
% [mY nY]=size(Y);
% 
% %Conformance analysis drives the case-sifting
% %% 1. X is scalar
% if (mX == 1) && (nX == 1)
%     Xscalar = double(X);%TODO: maybe inline.
%     switch Xscalar
%         case -Inf%maxplus zero
%             Z=Y;
%         case Inf%maxplus top
%             Z=mmp.n.zeros(mY,nY);
%         otherwise
%             if isa(Y,'mmp.sparse')
%                Z=max(Xscalar,full(Y));%TODO: maybe inline
%             else%if Y.xpsp%Y in maxplus sparse encoding
%                Z=max(Xscalar, Y);%allowed in matlab
%             end
%     end
%     return
% 
%     
% %2. Y is scalar
% elseif (mY == 1) && (nY == 1)
%     Yscalar = mmp.full(Y);%TODO maybe inline.
%     switch Yscalar
%         case -Inf%maxplus zero
%             Z=X;
%         case Inf%maxplus top
%             Z=mmp.n.zeros(mX,nX);
%         otherwise%in any othe case, we have a scalar/full matrix.
%             if isa(X,'mmp.sparse')
%                 Z=max(Yscalar,mmp.full(X));%TODO: maybe inline
%             else%if X.xpsp%Y in maxplus sparse encoding
%                 Z=max(X, Yscalar);%allowed in matlab
%             end
%     end
%     return
% 
% 
% elseif (mX ~= mY) || (nX ~= nY)
%     error('mmp:l:plus','Non-conformant matrices!');
% 
% %% 3. Conformant, i.e. non-scalar.% all(sizX==sizY)%
% %If any is in minplus, result is in minplus
% elseif isa(X,'mmp.n.sparse')
%     Z=mmp.n.sparse.plusl(X,Y);
% elseif isa(Y,'mmp.n.sparse')
%     Z=mmp.n.sparse.plusl(Y,X);
% %otherwise if any is full, result is full
% elseif isa(X,'double') || isa(Y,'double')
%     if ~isa(Y,'double'), Y=mmp.full(Y); end
%     if ~isa(X,'double'), X=mmp.full(X); end
%     Z=max(X,Y);
% else%both maxplus, result is maxplus
%     Z=X+Y;%overloaded to mmp.x.sparse.plus
% end
return
