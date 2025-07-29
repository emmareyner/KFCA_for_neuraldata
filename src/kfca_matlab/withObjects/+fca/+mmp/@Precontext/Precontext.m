classdef Precontext < fca.Precontext
    % A class to factor commonalities between mmp context with different
    % relation representations.
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
        explored=false;
        minplus = false;%Whether the exploration was in minplus order
        Ks={};%Cell array of structural contexts
        nc=[];%Array of concept counts(coindexed with Ks)
        Phis=[]%Array of thresholds(coindexed with Ks) 
%        R=double([]);%Incidence, in lower maxminplus format
    end
    methods
        function K=Precontext(G,M, name)
            %K=Precontext(G, M, name);
            %Creates an mmp precontext with the following fields:
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
            % K=Precontext(name), creates an mp precontext with no objects
            % or attributes
            switch(nargin)
                case 0%totally null constructor: no info
                    G=[];M=[];
                    g=0;m=0;
                    name='EMPTY_0x0';
                case 1%%IT is the name
                    if  ischar(G)
                        name=G;
                        G=[];M=[];
                        g=0;m=0;
                    else
                        error('mmp:fca:Precontext:Precontext','Wrong name argument');
                    end
                    name = sprintf('%s_%i_%i',name,g,m);
                case {2,3}
                    g=length(G);
                    m=length(M);
                    if nargin == 2, name='UNNAMED'; end
                    name= sprintf('%s_%ix%i',name,g,m); 
            end
                
% %                 R=mmp.l.Double(G);
% %                [g m]= size(R);
% %                 if nargin==1
% %                    name=sprintf('standard_%ix%i',g,m);
% %                 elseif ischar(M),
% %                     name=M;
% %                 else
% %                     error('mmp:fca:Context:Context','Wrong name argument');
% %                 end
%                 %Deal with attribute and object names
%                 %Names of objects by default
%                 G=arrayfun(@(x)num2str(x,' %i'),1:g,'UniformOutput',false);
%                 %     K.G=cell(1,K.g);
%                 %     for i=K.iG
%                 %         K.G{i}=num2str(i);
%                 %     end
%                 %Names of atts by default
%                 if m <= 26
%                     M=arrayfun(@(x)num2str(x,' %i'),(double('a')-1)+(1:m),...
%                         'UniformOutput', false);
%                 else
%                      M=cell(1,m);
%                     for i=1:m
%                         if i<27
%                             M{i}=char(i+96);
%                         else
%                             modulo=mod(i,26);
%                             if modulo==0, modulo=26; end
%                             M{i}=[M{i-26} M{modulo}];
%                         end
%                     end
%                 end
%             elseif (nargin==4) || (nargin==3)
%                 %Third argument is the incidence
%                 if  ~(isnumeric(R))
%                     error('mmp:fca:Context:Context','Wrong matrix argument');
%                 end
%                 [g m]= size(R);
% %                 % Deal with objects
% %                 if (g ~= length(G))
% %                     error('mmp:fca:Context:Context',...
% %                         'Number of objects mismatch');
% %                 end
% %                 %Deal with attributes
% %                 if (m ~= length(M))
% %                     error('mmp:fca:Context:Context',...
% %                         'Number of attributes mismatch');
% %                 end
%                 %Deal with name
%                 if nargin==3
%                    name=sprintf('UNNAMED_%ix%i',g,m);'';
%                 elseif ~ischar(name)%nargin==4:
%                      error('mmp:fca:Context:Context',...
%                             'The name should be a char array');
%                 end
%             end
             K = K@fca.Precontext(G,M,name);%invokation, construction
%             %Postconstruction
%             if (K.g ~= g )
%                error('mmp:Context:Context','Nonconformant number of objects');
%             elseif (K.m ~= m)
%                error('mmp:Context:Context','Nonconformant number of attributes');
%             else
%                 K.R = mmp.l.Double(R);
%             end
% 
        end
     end
    methods (Abstract)
        [R] = get_virtual_incidence(K)
%             R = K.R(K.iG,K.iM);
%         end
        [a,b] = gamma_concept(K,phi,objs)
        [a,b] = mu_concept(K,phi,atts)
        [b] = intent(K,phi,objs)
        [a] = extent(K,phi,atts)
        Ks = structural(K,phi)%an observer to obtain a boolean context from K and a degree of existence
        Kout = explore_in_phi(Kin, outdirbase, step)%an observer to sweep on the degrees of existence
        [counti, range,strange] = interpolate_counts(K,npoints,iplate)%Interpolate counts with sigmoid functions
        h = imagesc(pm, description)%Plot a heatmap of kontext annotated in matrix
    end
end
