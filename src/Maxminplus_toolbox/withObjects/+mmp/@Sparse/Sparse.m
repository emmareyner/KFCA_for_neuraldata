classdef Sparse
    %A class to encode the differences between maxplus and minplus encoding
    %of SPARSE doubles
    properties
        Reg=sparse(0,0);%Whether maxplus or minplus encoded!
    end
    methods
        % A constructor method
        function D = Sparse(M)
            if nargin == 1
%             if nargin == 0
%                 D.Reg = sparse(0,0);%ultimate sparse matrix
%             else
                switch class(M)%%% Add here the classes you want added
                    % The transformation of full doubles into sparse
                    % matrices has to be carried out at the daughters!
                    case 'double'
                        [m,n]=size(M);
                        D.Reg = sparse(m,n);
                    case {'mmp.x.Sparse','mmp.n.Sparse'}
                        D.Reg = M.Reg;
                    otherwise
                        error('mmp:Sparse','Wrong input argument: %s',class(M));
                end%switch
            end%if nargin
%             %property set methods
%             function obj = set.Reg(obj,M)
%                 obj.Reg = M;
%             end
        end
        %Indexed reference primitive for all subclasses: double logical
        %indexing is allowed!!
        %This must be subclassed in all daughter classes to work properly.
        function B = subsref(A,S)
            switch S(1).type
                % Use the built-in subsref for dot notation, to access Reg
                % contents.
                case '.'
                    switch S(1).subs
                        case 'Reg'
                            B = A.Reg;%This is the builtin subsref
                            %B = builtin('subsref',A,S);
                        otherwise
                            error('mmp:Sparse:subsref',...
                            'unknown field %s', S(1).subs)
                    end
                % No support for indexing using '{}'
                case '()'%TODO allow only one level of indirection!!
                    error('mmp:Sparse:subsref',...
                        '() cannot be supported at this abstract level')
                case '{}'%TODO allow only one level of indirection!!
                    error('mmp:Sparse:subsref',...
                        '%s Not a supported subscripted indexing',S(1).type)
            end
        end
        
        %Function subsasgn tries to enforce the illusion that Sparse is
        %just a matrix, but the object creation behind the matrix has to
        % be called from daugter classes
        % - DO NOT ALLOW access to .Reg out of the class
        % - allow asignment from 'double' and this class.
        % - DO NOT ALLOW cell indexing
