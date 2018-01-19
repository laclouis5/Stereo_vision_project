% Louis LAC
% Computer Vision
% Création de carte de disparité par SGM
% 2017-2018

%% Notice
% les images de disparité 'Ground Truth' (GT) de la base de donnée
% Middlebury utilisées sont disponibles dans plusieurs formats d'échelle
% (1, 1/2, 1/3, 1/4). Pour utiliser une image GT qui a une dimension
% inférieure à sa taille d'origine de l'image il faut diviser ses valeurs
% par le facteur d'échelle (2, 3 ou 4).
%
% Les images du set de 2005 en résolution 1/3 nécessitent un facteur de 3
% (book, art, reindeer, ...) alors que les images du set de 2003 en
% résolution 1/4 demandent un facteur de 4 (cones, ...) à spécifier dans la
% variable 'scale_image.
%
% Les SGM à évaluer doivent être au format 'double' et dans le workspace de
% MATLAB et les fichier de disparité sont supposés être en couleurs
% indexées.

%% Param
pathGT1 = '';
pathGT2 = '';

scale_image = 3; % echelle des images

disp1 = double(imread(pathGT1))/scale_image;
disp2 = double(imread(pathGT2))/scale_image;

%% Main
error1 = abs(D_SGM_1 - disp1) > 2;
error2 = abs(-D_SGM_2 - disp2) > 2;

nbErr1 = 100*length(find(error1 == 1))/numel(error1)
nbErr2 = 100*length(find(error2 == 1))/numel(error2)

%% Plot
figure,
subplot(1, 2, 1), imshow(~error1), title('Error between GT and SGM on image 1');
subplot(1, 2, 2), imshow(~error2), title('Error between GT and SGM on image 2');