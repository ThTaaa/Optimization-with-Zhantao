function v = vsubproblem(I, d, lambda, alpha, r)
[m, n, c] = size(I);
a = alpha / r;

parX = zeros(n, n);
parY = zeros(m, m);
for i = 1 : n
    parX(i, i) = -1;
    j = mod(i + n - 2, n) + 1;
    parX(i, j) = 1;
end

for i = 1 : m
    parY(i, i) = -1;
    j = mod(i, m) + 1;
    parY(i, j) = 1;
end

z_y = zeros(m, 1);
z_x = zeros(n, 1);
z_y(1, 1) = -1; z_y(m, 1) = 1;
z_x(1, 1) = -1; z_x(n, 1) = 1;

deltaY = zeros(m, n);
deltaY(:, 1) = z_y;
deltaX = zeros(m, n);
deltaX(1, :) = z_x;

J = ones(m, n);
v = zeros(m, n, c);
for k = 1 : c
    f = I(:, :, k);
    W1 = d(1:m, :, k) + lambda(1:m, :, k) / r;
    W2 = d(m+1:2*m, :, k) + lambda(m+1:2*m, :, k) / r;
    fft2deltaX = fft2(deltaX);
    fft2deltaY = fft2(deltaY);
    DFTv = (fft2(W1).* conj(fft2deltaX) + fft2(W2).* conj(fft2deltaY) + a * fft2(f));
    DFTv = DFTv ./ (a * J + fft2deltaX .* conj(fft2deltaX) + fft2deltaY .* conj(fft2deltaY));
    v(:,:,k) = real(ifft2(DFTv));
    
end

end


