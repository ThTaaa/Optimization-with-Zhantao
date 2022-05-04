function F_m = DFTma(m)

F_m = zeros(m,m);
w_m = exp(-2i * pi / m);
for k = 0 : m-1
   for j = 0 : m-1
       F_m(k+1,j+1) = w_m^(k*j);
   end
end

end
