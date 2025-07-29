classdef Context < fca.Precontext
    properties
        I=logical([]);%Boolean Incidence
    end
    methods
        function K=Context(G, M, I, name)
            %K=Context(G, M, I, name);
            %Creates a mp context with the following fields:
            %
            %Physical context (initial uppercase letter in the field name):
            %K.G is a cell array of atts names. Accessed by K.G{i}
            %K.M is a cell array of atts names. Accessed by K.M{j}
            %K.I is the incidence matrix
            %K.Name is the name of the context (string)
            %
            %Virtual context (initial lowercase letter in the field name):
            %K.g is the number of present objects
            %K.m is the number of present attrs
            %K.iG is a list of indexes of clarified objects
            %K.iM is a list of indexes of clarified attrs
            %K.qG is the quotient set of clarified object indexes
            %K.qM is a quotient set on clarified attribute indexes
            %
            % K=Context(I), creates an mp context with objects
            % named by '1'.. and atributes named by 'a'... through to R's dimension,
            % with the name 'standard_gxm', where g and m are the rows and columns of R,
            % respectively.
            %
            % K=Context(I,name), same as above but with context name
            % 'name'.
            %Pretreatment
            %invocation
            if (nargin==0)%Support for Context()
                I=[];
                G=[];
                M=[];
                name='UNNAMED_0x0';
                g=0; m=0;
            elseif (nargin==1)||(nargin==2)
                if  ~islogical(G)
                    error('mmp:Context:Context','Wrong matrix argument');
                end
                I=G;
                [g m] = size(I);
                if nargin==1
                    name=sprintf('standard_%ix%i',g,m);
                elseif ischar(M),
                    name=M;
                else
                    error('mmp:Context:Context','Wrong name argument');
                end
                %Deal with attribute and object names
                %Names of objects by default
%                G=arrayfun(@(x)num2str(x,' %i'),1:g,'UniformOutput',false);
                G=arrayfun(@(x)num2str(x,' %0.5g'),1:g,'UniformOutput',false);
                %     K.G=cell(1,K.g);
                %     for i=K.iG
                %         K.G{i}=num2str(i);
                %     end
                %number of letters for the attribute list
                M=arrayfun(@(x)num2str(x,' %i'),1:m,'UniformOutput',false);
                %Names of atts by default
%                 if m <= 26
%                     M=arrayfun(@(x)num2str(x,' %i'),(double('a')-1)+(1:m),...
%                         'UniformOutput', false);
%                 else
%                     M=cell(1,m);
%                     for i=1:m
%                         if i<27
%                             M{i}=char(i+96);
%                         else
%                             modulo=mod(i,26);
%                             if modulo==0 || modulo==26; end
%                             M{i}=[M{i-26} M{modulo}];
%                         end
%                     end
%                 end
            elseif (nargin==4) || (nargin==3)
                %pass G and M to father constructor
                %Third argument is the incidence
                if  ~islogical(I)
                    error('mmp:Context:Context','Wrong matrix argument');
                end
                [g m]= size(I);
                %Deal with name
                if nargin==3
                    name=sprintf('UNNAMED_%ix%i',g,m);'';
                %else%nargin=4%Nothing tod, pass name to father
                %constructor
                end
            end
            K = K@fca.Precontext(G,M,name);%invokation, construction
            %Postconstruction
            %[g m] = size(I);
            if (K.g ~= g )
               error('mmp:Context:Context','Nonconformant number of objects');
            elseif (K.m ~= m)
               error('mmp:Context:Context','Nonconformant number of attributes');
            else
                K.I = I;
            end
        end%function Context
        function [I] = get_virtual_incidence(K)
            I = K.I(K.iG,K.iM);
        end
    end
    methods
        Kout = clarify(Kin)%an observer to clarify a context
        [a,b] = gamma_concept(K,objs)
        [a,b] = mu_concept(K,atts)
        [b] = intent(K,objs)
        [a] = extent(K,atts)
        []=mat2csv(K, outputfile)%an observer to write in csv form to secondary storage.
        [A,B,lobj,latt] = concepts(K)%returns concepts or intents in K
    end
end
