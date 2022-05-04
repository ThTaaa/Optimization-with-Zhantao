r = 0.01;
alpha = 2; 
l_max = 200;


%============================================
%load data
I = double(imread('Figures/181021.jpg'))./255;


%imshow(ID)

%=============================================
%Initialization
[m,n,c] = size(I);
P = I;
for k = 1 : c
    P(:, :, k) = imnoise(P(:, :, k), 'gaussian', 0.05);
end
imwrite(P, '181021_noise.png');
v_array = zeros(m, n, c, l_max);
lambda_array = zeros(2*m, n, c, l_max);
d_array = zeros(2*m, n, c, l_max);


v_array(:,:,:,1) = P;
d_init = nabla(P);

psnr_total = zeros(1,l_max);


%============================================
%iteration
d_pre = d_init;
lambda_pre = lambda_array(:,:,:,1);
for l = 1 : l_max
   v_array(:,:,:,l) = vsubproblem(P, d_pre, lambda_pre, alpha, r);
   d_array(:,:,:,l) = dsubproblem(v_array(:,:,:,l), lambda_pre, r);
   lambda_array(:,:,:,l+1) = lambda_pre + r*(d_array(:,:,:,l) - nabla(v_array(:,:,:,l)));
   
   psnr_total(1, l) = psnr(v_array(:,:,:,l), I);
   
   d_pre = d_array(:,:,:,l);
   lambda_pre = lambda_array(:,:,:,l+1);
   fprintf('l=%d\n', l);
end
%imwrite(v_array(:,:,:,155), ['3063_denoise10_03',datestr(now,'mm_dd_HH_MM'), '.png'])
%imwrite(v_array(:,:,:,l_max), ['3063_denoisel_max',datestr(now,'mm_dd_HH_MM'), '.png'])
