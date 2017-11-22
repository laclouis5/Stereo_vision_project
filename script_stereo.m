clear
close all
clc

%%
dbstop if error;

% note : faire le calcul de la valeur absolue sur le maximun de données
% possible

alpha = 0.01;
% Charge les images

I1 = imread('cones/im2.png');  %left image
I2 = imread('cones/im6.png');  %right image

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
win_size = 10;

unaryTerms1 = computeUnaryTerms(I1, I2, mins, maxs, win_size);
unaryTerms2 = computeUnaryTerms(I2, I1, mins, -maxs, win_size);

%% Calcul brut de la carte de disparite
[minUnaryTerms1,ind1] = min(unaryTerms1,[],3);
[minUnaryTerms2,ind2] = min(unaryTerms2,[],3);

% D1 et D2 sont les disparité placée au bon endroit de l'échelle
D1 = ind1 - 1 + mins;
D2 = ind2 - 1 + mins;

figure(2); clf
subplot(1,2,1), imagesc(D1); title('Disparity on I1');
subplot(1,2,2), imagesc(D2); title('Disparity on I2');
drawnow;

%% Calcul de la carte de disparite par SGM 

S1 = sgm2(unaryTerms1, alpha);
[minHor1,ind1] = min(S1,[],3);

D_SGM_1 = ind1 - 1 + mins;

figure(4);
subplot(1,2,1), imagesc(D_SGM_1); title('SGM on I1');

% S2 = sgm(unaryTerms2, alpha);
% [minHor2, ind2] = min(S2,[],3);
% D_SGM_2 = -(ind2 - 1 + mins);
% 
% figure(4);
% subplot(1,2,2), imagesc(-D_SGM_2); title('SGM on I2');