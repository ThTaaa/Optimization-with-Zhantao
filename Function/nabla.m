function d = nabla(v)

[row, col, hei] = size(v);
d_x = v(:,[2:col, 1],:) - v;
d_y = v([2:row, 1],: ,:) - v;
d = [d_x; d_y];
end