%         function obj = subsasgn(obj,s,val)
% %              if numel(val) > 1
% %                  error('mmp:Sparse:subsasgn',...
% %                      'Object must be scalar');
% %              end
%             switch class(val)
%                 case 'double'%allowed if sparse (check out daughter's encoding!)
%                     if ~issparse(val)
%                         error('mmp:Sparse:subsasgn',...
%                             'Non-sparse direct assignment detected!')
%                     end
%                 case 'mmp.Sparse'%allowed, op on data
%                     val = val.Reg;
%                 otherwise
%                     error('mmp:Sparse:subsasgn',...
%                         'Object must be double or mm.Sparse')
%             end           
%             switch s(1).type
%                 case '()'%allow simple and double indexing
%                     obj = subsasgn(obj.Reg,s,val);%returns a sparse double!
% %                     idx = S(1).subs;%this is the index
% %                     switch length(idx)
% %                         case 1%linear indexing
% %                             obj = subsasgn(obj.Reg,s,val);
% %                         case 2%structured indexing: allow both numbers and boolean masks
% %                     end
%                 otherwise
%                     error('mmp:Sparse:subsasgn',...
%                         '%s Not a supported subscripted reference', s(1).type)
%             end
%         end
    end
%     %%Methods for accessing properties
%     methods
%         function M = get.Reg(A)
%             M = A.Reg;
%         end
%     end
    %The following methods entail a change of encoding for the classes
    %or need information about the encoding
    methods (Abstract)%methods for memory layouts
        Z = transpose(D)%transpose matrix
        Z = uminus(D)%negates, which is impossible in maxplus
        Z = inv(D)%Find multiplicative inverses
%        M = full(D)%method to obtain full from sparse
        M = double(D)%Transform into full double encoding, same as 'full' above
%          function d = double(D)
%         %A method to cast Sparses into doubles
%             warning('mmp:Sparse:double','CAVEAT:  you are losing information about the encoding! of mmp.Sparse matrix!!');
%             d = D.Reg;
%         end
    end
    methods (Sealed=true)%Methods for operations
        % The operation of (multiplicative) inversion
        %         function Z = ctranspose(X)
        %             %A method to obtain maxplus or minplus conjugate
        %             switch(class(X))
        %                 case 'mmp.l.Sparse'%from maxplus to minplus encoding
        %                         Z = mmp.u.Sparse(mmp_ctranspose(X.Reg));
        %                 case 'mmp.u.Sparse'%from minplus to maxplus encoding
        %                         Z = mmp.l.Sparse(mmp_ctranspose(X.Reg));
        %                 otherwise
        %                     error('mmp:Sparse:ctranspose','Unknown subtype for parameter X');
        %             end
        %         end
        %         function Y = inv(X)
        %             Y.Reg = -X.Reg.';
        %         end
%         function Y = transpose(X)%This functions keeps the subclasses mmp.l.Sparse and mmp.u.Sparse
%             Y = Y@mmp.Sparse();
%             Y.Reg = X.Reg.';
%         end
        %Cunninghame-green conjugate
        % This is the same as inv(D)
        function Z = cgconj(D)
            Z = inv(D);
        end
        %         function Y = ctranspose(X)%This redefines " ' " for mmp.doubles
        %             X.Reg = -X.Reg.'
        %         end
        function b = issparse(S)
            b = true;
        end
        function b = isnumeric(S)
            % mmp.Sparse classes and their daughters are numeric entities.
            b = true;
        end
        function [zr,zc]=findzeros(A)
            % Finds the zero cols and rows of a matrix in mmp.Sparse form            
            %
            % FVA: 3/04/2011            
            [zr,zc]=findzeros(A.Reg);
        end
    end
    methods (Sealed = true)
%         % Some operations needed by matlab
%         function b = issparse(D)
%             b = issparse(D.Reg);
%         end
        % B) OBSERVERS
        %a method to obtain the size of a double matrix.
        %This is a charm from the manual. See help varargout
        % It has problems when specifying a size...
        function [s,varargout]=size(varargin)
            nvarargin = size(varargin,2);
            if (nvarargin <= 2)%...and positive!
                    obj = varargin{1};
                    switch nargout%at least one output
                        case {0,1}%just return the requested
                            if nvarargin == 2%one dimension specified
                                s = size(obj.Reg,varargin{2});
                            else
                                s=size(obj.Reg);%return as pair
                            end
                            varargout={};
                        case 2
                            [s varargout{1}]=size(obj.Reg);
                            %                     varargout(1)={s(2)};%no. cols
                            %                     s=s(1);%no. rows
                        otherwise
                            error(nargoutchk(1,2,nargout))
                    end
            else
                    error(narginchk(1,2,nvarargin))
            end
        end
   end
    % THE MOTHER CLASS SHOULDN'T DEFINE OPERATORS THAT HAVE LOWER AND UPPER
    % VERSIONS!!!
%     %The presence of these methods prevents the constructions by mere
%     %subsreffing, we'll have to comment them out.
    methods (Abstract)%abstract methods for operations
        B = eq(X,Y)%equality predicate for matrices
        B = ge(X,Y)%greater than or equal predicate for matrices
%         Z = rclosure(X)% reflexive closure
%         Z = trclosure(X)% transitive, reflexive closure
%         Z = tclosure(X)%  transitive closure
%         Z = plus(X,Y)% matrix addition
%         Z = mtimes(X,Y)% matrix multiplication
%         Z = mrdivide(X,Y)%right matrix divide
%         Z = mldivide(X,Y)%left matrix divide
        Yxn = flipflop(Ynx)%flips the encoding from one to the other
        C =horzcat(varargin)%horizontal concatenation
        C = vertcat(varargin)%vertical concatenation
    end
    methods (Abstract,Static)%some unary constructors as static
        [Z]=zeros(X,Y)
        [Z]=eye(X,Y)
        [Y] = diag(vec,offset)
        %TODO? Define a "flip_encoding" primitive here?
    end
end
