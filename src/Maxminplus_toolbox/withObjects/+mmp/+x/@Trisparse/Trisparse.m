classdef sparse < mmp.sparse%inherits from xxplus sparse class
    % maxminplus toolbox sparse matrices
    methods%public
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
            obj.Xpsp=true;%mark as maxplus encoded
            %post-construction: only when supplying one argument
            if nargin == 1
                if isa(X,'double')%a matrix of doubles, full or sparse
                    [Sregp,Sunitp,Stopp]=mmp.x.patterns(X);
                    obj.Unitp(Sunitp)=true;
                    obj.Topp(Stopp)=true;
                    obj.Reg(find(Sregp))=X(Sregp);
                elseif isa(X,'mmp.n.sparse')%already copied in father constructor
                    obj.Topp=~(logical(X.Reg)|X.Unitp|X.Topp);%switch tops
                elseif isa(X,'mmp.x.sparse')%just a copy operation
                    obj.Topp=X.Topp;
                end%other cases should break
            end
        end%function obj = sparse
        function [Z]=double(X)%converter to SPARSE DOUBLE with MAXPLUS CONVENTION
            Z=X.Reg;
            Z(X.Topp)=Inf;
            Z(X.Unitp)=eps;
        end
        function disp(X)
            %warning('mmp:n:sparse','disp');
            fprintf('mmp.x.sparse\n');
            disp(double(X));
        end
     end%methods
    methods%(Abstract)
        [Z]=plus(X,Y)%lower matrix addition
        [Z]=plusu(X,Y)%upper matrix addition
        [Z]=mtimes(X,Y)%lower matrix multiply
        [Z]=mtimesu(X,Y)%upper matrix multiply
        [Z]=lrclosure(X)%lower closure
        [Z]=urclosure(X)%upper closure
    end
    methods (Static)%some unary constructors as static
        [Z]=zeros(X,Y)
        [Z]=eye(X,Y)
    end
end