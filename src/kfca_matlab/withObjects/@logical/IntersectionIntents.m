function [B,labels]=IntersectionIntents(I)
%Finds the system of intents by intersection
% I should be clarified.
% B = IntersectionIntents(I) only find the intents
% [B,lobj] = IntersectionIntents(I) produces a reduced labelling
% for the object concepts (really their extents). For object g,
% lobj(g) points at the extent of its object concept in A.
%
% FVA, 2011

% Implementation details: This actually uses IntersectionExtents on the
% transposed relation, which does not use some basic functions of Matlab,
% like unique.
% TODO: reengineer IntersectionExtents based on unique for the detection of
% collisions.
[B,labels]=IntersectionExtents(I');
%
% See concepts.m
return%B,labels

