function vis = mk_tracing_visitors(search)
% function vis = mk_tracing_visitors(search)
%
% A function to create a record with visitor functions adequate for tracing
% a dfs. Prints to output the actions taken by the dfs.
%
% - search is one of:
%  search = 'dfs'(default)
%  search = 'dijkstra'
% Output:
% [vis]: is a struct with all the visitors needed to trace the type of
% search demanded.
error(nargchk(0,1,nargin));

%%% The default search type is 'dfs'
%if (nargin == 0), search='dfs'; end

%% utility functions
bias=double('a')-1;
vertex_vis_print_func = @(str) @(u) ...
    fprintf('%s: %s called on %s\n', search, str, char(bias+u));
edge_vis_print_func = @(str) @(ei,u,v) ...
    fprintf('%s: %s called on (%s -> %s)\n', ...
    search, str, char(bias+u), char(bias+v));
nullary_vis_print_func = @(str) @() ...
    fprintf('%s: %s called \n',search);

%ev_func = vertex_vis_print_func('examine_vertex');

%% Put all visitors into a struct
vis = struct();
switch search
    case 'dijsktra'
        dum=0;
% %The actual visitors for Dikstra
% vis.initialize_vertex = vertex_vis_print_func('initialize_vertex');
% vis.discover_vertex = vertex_vis_print_func('discover_vertex');
% vis.examine_vertex = vertex_vis_print_func('examine_vertex');
% vis.finish_vertex = vertex_vis_print_func('finish_vertex');
% vis.examine_edge = edge_vis_print_func('examine_edge');
% vis.edge_relaxed = edge_vis_print_func('edge_relaxed');
% vis.edge_not_relaxed = edge_vis_print_func('edge_not_relaxed');
%     case 'sccs'%strongly connected components
%         %no initialize_vertex,

    otherwise%dfs, for instance
    %case 'trace_dfs'
        %The actual trace visitors for dfs
        vis.initialize_vertex = vertex_vis_print_func('initialize_vertex');
        vis.start_vertex = vertex_vis_print_func('start_vertex');
        vis.discover_vertex = vertex_vis_print_func('discover_vertex');
        vis.finish_vertex = vertex_vis_print_func('finish_vertex');
        vis.examine_edge = edge_vis_print_func('examine_edge');
        vis.tree_edge = edge_vis_print_func('tree_edge');
        vis.forward_or_cross_edge = edge_vis_print_func('forward_or_cross_edge');
        vis.back_edge = edge_vis_print_func('back_edge');
end

return%vis