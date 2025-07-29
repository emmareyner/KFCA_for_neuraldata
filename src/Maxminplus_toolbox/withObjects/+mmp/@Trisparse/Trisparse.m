classdef Trisparse
    % maxminplus toolbox sparse matrices
    %the default values are used for implicit construction
    properties
        Reg=sparse(0,0);
        Topp=logical(sparse(0,0));
        Unitp=logical(sparse(0,0));
    end
    %sparse encoding type: Xpsp=true for maxplus encoding and false for
    %minplus encoding
    properties (SetAccess = 'protected')%May be (Abstract)
        Xpsp;
    end
    methods%public, ie accessible from anywhere
        %Constructors CANNOT be OVERLOADED!
        function obj = sparse(args)
            % accepts many different forms sparse(), sparse({}),sparse({X}),
            switch nargin
                case 0%0-ary constructor
                    m=0;n=0;
                case 1%single cell array of parameters
                    switch length(args)
                        case 0%unary but void arguments
                            m=0;n=0;
                        case 1%Only one parameter passed
                            X=args{1};
                            if isa(X,'double')%only make room, don't fill
                                if all(size(X)==[1 2])%dimension specs!
                                    m=X(1);n=X(2);
                                else%Otherwise full matrix to be sparsified.
                                    [m n]=size(X);
                                end
                            elseif isa(X,'mmp.sparse')%either xp or np encoding:copy
                                obj.Reg=X.Reg;
                                obj.Unitp=X.Unitp;
                                return
                            else
                                error('mmp:sparse','Wrong input parameter');
                            end
                        case 2
                            X=args{1};Y=args{2};
                            if isscalar(X) && isscalar(Y)
                                m=X;n=Y;
                            else
                                error('mmp:sparse','Wrong input parameter configuration');
                            end
                    end
                otherwise
                    error(nargchk(0,1,nargin));
                    %for two arguments, they must be scalar dimensions
            end
            obj.Topp=logical(sparse(m,n));
            obj.Unitp=logical(sparse(m,n));
            obj.Reg=sparse(m,n);
            return%obj
        end
        %[m,n]=size(obj)%method prototype
        function obj = set.Xpsp(obj,xpflag)
            obj.Xpsp=xpflag;
        end
    end
    %Methods that should *not* be redefined in lower classes.
    methods (Sealed=true)
        %A) MORE CONSTRUCTORS
        %A method to calculate the conjugate transpose
        function [Z] = ctranspose(X)
            if isa(X,'mmp.x.sparse')
                Z=mmp.n.sparse();
            else%must be mmp.n.sparse
                Z=mmp.x.sparse();
            end
            Z.Reg   = -X.Reg.';%conjugate finite non-tops
            Z.Unitp = X.Unitp.';%transpose (and invert) units
            Z.Topp  = X.Topp.';%transpose (and change encoding) for tops
        end
        function [Z] = inv(X)%the conjugate transpose is also the inverse
            Z=ctranspose(X);
        end
        %A method to calculate the transpose
        function [Z] = transpose(X)
            if isa(X,'mmp.x.sparse')
                Z=mmp.x.sparse();
            else%must be mmp.n.sparse
                Z=mmp.n.sparse();
            end
            Z.Reg  = X.Reg';%transpose finite non units
            Z.Unitp= X.Unitp';%transpose unit pattern
            Z.Topp = X.Topp';%transpose top pattern
        end
        %A method to calculate merely the transpose of the ctranspose
        function [Z] = uminus(X)
            if isa(X,'mmp.x.sparse')
                Z=mmp.n.sparse();
            else%must be mmp.n.sparse
                Z=mmp.x.sparse();
            end
            %Z.Xpsp=~X.Xpsp;%Flip convention
            Z.Reg=-X.Reg;%invert finite non units.
            %!!! rest of fields remain the same!
            Z.Unitp=X.Unitp;
            Z.Topp =X.Topp;
        end
        % B) OBSERVERS
        %a method to obtain the size of a xnp-sparse matrix.
        %This is a charm from the manual. See help varargout
        function [s,varargout]=size(obj)
            switch nargout%at least one              
                case {0,1}%just return
                    s=size(obj.Reg);
                    varargout={};
                case 2
                    [s varargout{1}]=size(obj.Reg);
%                     varargout(1)={s(2)};%no. cols
%                     s=s(1);%no. rows
                otherwise
                    error(nargoutchk(1,2,nargout));
            end
        end
        %Indexed reference primitive for all subclasses
        function B = subsref(A,S)
            switch S(1).type
                % Use the built-in subsref for dot notation
                case '.'
                    B = builtin('subsref',A,S);
                case '()'%select with an index OK
                    B=mmp.x.sparse();
                    B.Xpsp=isa(A,'mmp.n.sparse');
                    if numel(A) > 1
                        error('p:sparse:subsref',...
                            'Object must be scalar')
                    end
                    B.Reg=A.Reg(S(1).subs{:});
                    B.Topp=A.Topp(S(1).subs{:});
                    B.Unitp=A.Unitp(S(1).subs{:});
                    %call this primitive to interpret further levels of
                    %address
                    if length(S) > 1
                        B=subsref(B,S(2:end));
                    end
                % No support for indexing using '{}'
                case '{}'%TODO allow only one level of indirection!!
                    %transform to parenthesized selection
                    %newS=substruct('()',S(1).subs(:),S(2:end));
                    %B=full(subsref(A,newS));
%                    S(1).type='()';B=full(subsref(A,S));
                    error('p:sparse:subsref',...
                        'Not a supported subscripted reference')
            end
        end
        %A method to compare for equality elementwise two mmp.sparse matrices.
        ts = eq(X,Y)
%         %A method to get the status
%         [zero,one,top] = get_const(X)
        %A method to compare for inequality, two mmp.sparse matrices.
        ts = ne(X,Y)
        %A method to transform into a double full matrix
        X = full(S)
    end
    %ABSTRACT methods to be defined in subclasses
    methods(Abstract)
%        [Z]=zeros(X,Y)%null matrix construction WRONG!
        [Z] = plus(X,Y)%matrix addition
        [Z] = mtimes(X,Y)%lower matrix multiply
%        [Z]=mtimesu(X,Y)%upper matrix multiply
        [Z] = double(X)%mmp.sparse to sparse double converter
        disp(X)
        [Z] = lrclosure(X)%lower reflexive closure
        [Z] = urclosure(X)%upper reflexive closure
    end
    methods (Abstract,Static)%some unary constructors as static
        [Z]=zeros(X,Y)
    end
end
