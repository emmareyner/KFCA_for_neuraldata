classdef sparse < mmp.sparse%inherits from xxplus sparse class
    % maxminplus toolbox sparse matrices
    methods%public,
        %Maybe this should only be done on matrices, objs.
        function obj = sparse(X,Y)
            error(nargchk(0,2,nargin));
            %pre-construction
            switch nargin
                case 0
                    args={};
                case 1
                    args{1} = X;
                case 2
                    args{1}=X;args{2}=Y;
            end
            %construction);
            obj=obj@mmp.sparse(args);%Unary constructor on parent!
            obj.Xpsp=false;%mark as minplus encoded
            %post-construction
            if nargin == 1
                if isa(X,'double')%a matrix of doubles
                    [Sregp,Sunitp,Stopp]=mmp.n.patterns(X);
                    obj.Unitp(Sunitp)=true;
                    obj.Topp(Stopp)=true;
                    obj.Reg(find(Sregp))=X(Sregp);
                elseif isa(X,'mmp.x.sparse')
                    obj.Topp=~(logical(X.Reg)|X.Unitp|X.Topp);%switch tops
                elseif isa(X,'mmp.n.sparse')
                    obj.Topp=X.Topp;
                end
            end 
        end
        function [Z]=double(X)%converter to SPARSE DOUBLE with MAXPLUS CONVENTION
            Z=X.Reg;
            Z(X.Topp)=-Inf;
            Z(X.Unitp)=-eps;
        end
        function disp(X)
            %warning('mmp:n:sparse','disp');
            fprintf('mmp.n.sparse\n');
            disp(double(X));
        end
    end
    methods%(Abstract)
        [Z]=plus(X,Y)%upper matrix addition
        [Z]=plusl(X,Y)%lower matrix addition
        [Z]=mtimes(X,Y)%upper matrix multiply
        [Z]=mtimesl(X,Y)%lower matrix multiply
        [Z]=lrclosure(X)%lower closure
        [Z]=urclosure(X)%upper closure
    end
    methods (Static)%some unary constructors as static
        [Z]=zeros(X,Y)
        [Z]=eye(X,Y)
    end
end