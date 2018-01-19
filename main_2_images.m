% Louis LAC
% Computer Vision
% Création de carte de disparité par SGM
% 2017-2018

clear
close all
clc

%% Notice
% Pour pouvoir évaluer les cartes de disparités en les comparant aux
% vérités de terrain la variable 'maxs' doit correspondre à la valeur
% maximale de la carte de disparité réelle, divisée par le facteur
% d'échelle (cf notice de main_eval.m).
% 
% Par défaut 'maxs' vaut 74 pour que l'évaluation fonctionne avec les
% images du sets de 2005 (Middlebury) en résolution 1/3 comme 'books'.
%
% Une manière de le calculer automatiquement connaissant la carte de
% disparité réelle (décommenter la suite et commenter 'maxs' dans Param) : 
%
% pathGT1 = '';     % chemin de la GT
% scale_image = 3;  % facteur d'échelle (cf notice de main_eval.m)
% disp = double(imread(pathGT1));
% maxs = ceil(max(max(disp/scale_image)));

%% Param
alpha = 0.1;         % intensité de la régularisation de la SGM
win_size = 5;        % taille de la fenêtre de moyennage
census_size = 3;     % taille de la fenêtre du CT
lr_const_thresh = 2; % seuil de validation de la LR-consistency
mins = 0;            % disparité minimale de calcul
maxs = 74;           % disparité minimale de calcul
CT = 'no';           % utilisation du CT ('yes' or 'no')

% chemin des images et disparité réelles
pathImage1 = '';
pathImage2 = '';

%% Loading
I1 = double(imread(pathImage1))/255;  %left image
I2 = double(imread(pathImage2))/255;  %right image

%% Affiche les images
figure(1);
h1 = subplot(1,2,1); imshow(I1); title('Left image I1');
h2 = subplot(1,2,2); imshow(I2); title('Right image I2');
linkaxes([h1,h2]), drawnow;

%% Census Transform
if(strcmp(CT, 'yes')) 
    CT1 = censusTransform(rgb2gray(I1), census_size);
    CT2 = censusTransform(rgb2gray(I2), census_size);
    
    win_size = win_size + 2;
    
    figure,
    subplot(1,2,1), imshow(CT1, [min(min(CT1)), max(max(CT1))]);
    colormap('gray'), title('Census Transform on I1');
    subplot(1,2,2), imshow(CT1, [min(min(CT1)), max(max(CT1))]);
    colormap('gray'), title('Census Transform on I2');
    drawnow;

elseif(strcmp(CT, 'no')) 
    CT1 = I1;
    CT2 = I2;
    
else
    error('Invalid input argument CT, it must be ''yes'' or ''no''');
end

%% Calcul des "unary terms"
unaryTerms1 = computeUnaryTerms(CT1, CT2, mins, maxs, win_size);
unaryTerms2 = computeUnaryTerms(CT2, CT1, mins, -maxs, win_size);

%% Calcul brut de la carte de disparite
[~, ind1] = min(unaryTerms1,[], 3);
[~, ind2] = min(unaryTerms2,[], 3);

D1 = ind1 - 1 + mins;
D2 = -(ind2 - 1 + mins);

figure,
subplot(1,2,1), imshow(D1, [mins, maxs]); title('Disparity on I1');
subplot(1,2,2), imshow(-D2, [mins, maxs]); title('Disparity on I2');
drawnow;

%% Calcul de la carte de disparite par SGM 
S1 = sgm(unaryTerms1, alpha);
S2 = sgm(unaryTerms2, alpha);

[~, ind1] = min(S1,[],3);
[~, ind2] = min(S2,[],3);

D_SGM_1 = ind1 - 1 + mins;
D_SGM_2 = -(ind2 - 1 + mins);

figure,
subplot(1,2,1), imshow(D_SGM_1, [mins, maxs]), title('SGM on I1');
subplot(1,2,2), imshow(-D_SGM_2, [mins, maxs]), title('SGM on I2');
drawnow;

%% Left-Right Consistency
[R1, R2] = leftRightConsistency(D_SGM_1, D_SGM_2, lr_const_thresh);

figure,
subplot(1, 2, 1), imshow(R1, [mins, maxs]), title('SGM on I1 with R-L consistency');
subplot(1, 2, 2), imshow(-R2, [mins, maxs]), title('SGM on I2 with R-L consistency');
drawnow;