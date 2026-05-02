
clear




X = double(imread('28.jpg'));
X = X/255;
maxP = max(abs(X(:)));
[n1,n2,n3] = size(X);
Xn = X;
rhos = 0.2; 

ind = find(rand(n1*n2*n3,1)<rhos);
RAND2=rand(length(ind),1);
% Generate 20% noisy data randomly
Xn(ind) = RAND2;





%%my-TL1

opts.mu = 1e-4;
opts.tol = 1e-10;%
opts.rho =1.02;
opts.max_iter = 1000;
opts.max_mu = 1e10;
opts.DEBUG = 0;%

[n1,n2,n3] = size(Xn);
lambda = 1/sqrt(max(n1,n2)*n3);
[Xtl1,Etl1,errtl1,itertl1] = trpca_TL1_tnn(Xn,lambda,opts);
 



%%my-TL1
Xtl1 = max(Xtl1,0);
Xtl1 = min(Xtl1,maxP);
psnr = PSNR(X,Xtl1,maxP);
ssim = SSIM(X*255,Xtl1*255);


    %% 
    
    fprintf('  PSNR: %.4f \n', psnr);
    fprintf('  SSIM: %.4f \n', ssim);
    



figure(1)
imshow(X/max(X(:)))
title('Original')

figure(2)
imshow(Xn/max(Xn(:)))
title('Noisy')

figure(3)
imshow(Xtl1/max(Xtl1(:)))
title('TLI-TRPCA')

