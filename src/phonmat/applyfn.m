function result = applyfn (fn_handle, varargin)
% APPLYFN applies a given function to given vectors of arguments
%
%	result = applyfn (fn_handle, varargin)
%	fn_handle = @f, where f takes a fixed number N of arguments
%	  and produces a single output of type T.
%	varargin consists of N vectors (numeric or cell) with argument types 
%	corresponding to those taken by f.
%	If T is numeric, x is a numeric vector of results, otherwise it
%	  is a cell vector of results
%
%	Example: f is the function f(x,y,n) that takes strings x,y and number n
%	  and returns 1 iff x = y and length(x) = n and 0 otherwise.
%	  Suppose X = {'blah','yuck','pooey'}
%		  Y = {'bleah','yuck','pooey'}
%		  Z = [4 5 5]   (or {4,5,5})
%	  then applyfn (@f, X, Y, Z) returns [0 1 0].
%
%	No error checking in this function.
%	Currently works only if f takes at most 4 arguments.

N = length(varargin);          % number of argument f takes

if N > 4, 
   error ('sorry, this function cannot take more than 4 arguments at the moment.'); 
end;


A = length(varargin{1});	% number of times f will be applied

% find type of result
typeisnumeric = 1;

for a = 1 : A
  switch N
  case 1
    result{a} = feval (fn_handle, elem(varargin{1},a) );
  case 2
    result{a} = feval (fn_handle, elem(varargin{1},a), elem(varargin{2},a) );
  case 3
    result{a} = feval (fn_handle, elem(varargin{1},a), elem(varargin{2},a), elem(varargin{3},a) );
  case 3
    result{a} = feval (fn_handle, elem(varargin{1},a), elem(varargin{2},a), elem(varargin{3},a), elem(varargin{4},a) );
  end;
  typeisnumeric = typeisnumeric & isnumeric (result{a});
end;

tmp = [];
if typeisnumeric
  for a = 1 : A, 
    tmp(a) = result{a}; 
  end;
  result = tmp;
end;


