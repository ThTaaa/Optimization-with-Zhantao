l_max = 200;

%============================================
%load data
foldername = './TestImage_2';
filelist = dir(foldername);
imageNumber = length(filelist) - 2;  %The first two files are '.' and '..'

psnr_total = zeros(imageNumber, l_max);
delta_psnr_total = zeros(imageNumber, l_max);

d_nablaV_norm_toal = zeros(imageNumber, l_max);
deltaD_norm_total = zeros(imageNumber, l_max);

nablaV_norm_total = zeros(imageNumber, l_max);
d_norm_total = zeros(imageNumber, l_max);
max_d_nablav_total = zeros(imageNumber, l_max);
max_deltaD_total = zeros(imageNumber, l_max);



parfor ithImage = 1 : imageNumber
    fileName = filelist(ithImage + 2).name;
    I = double(imread(fileName))./255;
    %imshow(ID)
    
    [m,n,c] = size(I);
    P = I;
    for k = 1 : c
        P(:, :, k) = imnoise(P(:, :, k), 'gaussian', 0.05);
    end
    %imwrite(P, '10_noise.png');
    
    r = 0.01;
    alpha = 2;
    %=============================================
    %Initialization
    v_array = zeros(m, n, c, l_max);
    lambda_array = zeros(2*m, n, c, l_max);
    d_array = zeros(2*m, n, c, l_max);

    v_init = P;
    d_init = nabla(P);
    
    %============================================
    %iteration
    v_pre = v_init;
    d_pre = d_init;
    d_norm_pre = sqrt( sum(sum(sum( d_pre.^2 ))));
    lambda_pre = lambda_array(:,:,:,1);
    psnr_pre = psnr(P, I);
    for l = 1 : l_max
       v_array(:,:,:,l) = vsubproblem(P, d_pre, lambda_pre, alpha, r);
       d_array(:,:,:,l) = dsubproblem(v_array(:,:,:,l), lambda_pre, r);
       lambda_array(:,:,:,l+1) = lambda_pre + r*(d_array(:,:,:,l) - nabla(v_array(:,:,:,l)));
       
       psnr_total(ithImage, l) = psnr(v_array(:,:,:,l), I);
       delta_psnr_total(ithImage, l) = psnr_total(ithImage, l) - psnr_pre;
       
       d_norm_total(ithImage, l) = sqrt( sum(sum(sum( d_array(:,:,:,l).^2 ))));
       max_deltaD_total(ithImage, l) = max([d_norm_total(ithImage, l), d_norm_pre]);
       nablaV_norm_total(ithImage, l) = sqrt( sum(sum(sum( nabla(v_array(:,:,:,l)) .^2 ))));
       max_d_nablaV_total(ithImage, l) = max([d_norm_total(ithImage, l), nablaV_norm_total(ithImage, l)]);
       
       d_nablaV_norm_total(ithImage, l) = sqrt( sum(sum(sum( (d_array(:,:,:,l) - nabla(v_array(:,:,:,l))) .^2 ))));
       deltaD_norm_total(ithImage, l) = sqrt( sum(sum(sum( (d_array(:,:,:,l) - d_pre).^2 ))));
       
       
       psnr_pre = psnr_total(ithImage, l);
       d_norm_pre = d_norm_total(ithImage, l);
       d_pre = d_array(:,:,:,l);
       lambda_pre = lambda_array(:,:,:,l+1);
       
       
       
       
       fprintf('Image number = %d , r = %d, alpha = %d, l=%d\n', ithImage, r, alpha, l);
    end


end
save(['Test_table1_',datestr(now,'mm_dd_HH_MM')])
