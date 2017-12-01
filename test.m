close all
clear
clc

I1 = imread('cones/im2.png');  %left image
I2 = imread('cones/im6.png');  %right image

% Image size
% [h, w , ~] = size(I1);
% 
% I1 = double(rgb2gray(I1(50:100, 300:350, :)))/255;
% I2 = double(rgb2gray(I2(50:100, 300:350, :)))/255;

%%
% FFT1 = fft2(I1);
% f1   = abs(FFT1);
% 
% FFT2 = fft2(I2);
% f2   = abs(FFT2);
% 
% crossFFT = FFT1.*conj(FFT2);
% R = crossFFT ./ abs(crossFFT);
% 
% crossCorr = ifft2(R);
% cc = abs(crossCorr);
% 
% figure, imshow(I1);
% figure, imshow(I2);
% figure, imagesc(cc);
% % figure, imshow(fftshift(uint8(f1)));

%%
R = crossCor(I1, I2, 61);