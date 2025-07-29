classdef Boolean < logical
    methods
        function obj = Boolean(M)
            nargin
            if nargin == 0%0-argument constructor
                %M = [];
                M = logical([]);
            else%one argument constructor
                class(M)
                switch class(M)
                    case 'logical'%Do nothing!
                    case 'double'
%                         M = logical(M);%same behaviour as default
                    otherwise
                        error('my:Boolean','cannot convert input parameter type');
                end
            end
%            obj = obj@logical(M);
%            obj = logical(M);%doesn't seem to comply with constructor rules!
            obj = obj@logical(M);%doesn't seem to comply with constructor rules!
        end
        function L = logical(B)
            L = cast(B,'logical');
        end
%         %NUmel seems NOT to be working properly: let's redefine it.
%         % - this solution doesn't seem to work because the argument passign
%         % functions fail to pass the redefined numel one level below.
%         function n = numel(X)
%             n = prod(size(X));%But numel is not available for my.boolean!!!
%         end
    end
    %%Define observers for special operations
    methods
        % function Z=mtimes(X,Y), works out the boolean matrix product of X
        % and Y, where numbers are multiplied with & and added  with |
        Z=mtimes(X,Y)
        % mpower  algebraic power of logical matrix or scalar
        Y=mpower(X,n)
   end
%     methods (Static)
%          Z=mtimes_raw(X,Y)
%     end
    %Define the closures for boolean matrices
    methods
        %reflexive closure for a logical matrix
        clos = rclosure(r)
        % Finds the transitive closure of a logical matrix, aka A+.
        C=tclosure(A,params)
        C=logarithmic_tclosure(A)
        C=iterative_tclosure(A)
        C=mpower_tclosure(A)
   end
end
