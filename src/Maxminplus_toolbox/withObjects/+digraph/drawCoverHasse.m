function [X,Y] = drawCoverHasse(cover)
% function [X,Y] = drawCoverHasse(cover)
%
% A function to draw the Hasse diagram of an order as represented by its
% covering relation.
%
% Uses the GraphViz library and GraphViz2Mat2.1 package.
%
% TODO: Make matlab export the final graph for dot to plot.
    
    [n,m] = size(cover);
    (m == n) || error('Non-square covering relation');
    adj = cover';%draw it downwards, as dot always does.
    
    %1.- Convert to a graphviz file
    tmpDOTfile = '_GtDout.dot';
    tmpLAYOUT  = '_LAYout.dot'; 
    graph_to_dot(adj,'filename', tmpDOTfile);
    %Defaults, top to bottom (bad), directed (Good), with arrows(bad)
    
    %2.- Transform using dot to something interesting
    %Create the OS string to carry out the transformation
    %  Which OS ?
    if ispc
        shell = 'dos';
    else
        shell = 'unix';
    end 
    dot = ['(''dot'];
    %dot = ['(''neato'];
    cmd = strcat([shell dot ' -o' tmpLAYOUT ' ' tmpDOTfile ''')']);    % -x compact
    status = eval(cmd);
    
    % 3. - Read from formatted output
    [trash, names, x, y] = dot_to_graph(tmpLAYOUT);  % load DOT layout
    num_names = str2num(char(names))';
    nam_len = length(names);
    if nam_len < n 
         % plot singletons without coordinates all together in a lower left 
        num_names(nam_len+1:n) = my_setdiff(1:n, num_names);
        x(nam_len+1:n) = 0.05*ones(1,n-nam_len);
        y(nam_len+1:n) = 0.05*ones(1,n-nam_len);
    end
    % recover from dot_to_graph node_ID permutation 
    [ignore,lbl_ndx] = sort(num_names);
    x = x(lbl_ndx); y = y(lbl_ndx); 
    labels = names(lbl_ndx);

    %4 . Draw in Matlab
    if n > 40
        fontsz = 7;
    elseif n < 12
        fontsz = 12;
    else 
        fontsz = 9; 
    end 
    figure; clf; axis square      %  now plot 
    [X, Y, h] = graph_draw(adj, 'node_labels', labels, 'fontsize', fontsz, ...
                           'node_shapes', zeros(size(x,2),1), 'X', x, 'Y', y);
    %delete(tmpLAYOUT); delete(tmpDOTfile);     % clean up temporary files 

    return