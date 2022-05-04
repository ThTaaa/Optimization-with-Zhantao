function M = DFT(x)
[m, n] = size(x);
F_m = DFTma(m);
F_n = DFTma(n);

M = F_m * x * F_n;

end

