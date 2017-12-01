% Louis LAC
% Computer Vision Project
% 2017

%%
clear
close all
clc
dbstop if error;

% note : faire le calcul de la valeur absolue sur le maximum de données
% possible

alpha = 0.2;
% Charge les images

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
linkaxes([h1,h2]);
drawnow;

%% Calcul des "unary terms"
maxs = 59;
mins = 0;
win_size = 3;

unaryTerms1 = computeUnaryTerms(I1, I2, mins, maxs, win_size);
unaryTerms2 = computeUnaryTerms(I2, I1, mins, -maxs, win_size);

%% Optimisation Unary terms
for k = 1:(maxs - mins + 1)
    
    unaryTerms1(:, :, k) = medfilt2(unaryTerms1(:, :, k), [7, 7]);
    unaryTerms2(:, :, k) = medfilt2(unaryTerms2(:, :, k), [7, 7]);
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

[minHor1,ind1] = min(S1,[],3);
[minHor2, ind2] = min(S2,[],3);

D_SGM_1 = ind1 - 1 + mins;
D_SGM_2 = -(ind2 - 1 + mins);

figure(4);
subplot(1,2,1), imshow(D_SGM_1, [mins, maxs]); title('SGM on I1');
subplot(1,2,2), imshow(-D_SGM_2, [mins, maxs]); title('SGM on I2');

%% error quantification
imTrue1 = (double(disp1) - min(min(double(disp1))))/max(max(double(disp1)));
imTrue2 = (double(disp2) - min(min(double(disp2))))/max(max(double(disp2)));

imSGM1  = (D_SGM_1 - min(min(D_SGM_1)))/max(max(D_SGM_1));
imSGM2  = (-D_SGM_2 - min(min(-D_SGM_2)))/max(max(-D_SGM_2));

error1 = abs(imTrue1 - imSGM1);
error2 = abs(imTrue2 - imSGM2);

figure(5),
imagesc(error1);

figure(6),
imagesc(error2);
% subplot(1, 2, 1), imshow(error1, [min(min(error1)), max(max(error1))]);
% subplot(1, 2, 2), imshow(error2, [min(min(error2)), max(max(error2))]);