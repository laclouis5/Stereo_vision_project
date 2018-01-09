% Louis LAC
% Computer Vision Project
% 2017

% noter dans le rapport que les Unaryterms sont calculés comme la somme des
% valeurs absolues des différences et non la différence des valeurs absolue
% de la somme

%%
clear
close all
clc
dbstop if error;

%% Param
alpha = 0.1;
opt_size = 3;
maxs = 74;
mins = 0;
win_size = 5;
census_size = 3;
lr_const_thresh = 2;

%% Loading
[I1, map1] = imread('/Users/laclouis5/Downloads/Books/view1.png');  %left image
[I2, map2] = imread('/Users/laclouis5/Downloads/Books/view5.png');  %right image

disp1 = double(imread('/Users/laclouis5/Downloads/Books/disp1.png'))/3;
disp2 = double(imread('/Users/laclouis5/Downloads/Books/disp5.png'))/3;

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
% CT1 = censusTransform(rgb2gray(I1), census_size);
% CT2 = censusTransform(rgb2gray(I2), census_size);

CT1 = I1;
CT2 = I2;

%% Calcul des "unary terms"
unaryTerms1 = computeUnaryTerms(CT1, CT2, mins, maxs, win_size);
unaryTerms2 = computeUnaryTerms(CT2, CT1, mins, -maxs, win_size);

%% Optimisation of Unary terms
% for k = 1:(maxs - mins + 1)
%     
%     unaryTerms1(:, :, k) = medfilt2(unaryTerms1(:, :, k), [opt_size, opt_size]);
%     unaryTerms2(:, :, k) = medfilt2(unaryTerms2(:, :, k), [opt_size, opt_size]);
% end

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
subplot(1, 2, 1), imshow(R1, [mins, maxs]), title('SGM on I1 with R-L consistency');
subplot(1, 2, 2), imshow(-R2, [mins, maxs]), title('SGM on I2 with R-L consistency');

%% Error quantification with BAD 2.0
error1 = abs(D1 - disp1) > 2;
error2 = abs(-D_SGM_2 - disp2) > 2;

nbErr1 = 100*length(find(error1 == 1))/numel(error1);
nbErr2 = 100*length(find(error2 == 1))/numel(error2);

figure(6),
subplot(1, 2, 1), imshow(~error1), title('error between GT and SGM on image 1');
subplot(1, 2, 2), imshow(~error2), title('error between GT and SGM on image 2');