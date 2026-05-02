%% =================================================================
%   TL1-TRPCA methods for removing impulse noise
% 
%     
%     
%     
% 
%     
%     
%
%
% Please make sure your data is in range [0, 1].
%
% 
% 

clear;

close all;








EN_TL1   = 1;


methodname  = { 'Observed', 'TL1'};
Mnum = length(methodname);
Re_tensor  =  cell(Mnum,1);
psnr       =  zeros(Mnum,1);
ssim       =  zeros(Mnum,1);
time       =  zeros(Mnum,1);

%% Load initial data   HSI data cleanPavia    video data  hall.mat

data_num  = 1;

switch data_num
    case 1
        load('cleanPavia.mat');
        X=img_clean;
    case 2
        load('hall.mat');
end 







 frame=5;
if max(X(:))>1
    X = my_normalized(X);
end

Nway = size(X);
Ndim = ndims(X);

rhos = 0.3;  %% The ratio of corrupted pixels  
fprintf('=== The sample ratio is %4.2f ===\n', rhos);
%% index of the corrupted image
Xn = imnoise(X,'salt & pepper',rhos);   %% corrupted by uniform distributed values

figure(2)
imshow(Xn(:,:,frame)); 
i  = 1;
Re_tensor{i} = Xn;
[psnr(i), ssim(i)] = quality(X*255, Re_tensor{i}*255);
enList = 1;


%%my-TL1

i = i+1;
if EN_TL1
    
opts=[];   
opts.mu = 1e-4;
opts.tol = 1e-10;%
opts.rho =1.2;
opts.max_iter = 200;
opts.max_mu = 1e10;
opts.DEBUG = 0;%1,

[n1,n2,n3] = size(Xn);
lambda = 1/sqrt(max(n1,n2)*n3);
    
    fprintf('\n');
    disp(['performing ',methodname{i}, ' ... ']);
    t0= tic;
    [Xtl1,E1,err1,iter1] = trpca_TL1_tnn(Xn,lambda,opts);
    time(i)= toc(t0);
    [psnr(i), ssim(i)] = quality(X*255, Xtl1*255);
    enList = [enList,i];    
end






%% Show result
fprintf('\n');
fprintf('================== Result =====================\n');
fprintf(' %8.8s    %5.4s    %5.4s     \n','method','PSNR', 'SSIM');
for i = 1:length(enList)
    fprintf(' %8.8s    %5.3f    %5.3f     \n',...
        methodname{enList(i)},psnr(enList(i)), ssim(enList(i)));
end
fprintf('================== Result =====================\n');


figure(1)
imshow(X(:,:,frame));
figure(3)
imshow(Xtl1(:,:,frame));








