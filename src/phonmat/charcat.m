function z = charcat (varargin)

% CHARCAT works just like STRCAT, but doesn't suppress whitespace.
% z = charcat (a,b,c...)     [n string arguments, for any n > -1]
%
% strcat ('yo ', '  yo') produces 'yoyo'
% charcat('yo ', '  yo') produces 'yo   yo'

z = '';
for i = 1 : nargin
  for j = 1 : length (varargin{i})
    z (length(z)+1) = varargin{i}(j);
  end;
end;
