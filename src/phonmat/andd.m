function yes = andd (varargin)

varargin{:}

yes = 1;
for i = 1 : length(varargin)
  if eval(varargin{i})
    yes = 0;
    break;
  end;
end;;