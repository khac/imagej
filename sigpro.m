clc;
clear;
addpath(genpath('Codes'));

% Some parameters %
psf = fspecial('gauss', 7, 1.6);
type = 'gaussian';          %'rayleigh';%'uniform';    
nSig =  0;                  %50; %12.42;   
scale_factor = 3;

% Output Directory %
if nSig == 0
    out_dir = strcat('Results\SR_results\Noiseless\','\Scale-',num2str(scale_factor));    
else
    out_dir = strcat('Results\SR_results\Noisy\',type,'_',num2str(nSig),'\Scale-',num2str(scale_factor));        
end

if ~exist(out_dir,'dir')
    mkdir(out_dir);
end

im_dir =  'Data\SR_test_images\';    % Give the input image directory
im_name = 'Butterfly.tif';           % Give the input image name


if nSig==0
    par.c1        =   0.2;
    par.c2        =   1.4;
    par.lamada    =   7;
    par.n         =   5;
else
    par.c1        =   0.03;
    par.c2        =   0.19;
    par.lamada    =   1.0;
    par.n         =   3;
end
par.psf       =   psf;
par.scale     =   scale_factor;
par.nSig      =   nSig;
par.iters     =   160;
par.nblk      =   12;
par.sigma     =   1.4;    
par.eps       =   0.3;


par.I        =   double( imread(fullfile(im_dir, im_name)) );
LR           =   Blur('fwd', par.I, par.psf);
LR           =   LR(1:par.scale:end,1:par.scale:end,:);    
par.LR       =   Add_noise(LR, par.nSig,type);   
par.B        =   Set_blur_matrix( par );

%Noise related parameters%
[n,yes,mr,rat] = is_noisy (par);
par.tt = n;
par.yes = yes; 
par.mr = mr;
par.rat = rat;

lname        =    strcat('LR_',num2str(par.scale),im_name);
imwrite(par.LR./255, fullfile(out_dir, lname));  

[h w ch]  =  size(par.I);

bcname        =    strcat('BC_',num2str(par.scale),im_name);
BC            =    imresize(par.LR,par.scale,'bicubic'); 
imwrite(BC./255, fullfile(out_dir, bcname));
if  ch == 3
    im_bc           =   rgb2ycbcr( uint8(BC) );
    im_bc           =   double( im_bc(:,:,1));    
    if isfield(par, 'I')
        ori_im         =   rgb2ycbcr( uint8(par.I) );
        ori_im         =   double( ori_im(:,:,1));
    end
else
    im_bc = BC;
    ori_im = par.I;
end
[PSNR2,RMSE2]  =  csnr( im_bc(1:h,1:w), ori_im, 0, 0 );
SSIM2      =  cal_ssim( im_bc(1:h,1:w), ori_im, 0, 0 );
fprintf('Bi-cubic %s:PSNR = %3.2f  SSIM = %f  RMSE=%f\n', im_name, PSNR2, SSIM2, RMSE2);   


[im PSNR SSIM RMSE]   =   SimSR_Superresolution( par );  
fname            =   strcat('SimSR_',num2str(par.scale), im_name);    
imwrite(im./255, fullfile(out_dir, fname));    
fprintf('%s: PSNR = %3.2f  SSIM = %f  RMSE = %f\n\n', im_name, PSNR, SSIM, RMSE);
