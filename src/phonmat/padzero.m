function z=padzero(z,k)

if k > 0, z = [asrow(z) zeros(1,k)]; end;