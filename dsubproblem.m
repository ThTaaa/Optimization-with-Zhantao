function d = dsubproblem(v, lambda, r)

d_v = nabla(v);
[m, n, c] = size(v);
vd_total = zeros(2*m, n, c);

for i = 1 : m
   for j = 1 : n
       vt = zeros(2, c);
       vd = zeros(2, c);
       for k = 1 : c
          vt(1, k) = d_v(i, j, k) - lambda(i, j, k) / r;
          vt(2, k) = d_v(i+m, j, k) - lambda(i+m, j, k) / r;
       end
       vt_vec = [vt(1, :), vt(2, :)];
       rvt_norm = norm(r * vt_vec);
       
       if rvt_norm > 1
           vd = (1 - 1 / rvt_norm) * vt;
       end
       
       vd_total(i, j, :) = vd(1, :);
       vd_total(i+m, j, :) = vd(2, :);
   end
end


d = vd_total;
end

