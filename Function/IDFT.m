function M = IDFT(X)

[m, n] = size(X);
F_m = DFTma(m);
F_n = DFTma(n);
F_mInv = conj(F_m) / m;
F_nInv = conj(F_n) / n;

M = F_mInv * X * F_nInv;
end

