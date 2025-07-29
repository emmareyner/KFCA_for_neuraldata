classdef Sparse < mmp.Sparse
    %minplus encoding of sparse matrices
    methods
        function Z = Sparse(M)%unary constructor for mmp.double
            Z=Z@mmp.Sparse();
            % INCLUDE HERE ALL POSSIBLE TYPES OF M
            %only full Ms are transformed. Otherwise, the encoding is
            %respected.
            if nargin > 0
                if issparse(M)
                    Z.Reg = M;%This allows building mmp.n.Sparses directly from negated mmp.x.Sparses.
                else
                    Z.Reg = mmp_n_sparse(M);
                end
            end
        end
        % CAVEAT: WITHIN THIS @Sparse directory, SUBSCRIPTED REFERENCE TO
        % the contents of a mmp.Sparse object must be done using a
        % named-field structure or a structure itself. See lmtimes.
%         function subs = subsref(A,S)
%             subs = builtin('subsref',A,S);
%         end
        function B = subsref(A,S)
            if numel(A) > 1
                error('mmp:n:Sparse:subsref','Object must be scalar')
            end
            switch S(1).type
                % Use the built-in subsref for dot notation, to access Reg
                % contents.
                case '()'%select with an index OK.
                    %admits logical and numerical indexing
                    idx =  S(1).subs;
                    for l=1:length(idx);%check on all dimensions
                        if islogical(idx{l}), idx{l}=find(idx{l}); end
                    end
                    B = mmp.n.Sparse();
                    B.Reg = sparse(A.Reg(idx{:}));
                    %B.Reg = A.Reg(idx{:});
                    if length(S) > 1
                        %B=builtin('subsref',B,S(2:end));%This returns a matrix
                        B=subsref(B,S(2:end));
                    end
                    %B = mmp.x.Sparse(subsref@mmp.Sparse(A,S));
