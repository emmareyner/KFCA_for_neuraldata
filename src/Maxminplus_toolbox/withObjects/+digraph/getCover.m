function cover = getCover(ord)
% function cover = getCOver(ord)
%
% A function to get the cover from some ord represented by its ordering
% matrix.
% Input:
% - [ord]: a square boolean matrix with a geq order:
%     if ord(i,j) = then i <= j else they are incomparable
% Output:
% - [cover]: the covering relation for the ording relation as a SPARSE
% matrix!
%
[m,n] = size(ord);
if (m ~= n)
    error('getCover','Non-square ord relation');
end

%cover = zeros(m);%Build output parameter and prepare as accumulator.
cover = sparse(m,m);
%for i = 1:m, ord(i,i) = 0; end;%All covering  relations are irreflexive
ord(sub2ind([m m],1:m,1:m))=true;
for i = 1:m
    upset = find(ord(i,:));%Initialise upper cover with upset
    icover = upset;
    for j = upset
        upper_upset = find(ord(j,:));
        if ~isempty(upper_upset)
            icover = setdiff(icover, upper_upset);
        end
    end
    cover(i,icover) = 1;
end
return