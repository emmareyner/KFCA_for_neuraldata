classdef Context < fca.mmp.Precontext
    %Class of contexts represented with matrices of doubles
    %
    %K=fca.mmp.Context(G, M, R, name);
    %K=fca.mmp.Context(G, M, R);
    %Creates an mmp context with the following fields:
    %
    %Physical context (initial uppercase letter in the field name):
    %K.G is a cell array of atts names. Accessed by K.G{i}
    %K.M is a cell array of atts names. Accessed by K.M{j}
    %K.R is the relevance matrix
    %K.Name is the name of the context (string)
    %
    %Virtual context (initial lowercase letter in the field name):
    %K.g is the number of present objects
    %K.m is the number of present attrs
    %K.iG is a list of indexes of irreducible objects
    %K.iM is a list of indexes of irreducible attrs
    %
    % K=Context(R), creates an mp context with objects
    % named by '1'.. and atributes named by 'a'... through to R's dimension,
    % with the name 'standard_gxm', where g and m are the rows and columns of R,
    % respectively.
    % NOTE: (R) can be a logical matrix to inject a standard context into a
    % mmp.Context
    %
    % K=mpfca_create_context(R,name), same as above but with context name
    % 'name'.
    %
    % K=fca.mmp.Context(), empty constructor.
     properties
%         G=[];%cell array of object names. 
%         M=[];%cell array of attributes names.
%         iG=[];%index on irreducible objects
%         iM=[];%index on irreducible attributes
%         g=0;%Number of objects
%         m=0;%Number of attributes
%         clarified=false;%On for clarified contexts
%         qM=[];%quotient class for attributes
%         qG=[];%quotient class for objects
        R=double([]);%Incidence, in lower maxminplus format          
        R_phi0=double([]);%Number of virtual attributes
    end
    methods
        function K=Context(G,M, R, name)
           switch(nargin)
                case 0
                    G=[];M=[];R=[];
                    g=0;m=0;
                case {1,2}
                    if  (isnumeric(G))
                        R=G;
                    elseif islogical(G)
                        R=toMaxplus(G);
                    else
                        error('fca:mmp:Context:Context','Wrong matrix argument');
                    end
                    [g m]= size(R);
                    if nargin==1
                        name=sprintf('standard_%ix%i',g,m);
                    elseif ischar(M),
                        name=M;
                    else
                        error('fca:mmp:Context:Context','Wrong name argument');
                    end
                    %Deal with missing attribute and object names
                    %Names of objects by default
                    G=arrayfun(@(x)num2str(x,' %i'),1:g,'UniformOutput',false);
                    %     K.G=cell(1,K.g);
                    %     for i=K.iG
                    %         K.G{i}=num2str(i);
                    %     end
                    %Names of atts by default
                    if m <= 26
                        M=cellfun(@char,num2cell(double('a')-1+(1:m)),'UniformOutput', false);
                        %                         M=arrayfun(@(x)num2str(x,' %i'),(double('a')-1)+(1:m),...
                        %                             'UniformOutput', false);
                    else
                        M=cell(1,m);
                        for i=1:m
                            if i<27
                                M{i}=char(i+96);
                            else
                                modulo=mod(i,26);
                                if modulo==0, modulo=26; end
                                M{i}=[M{i-26} M{modulo}];
                            end
                        end
                    end
                case {3,4}
                    %            elseif (nargin==4) || (nargin==3)
                    %Third argument is the incidence
                    if (isnumeric(R))
                        %Do nothing
                    elseif islogical(R)
                        R=toMaxplus(R);
                    else
                        error('fca:mmp:Context:Context','Wrong matrix argument');
                    end
                    [g m]= size(R);
                    %                 % Deal with objects
                    %                 if (g ~= length(G))
                    %                     error('mmp:fca:Context:Context',...
                    %                         'Number of objects mismatch');
                    %                 end
                    %                 %Deal with attributes
                    %                 if (m ~= length(M))
                    %                     error('mmp:fca:Context:Context',...
                    %                         'Number of attributes mismatch');
                    %                 end
                    %Deal with name
                    if nargin==3
                        name=sprintf('UNNAMED_%ix%i',g,m);'';
                    elseif ~ischar(name)%nargin==4, but no real name
                        error('fca:mmp:Context:Context','The name should be a char array');
                    end
                    %check that labels are OK wrt matrix dimensions
                    if (length(G) ~= g )
                        error('fca:mmp:Context:Context','Nonconformant number of objects %i vs. %i',length(G),g);
                    elseif (length(M) ~= m)
                        error('fca:mmp:Context:Context','Nonconformant number of attributes %i vs. %i',length(M),m);
                    end
                otherwise
                    error(nargchk(1,4,nargin));
            end%Switch(nargin)
            
            K = K@fca.mmp.Precontext(G,M,name);%invokation, construction
            
            %Postconstruction: Store new parameters
            K.R = R;
        end
        function [R] = get_virtual_incidence(K)
            R = K.R(K.iG,K.iM);
        end
    end
    methods
        [a,b] = gamma_concept(K,phi,objs)
        [a,b] = mu_concept(K,phi,atts)
        [b] = intent(K,phi,objs)
        [a] = extent(K,phi,atts)
        Ks = structural(K,phi)%an observer to obtain a boolean context from K and a degree of existence
        Ks = structuralFast(K,phi)%an observer to obtain a boolean context from K and a degree of existence
        Kout = explore_in_phi(Kin, outdirbase, step)%an observer to sweep on the degrees of existence
        Kout = explore_in_phiv2(Kin, outdirbase,inv,h,guiOpts)%an observer to sweep on the degrees of existence
        thisK=loadConceptFromCSV(Kout,phi,path)
	[counti, range,strange] = interpolate_counts(K,npoints,iplate)%Interpolate counts with sigmoid functions
        h = imagesc(pm, description)%Plot a heatmap of kontext annotated in matrix
    end
end