%                 case '.'%only accepts fields like 'Reg'
%                     switch S(1).subs
%                         case 'Reg'
%                             B = A.Reg;%This is the builtin subsref
%                             %This is in maxplus convention.
%                         otherwise
%                             error('mmp:x:Sparse:subsref',...
%                             'unknown field %s', S(1).subs)
%                     end
                %B = builtin('subsref',A,S);
                otherwise
                    B = subsref@mmp.Sparse(A,S);
            end
        end
        % The daughter subsasgn has to take care that the proper encoding
        % is respected...
        function obj = subsasgn(obj,s,val)
            %massage the value so that it becomes sparse in maxplus
            %convention
            switch class(val)
                case 'double'
                    if issparse(val)
                        error('mmp:n:Sparse:subsasgn',...
                            'Sparse direct assignment detected!')
                    else
                        val = mmp_n_sparse(val);
                    end
                case 'mmp.x.Sparse'
                    val = val.Reg;
                case 'mmp.n.Sparse'
                    val = mmp_n_sparse(double(val));
            end
            switch s(1).type
                case '()'%allow simple and double indexing
                    obj = mmp.n.Sparse(subsasgn(obj.Reg,s,val));%returns a sparse double!
                    %                     idx = S(1).subs;%this is the index
                    %                     switch length(idx)
                    %                         case 1%linear indexing
                    %                             obj = subsasgn(obj.Reg,s,val);
                    %                         case 2%structured indexing: allow both numbers and boolean masks
                    %                     end
                otherwise
                    error('mmp:n:Sparse:subsasgn',...
                        '%s Not a supported subscripted reference', s(1).type)
            end
        end
        function obj = horzcat(varargin)
            % A method to concatenate mmp.x.Sparse matrices horizontally
            nvarargin = size(varargin,2);
            switch nvarargin
                case 0;
                    obj=mmp.n.Sparse();
                case 1
                    obj = varargin{1};
                otherwise
                    obj=mmp.n.Sparse();
                    for i=1:nvarargin
                        switch class(varargin{i})
                            case 'mmp.n.Sparse'
                                varargin{i}=varargin{i}.Reg;
                            case 'mmp.x.Sparse'
                                varargin{i}=mmp_x_to_n(varargin{i});
                            case 'double'
                                if issparse(varargin{i})
                                    error('mmp:n:Sparse:horzcat','Cannot concat normal sparse matrices');
                                else
                                    varargin{i}=mmp_x_sparse(varargin{i});
                                end
                            otherwise
                                error('mmp:n:Sparse:horzcat','Unknown parameter type %s',class(varargin{i}));
                        end
                    end
                    obj.Reg = horzcat(varargin{:});
            end
        end
        function obj = vertcat(varargin)
            % A method to concatenate mmp.x.Sparse matrices horizontally
            nvarargin = size(varargin,2);
            switch nvarargin
                case 0;
                    obj=mmp.n.Sparse();
                case 1
                    obj = varargin{1};
                otherwise
                    obj=mmp.n.Sparse();
                    for i=1:nvarargin
                        switch class(varargin{i})
                            case 'mmp.n.Sparse'
                                varargin{i}=varargin{i}.Reg;
                            case 'mmp.x.Sparse'
                                varargin{i}=mmp_x_to_n(varargin{i});
                            case 'double'
                                if issparse(varargin{i})
                                    error('mmp:n:Sparse:vertcat','Cannot concat normal sparse matrices');
                                else
                                    varargin{i}=mmp_x_sparse(varargin{i});
                                end
                            otherwise
                                error('mmp:n:Sparse:vertcat','Unknown parameter type %s',class(varargin{i}));
                        end
                    end
                    obj.Reg = vertcat(varargin{:});
            end
        end
    end
   methods%to deal with storage classes
        function Y = double(X)
            %Create a maxminplus full matrix from a min-plus encoded sparse matrix.
            %   X = double(S) converts a sparse min-plus matrix to FULL
            %   form:   zeros are turned into Infinity terms
            Y = mmp_n_full(X.Reg);
        end
        function[Z]=flipflop(X)
            %transform 
            Z=mmp.x.Sparse(mmp_n_to_x(X.Reg));
        end
    end
    methods%Algebraic operations!
        function Z = transpose(D)
            Z = mmp.n.Sparse(D.Reg.');
        end
        function Z = uminus(D)%invert and change storage class
            Z = mmp.x.Sparse(-D.Reg);
        end
        function Z = inv(D)
            Z = mmp.x.Sparse(-D.Reg.');
        end
    end
    methods
%         %%%%%%%%%%%%%%%%% PREDICATES %%%%%%%%%%%%%%%%%
        b = eq(X,Y)%lower equality
        b = ge(X,Y)%lower greater or equal
%         b = ne(X,Y)%lower non-equality
%         %%%%%%%%%%%%%%%%% UNARY CLOSURES %%%%%%%%%%%%%
%         Z = rclosure(X)%lower reflexive closure
%         Z = trclosure(X)% lower transitive, reflexive closure
%         Z = tclosure(X)% lower transitive closure
%         %%%%%%%%%%%%%%%%% OPERATORS %%%%%%%%%%%%%%%%%%
        Z = plus(X,Y)%lower matrix addition
        Z = mtimes(X,Y)%lower matrix multiplication
%         Z = mrdivide(X,Y)%lower right matrix divide
%         Z = mldivide(X,Y)%lower left matrix divide
%         %upper matrix multiplication is missing
%         %the following might better be constructors of spectra
%         [subgraphs,orders,spectra] = spectra2(A)%for completely reducible matrices
%         %[spectrum] = ordered_subgraph_spectrum2(comps,order,cycles,A)%for reducible matrices
    end
    methods (Static)%some unary constructors as static
        [Z]=zeros(M,N)
        [Z]=eye(M,N)
        [Z] = diag(vec,offset)
    end
end
