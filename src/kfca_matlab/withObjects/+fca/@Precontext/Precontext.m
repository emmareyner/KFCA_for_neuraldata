classdef Precontext% Objects modelling commonalities in kontexts
    properties
        G={};%cell array of object names. 
        M={};%cell array of attributes names
        Name='UNNAMED_0x0';
        iG=[];%column index on irreducible objects, might be logical
        iM=[];%column index on irreducible attributes, might be logical
        qM=[];%quotient class for attributes
        qG=[];%quotient class for objects
    end
    properties (SetAccess = private)
        %The following should only be updated by the constuction of the
        %irreducible object indices, i.e. the assignments K.iM = XX, K.iG =
        %XX
        g=0;%Number of virtual objects
        m=0;%Number of virtual attributes
    end
    properties (SetAccess = protected)%only clarify should do it
        clarified=false;%On for clarified contexts
    end
    methods
        function K=Precontext(G, M, name)
            %K=Precontext(G, M, name);
            %Creates a formal pre-context with the following fields:
            %
            %Physical context (initial uppercase letter in the field name):
            %K.G is a cell array of atts names. Accessed by K.G{i}
            %K.M is a cell array of atts names. Accessed by K.M{j}
            %K.Name is the name of the context (string)
            %
            %Virtual context (initial lowercase letter in the field name):
            %K.g is the number of present objects
            %K.m is the number of present attrs
            %K.iG is a list of indexes of irreducible objects
            %K.iM is a list of indexes of irreducible attrs
            %
            % K=mpfca_create_context(R), creates an mp context with objects
            % named by '1'.. and atributes named by 'a'... through to R's dimension,
            % with the name 'standard_gxm', where g and m are the rows and columns of R,
            % respectively.
            %
            % K=mpfca_create_context(R,name), same as above but with context name
            % 'name'.
            if nargin == 0%support for Precontext(),
                K.g=0;K.m=0;%only the first needed, but..
            elseif nargin == 1%support for Precontext(name)
                if ischar(G)
                    K.Name=G;
                else
                    error('fca:Precontext:Precontext','Wrong name argument');
                end
            elseif nargin < 4%support for Precontext(G,M), Precontext(G,M,name)
                if iscell(G)
                    K.G=G;
%                    K.g=length(G);
                    K.iG=true(length(G),1);%allocate virtual rows
                    K.qG =1:K.g;%allocate virtual classes of rows aka objects
                else
                    error('fca:Precontext:Precontext','Wrong list of objects');
                end
                if iscell(M)
                    K.M=M;
%                    K.m=length(M);
                    K.iM=true(length(M),1);%allocate virtual cols
                    K.qM =1:K.m;%allocate quotient classes of cols aka atts
                else
                    error('fca:Precontext:Precontext','Wrong list of attributes');
                end
                %Deal with name
                if nargin==2
                    K.Name=sprintf('UNNAMED_%ix%i',K.g,K.m);'';
                else%nargin==3: There should be no name for the context
                    if ischar(name)
                        K.Name=name;
                    else
                        error('fca:Precontext:Precontext',...
                            'The name should be a char array');
                    end
                end
            end
        end%function Precontext
        function [s,varargout]=size(K)
            % returns the size of the virtual context implied in the
            % Precontext. If you want to return the original size, use
            % realsize
            switch nargout%at least one              
                case {0,1}%just return
                    s=[K.g K.m] ;
                    varargout={};
                case 2
                    s=K.g;
                    varargout{1}=K.m;
                otherwise
                    error(nargoutchk(1,2,nargout))
            end
        end
        function [s,varargout]=realsize(K)
            % returns the real size of the original context used to build
            % the Precontext. If you want to return the virtual size, use
            % size(K)
            switch nargout%at least one              
                case {0,1}%just return
                    s=[length(K.G) length(K.M)] ;
                    varargout={};
                case 2
                    s=length(K.G);
                    varargout{1}=length(K.M);
%                     varargout(1)={s(2)};%no. cols
%                     s=s(1);%no. rows
                otherwise
                    error(nargoutchk(1,2,nargout))
            end
        end
    end
    %property access methods: NO 
    methods% (Sealed = true)
        function K = set.iM(K,iM)%set attribute index
            [len one] = size(iM);
            if (one == 1)%only on linear indices
                len2=length(K.iM);
                if islogical(iM)
                    if (K.m == 0) || (len == len2)
                        K.iM = sparse(iM);
                    else
                        error('fca:Precontext:set:iM','Too few values');
                    end
                else%if isnumeric(iM)
                    K.iM = logical(sparse(len2,1));
                    K.iM(iM) = true;
                end
                K.m = full(sum(K.iM));
            else
                error('fca:Precontext:set:iM','Wrong index: not a column');
            end
        end
        function K = set.iG(K,iG)%Set object index
             [len one] = size(iG);
            if (one == 1)
                len2=length(K.iG);
                if islogical(iG)
                    if (K.g==0) || (len == len2)
                        K.iG = sparse(iG);
                    else
                        error('fca:Precontext:set:iG','Too few values');
                    end
                else%if isnumeric(iG)
                    K.iG =logical(sparse(len2,1));
                    K.iG(iG)=true;
                end
                K.g = full(sum(K.iG));
            else
                error('fca:Precontext:set:iG','Wrong index');
            end
        end          
        function [n] = get.Name(K)%This must be a Get method
            n = K.Name;
        end
    end
    methods (Sealed=true)%non-redefinable by subclasses
        [vG,vM]=concat_labels(K)%returns concatenated quotient class labels
    end
    methods%redefinable, expandable by subclasses
        function Kout = clarify(K)%an observer to clarify a context
            % Change to a new name
            Kout = K;
            Kout.Name = [K.Name '_clarified'];
            %Declare context to be already clarified.
            Kout.clarified=true;
        end
    end
     %Make preconcepts abstract in that they need incidences
    methods (Abstract)
        [I] = get_virtual_incidence(K)
    end
end
