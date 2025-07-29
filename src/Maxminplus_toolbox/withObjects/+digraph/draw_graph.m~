function [sp] = draw_graph(A)

idx =find(A>-Inf);
arc_labels = cellfun(@(n) 'arc_label',mat2cell(idx),'UniformOutput',false);
args = cell2struct({A(idx)},arc_labels,1);
graph_to_dot(A,args);

return

