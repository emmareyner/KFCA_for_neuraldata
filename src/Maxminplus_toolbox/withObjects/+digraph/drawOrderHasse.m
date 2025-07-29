function [X,Y] = drawOrderHasse(order)
% function [X,Y] = drawOrderHasse(order)
%
% A function to draw the Hasse diagram of an order relation
%
% Uses the GraphViz library and GraphViz2Mat2.1 package.
%
% TODO: Make matlab export the final graph for dot to plot.

    [n,m] = size(order);
    (m == n) || error('Non-square covering relation');
 
    cover = getCover(order);
    [X,Y] = drawCoverHasse(cover);

    return