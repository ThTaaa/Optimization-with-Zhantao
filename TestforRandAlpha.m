
l_max = 100;


%============================================
%load data
foldername = './TestImage';
filelist = dir(foldername);
imageNumber = length(filelist) - 2;  %The first two files are '.' and '..'
rNumber = 10;

psnr_array = zeros(imageNumber, rNumber);
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
    
    
    
    for ithr = 1 : rNumber
        r = 0.01 ;
        alpha = 0.2 * ithr + 1;
        %=============================================
        %Initialization
        v_array = zeros(m, n, c, l_max);
        lambda_array = zeros(2*m, n, c, l_max);
        d_array = zeros(2*m, n, c, l_max);


        v_array(:,:,:,1) = P;
        d_init = nabla(P);




        %============================================
        %iteration
        d_pre = d_init;
        lambda_pre = lambda_array(:,:,:,1);
        for l = 1 : l_max
           v_array(:,:,:,l) = vsubproblem(P, d_pre, lambda_pre, alpha, r);
           d_array(:,:,:,l) = dsubproblem(v_array(:,:,:,l), lambda_pre, r);
           lambda_array(:,:,:,l+1) = lambda_pre + r*(d_array(:,:,:,l) - nabla(v_array(:,:,:,l)));
           
           d_pre = d_array(:,:,:,l);
           lambda_pre = lambda_array(:,:,:,l+1);
           fprintf('Image number = %d , r = %d, alpha = %d, l=%d\n', ithImage, r, alpha, l);
        end
        psnr_array(ithImage, ithr) = psnr(v_array(:,:,:,l_max), I);
    end
end

