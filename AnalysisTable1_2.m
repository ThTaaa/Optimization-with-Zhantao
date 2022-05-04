load Test_table1_05_03_18_41
[imageNumber, l_max] = size(psnr_total);
iter_array = 1:1:l_max;
image_array = 1:1:imageNumber;

plotX = ones(imageNumber, 1) * iter_array;
plotY = image_array' * ones(1, l_max);
x = plotX(:); y = plotY(:); z = psnr_total(:);
psnrToler_logmin = 5;
l_psnr0X = zeros(imageNumber, psnrToler_logmin);   % the first column is the peak iteration number or l_max; The ith column is pnsr tolerance 10^-i

figure(1);
scatter3(x', y', z', 8)
xlabel('Iteration Number')
ylabel('Images')
zlabel('PSNR')

for i = 1 : 1 : imageNumber
    psnrToler_flag = zeros(psnrToler_logmin, 1);
    for j = 1 : 1 : psnrToler_logmin
        l_psnr0X(i, j) = l_max;
    end
    
    
    for l = 2 : 1 : l_max
        
        if psnrToler_flag(1, 1) == 0 && psnr_total(i, l) - psnr_total(i, l-1) < 0
            l_psnr0X(i, 1) = l - 1;
            psnrToler_flag(1, 1) = 1;
        end
        
        for j = 2 : 1 : psnrToler_logmin
            
            if (psnrToler_flag(j, 1) == 0) && (psnr_total(i, l) - psnr_total(i, l-1) < 10^(-j))
                l_psnr0X(i, j) = l - 1;
                psnrToler_flag(j, 1) = 1;
            end
        end
        
    end
   
    
end

l_psnr0X_T = l_psnr0X';
toler04data = zeros(imageNumber, 4); % 1 to 4 column, ||d-nablaV||, ||d^l-d^l-1||, max(d,nablaV), max(d^l, d^l-1)
toler02data = zeros(imageNumber, 4);
for i = 1 : 1 : imageNumber
    ithiter = l_psnr0X(i, 4);
    ithiter02 = l_psnr0X(i, 2);
    toler02data(i, 1) = d_nablaV_norm_total(i, ithiter02);
    toler02data(i, 2) = deltaD_norm_total(i, ithiter02);
    toler02data(i, 3) = max_d_nablaV_total(i, ithiter02);
    toler02data(i, 4) = max_deltaD_total(i, ithiter02);   
    
    toler04data(i, 1) = d_nablaV_norm_total(i, ithiter);
    toler04data(i, 2) = deltaD_norm_total(i, ithiter);
    toler04data(i, 3) = max_d_nablaV_total(i, ithiter);
    toler04data(i, 4) = max_deltaD_total(i, ithiter);   
end
%save(['Analysis_table1_',datestr(now,'mm_dd_HH_MM')])
