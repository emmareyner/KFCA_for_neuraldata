function z = compare (X,y)

% Usage: z = compare (X,y)
% This does everything that == would do if X,y were numeric.
% With one exception. If y is a numeric nonscalar, and X is numeric, then X==y crashes if size(X)~=size(y). compare returns 0 in this case instead of crashing.
%
% Generally, it works as: y is a scalar and X is either a scalar or a Nx1 vector. 
%  If the former, z = 0 if X equals y. 
%  If the latter, z is a Nx1 vector with z(i) = compare(X(i),y)
% But there are subtleties:
%
%     if y is a non-char scalar, X can be a cell array or number array of class(y). 
%     if y is a character vector, X can either be one or a cell array (only, since ['aa' 'b' 'c']='aabc').
%     if y isnt a scalar, then there are two possibilities.
%       if length(y) == 0: If X is a scalar, then z=0. 
%	  Otherwise, if class(X) == class(y) & length(X) == 0, z=1 is returned. 
%         Otherwise, X is assumed to be a vector/array. If the class of elements of X is that of y, we can compare y with each element of X. 
%         Otherwise, we return a zero array the same size as X. 
%
%       if length(y) >= 1, class(y) should not be the same as class(elem(y,1)). 
%         This permits a checking of whether X a single element being compared to y or a array of such elements.
% X,y can only be made using the data types numeric, char and cell. No structs.
% 
% in case of bad input, [0 -1] is returned. This gives a check for an error (sum(z)<0), but otherwise is the same as returning 0 (not equal). 
% Note that "if [0 -1], 10, else 20, end;" returns 20.
%
% If X = {'tcl','t'} and y = {'tcl'} z should be 0.
% If X = {{'tcl','t},{'tcl'},{'t'}} and y = {'tcl','t'}, z should be [1 0 0]
% If X = ['re' ar'] and y = 'rear', z = 1
% If X = [1 2 4 1 2 5 6] and y = '4' or {}, z = [0 0 0 0 0 0 0]. If y = 1, then z = [1 0 0 1 0 0 0].
% If X = [] or {} and y is the same, then z=1. Otherwise, z=0.
%
% There will be unpredictable behavior if both class(X) and class(elements of X) arent equal to class(y).

if nargin ~= 2
  error ('compare: two arguments required');
elseif length(X) == 0
  z = strcmp (class(X), class(y)) & ~length(y);
elseif isnumeric(y)
  if isnumeric(X)
    if length(y) == 1
      z = X==y;
    else
      z = size(X) == size(y) & ~length (find (X~=y));   % rem X isnt empty. If y isnt a scalar, then z must exactly equal y, i.e. 
                                                        % you should not be able to find a place where X doesnt equal y.
    end;
  elseif iscell(X)
    tmpsize = size(X); Xcol = X(:);
    z = []; for i=1:length(Xcol), z(i) = compare(Xcol{i},y); end;
    z = reshape (z,tmpsize);
  end;
elseif ischar(y)
  if ischar(X)
    z = length(X) == length(y);
    if z, z = ~length (find (X~=y)); end;
  elseif iscell(X)
    tmpsize = size(X); Xcol = X(:); z = [];
    for i=1:length(Xcol), z(i) = compare(Xcol{i},y); end;
    z = reshape (z,tmpsize);
  end;
elseif iscell(y)
  if ~iscell(X)                       % rem length(X) > 0
    z = 0
  elseif ~length(y)                   % y = {}. X is nonempty, but might be a cell of (possibly empty) cells.
    Xcol = X(:);
    z = []; for i = 1:length(Xcol), z(i) = compare(Xcol{i},y); end;      % so if X = {{},{'a'},{}} then z = [1 0 1]
    z = reshape (z,size(X));
  else                                % y is a nonempty cell array
    typeofy = class(y{1});
    if strcmp (typeofy, class(y))     % y had better not be a cell of cells. May be worth modifying so it can be, e.g. {{}}. Not for now though.
      z = 0;                          
    else                              % y is either a cell of numberics or a cell of chars.
      tmpsize = size(X); Xcol = X(:);
      if strcmp (class(X),class(y))                     % X and y are both nonempty cell arrays...
       if strcmp (class(Xcol{1}),class(y{1}))           %  of the same type. e.g. X={'tcl','t'}, y={'t'}
         z = prod(size(X) == size(y) > 0);
	 if z,
           ycol = y(:);
  	   for i=1:length(Xcol), if ~compare(elem(Xcol,i),elem(ycol,i)), z=0; break; end; end;
         end;
       else                                             % X{1} is not the same type as y{1}. You have to assume X{1} is a array of type y{1}. If not, it's a SEP.
         z = []; tmpsize = size(X); Xcol = X(:);
         for i = 1 : length (Xcol), z(i) = compare (Xcol{i}, y); end;
	 z = reshape (z, size(X));
       end;
      end;
    end;
  end;
else               % y isnt cell, char or num. X is nonempty.
  if iscell(X)
    z = zeros(size(X)); 
  else
    z = 0;
  end;
end;


