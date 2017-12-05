% Louis LAC
% Computer Vision Project
% 2017

%%
clear
close all
clc
dbstop if error;

%% Param
alpha = 0.1;
opt_size = 5;
maxs = 60;
mins = 0;
win_size = 1;
census_size = 5;
lr_const_thresh = 2;


%% Loading
[I1, map1] = imread('cones/im2.png');  %left image
[I2, map2] = imread('cones/im6.png');  %right image

disp1 = imread('cones/disp2.png');
disp2 = imread('cones/disp6.png');

I1 = double(I1)/255;
I2 = double(I2)/255;

% Image size
[h, w , ~] = size(I1);

%% Affiche les images
figure(1);
h1=subplot(1,2,1); imshow(I1); title('Left image I1');
h2=subplot(1,2,2); imshow(I2); title('Right image I2');
linkaxes([h1,h2]), drawnow;

%% Census Transform
% CT1(:, :, 1) = censusTransform(I1(:, :, 1), census_size);
% CT1(:, :, 2) = censusTransform(I1(:, :, 2), census_size);
% CT1(:, :, 3) = censusTransform(I1(:, :, 3), census_size);
% 
% CT2(:, :, 1) = censusTransform(I2(:, :, 1), census_size);
% CT2(:, :, 2) = censusTransform(I2(:, :, 2), census_size);
% CT2(:, :, 3) = censusTransform(I2(:, :, 3), census_size);

CT1 = I1;
CT2 = I2;

%% Calcul des "unary terms"
unaryTerms1 = computeUnaryTerms(CT1, CT2, mins, maxs, win_size);
unaryTerms2 = computeUnaryTerms(CT2, CT1, mins, -maxs, win_size);

%% Optimisation of Unary terms
for k = 1:(maxs - mins + 1)
    
    unaryTerms1(:, :, k) = medfilt2(unaryTerms1(:, :, k), [opt_size, opt_size]);
    unaryTerms2(:, :, k) = medfilt2(unaryTerms2(:, :, k), [opt_size, opt_size]);
end

%% Calcul brut de la carte de disparite
[minUnaryTerms1,ind1] = min(unaryTerms1,[], 3);
[minUnaryTerms2,ind2] = min(unaryTerms2,[], 3);

% D1 et D2 sont les disparité placée au bon endroit de l'échelle
D1 = ind1 - 1 + mins;
D2 = -(ind2 - 1 + mins);

figure(2); clf
subplot(1,2,1), imshow(D1, [mins, maxs]); title('Disparity on I1');
subplot(1,2,2), imshow(-D2, [mins, maxs]); title('Disparity on I2');
drawnow;

%% Calcul de la carte de disparite par SGM 
S1 = sgm(unaryTerms1, alpha);
S2 = sgm(unaryTerms2, alpha);

[minHor1, ind1] = min(S1,[],3);
[minHor2, ind2] = min(S2,[],3);

D_SGM_1 = ind1 - 1 + mins;
D_SGM_2 = -(ind2 - 1 + mins);

figure(4);
subplot(1,2,1), imshow(D_SGM_1, [mins, maxs]), title('SGM on I1');
subplot(1,2,2), imshow(-D_SGM_2, [mins, maxs]), title('SGM on I2');

%% Left-Right Consistency
[R1, R2] = leftRightConsistency(D_SGM_1, D_SGM_2, lr_const_thresh);

figure(5),
subplot(1, 2, 1), imshow(R1, [min(min(R1)), max(max(R1))]), title('SGM on I1 with R-L consistency');
subplot(1, 2, 2), imshow(-R2, [min(min(-R2)), max(max(-R2))]), title('SGM on I2 with R-L consistency');

%% error quantification
imTrue1 = (double(disp1) - min(min(double(disp1))))/max(max(double(disp1)));
imTrue2 = (double(disp2) - min(min(double(disp2))))/max(max(double(disp2)));

imSGM1  = (R1 - min(min(R1)))/max(max(R1));
imSGM2  = (-R2 - min(min(-R2)))/max(max(-R2));

error1 = abs(imTrue1 - imSGM1);
error2 = abs(imTrue2 - imSGM2);

figure(6),
subplot(1, 2, 1), imagesc(error1), title('error between GT and SGM on image 1');
subplot(1, 2, 2), imagesc(error2), title('error between GT and SGM on image 2');