function set (pm, name, value, varargin)

% SET set some confmat object parameters. 
%
%  set (pm, name, value, [i, j])
%
%  where name can be 'mat', 'title', 'labels', 'hasdiag', 'symmetric', 
%  'default', 'phones', 'smallest', 'dp'. 
%  value should be of the correct type. 
%  If name is 'mat', values of i and j can supplied. They can be
%   characters or index numbers. If i,j are 1-char labels instead
%   of indices, they can be combined to give a single 2-char label. 
%  If name is set to 'labels' and some of the labels are not in pm already,
%   their values are set to NaN (not pm.default, unless that's NaN) to 
%   stress the point that they are not valid values.
%  If name is 'phones', that's the same as supplying 'labels' with 
%   the labels initialized by the phones THAT ARE ALREADY IN PM.

% NEED TO FIX THIS FUNCTION WITH MATLAB BOOK

  if ~ischar (name), error ('Parameter name must be char strings');  end
  name = lower (name);

  if strcmp (name, 'mat') | strcmp (name, 'matrix')
    N = private_isgoodmatrix (value) ;
    M = size (pm.mat, 1);
    if (N > -1) 
       if nargin == 3
          pm.mat = value;
          pm.dp = private_finddp (value, pm.smallest);
          if N ~= M
	     fprintf ('Note: replacing a %dx%d matrix with a %dx%d matrix',M,M,N,N);
          end;
       elseif nargin == 4 | nargin == 5
          if nargin == 4
            [a,b] = private_findindices (pm, varargin{1});
          elseif nargin == 5       
            [a,b] = private_findindices (pm, varargin{1}, varargin{2});
          end;
	  if a & b & isnumeric (value) & min (size (value)) == 1
%	    S = pm.mat;
%	    S(a,b) = value;
%	    pm.mat = S;
	    pm.mat(a,b) = value;
	    if pm.symmetric
  	      pm.mat(b,a) = value;
            end;
          else
            error ('bad arguments/values supplied');
          end;
       else
          error ('wrong number of arguments. Setting matrix can only be done entrywise\n');
       end;              


    else
       error (sprintf('Bad confusion matrix supplied - no change made to %s',inputname(1))); 
    end;
  elseif strcmp (name, 'title')
     if private_isgoodstring (value) > -1
	pm.title = value;
     else
        error (sprintf('Bad title supplied - no change made to %s',inputname(1)));
     end;
  elseif strcmp (name, 'labels')
     if isa (value, 'labels') 
        private_changelabels (pm, value);
     else
        error (sprintf ('Bad labels supplied - no change made to %s',inputname(1)));
     end;
  elseif strcmp (name, 'phones')
     if ischar (value)
        commonphones = findcommon (value, get (get(pm,'labels'),'phones'));
        private_changelabels (pm, labels(commonphones));
     else
        error (sprintf ('Bad phones supplied - no change made to %s',inputname(1)));
     end;
  elseif strcmp (name, 'hasdiag')
     if isnumeric (value) & min (size (value)) == 1
        pm.hasdiag = value ~= 0;     
     else
        error (sprintf ('Bad hasdiag supplied - should be single number - no change made to %s',inputname(1)));
     end;
  elseif strcmp (name, 'symmetric')
     if isnumeric (value) & min (size (value)) == 1
        pm.symmetric = value ~= 0;     
     else
        error (sprintf ('Bad symmetric supplied - should be single number - no change made to %s',inputname(1)));
     end;
  elseif strcmp (name, 'smallest')
     if isnumeric (value) & min (size (value)) == 1 & value >= 0
        pm.smallest = value;
     else
        error (sprintf ('Bad hasdiag supplied - should be single nonnegative number - no change made to %s',inputname(1)));
     end;
  elseif strcmp (name, 'dp');
     if isinteger (value) & min (size (value)) == 1
        pm.dp = value;
     else
        error (sprintf ('Bad dp supplied - should be single integer - no change made to %s',inputname(1)));
     end;
  elseif strcmp (name, 'default');
     if ischar (value) 
        pm.default = '';
     elseif isnumeric (value) & min (size (value)) == 1
        pm.default = value;
     else
        error (sprintf ('Bad dp supplied - should be single number or a string - no change made to %s',inputname(1)));
     end;
  else
     error (sprintf ('No field called %s exists',name));
  end;


assignin ('caller', inputname(1), pm);




