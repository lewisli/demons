%% Swiggle Line Demo
clear all;

% Data
I1 = imread('data/lace1.png');
I2 = imread('data/lace2.png');

% Parameters
MaxIter = 800;
NumPyramids = 4;
filterSize = [50 50];
Tolerance = 0.001;
alpha = 0.45;
plotFreq = 5;

[Tx Ty] = ComputeDeformation(I1,I2,MaxIter,NumPyramids,filterSize,...
    Tolerance,alpha,plotFreq);

%% Seismic Image Demo
clear all;

% Data
load('data/I1.mat');
load('data/I2.mat');

% Parameters
MaxIter = 800;
NumPyramids = 4;
filterSize = [50 50];
Tolerance = 0.001;
alpha = 0;
plotFreq = 5;

[Tx Ty] = ComputeDeformation(I1,I2,MaxIter,NumPyramids,filterSize,...
    Tolerance, alpha, plotFreq);

%% Translated Image Test
clear all;
load('data/TranslatedImage.mat');

I1 = mat2gray(I1);
I3 = mat2gray(I2);
I3(isnan(I2)) = I1(isnan(I2));
% Pre-process

MaxIter = 50;
NumPyramids = 4;
filterSize = [100 100];
filterSigma = 40;
Tolerance = 0.0;
alpha = 0.85;
plotFreq = 5;

imagesc(I3);

[Tx Ty] = ComputeDeformation(I1,I3,MaxIter,NumPyramids,filterSize,...
    filterSigma,Tolerance, alpha, plotFreq);
close all;
A = imread('TruthInterpration.png');
load('I2.mat');
TXNew = 26+Tx;
TYNew = Ty;
NewInterpretation = 1-DeformImage(double(A),TXNew,TYNew)/255;
OldInterpretation = 1 - double(A)/255;
E = I2;
ProbImage = NewInterpretation;
h = imagesc(I2);
colormap gray;
green = cat(3, zeros(size(E)), ones(size(E)), zeros(size(E)));
hold on
freezeColors;
h = imagesc((1-ProbImage),[0 1]);
colormap jet;
colorbar;
hold off


% Use our influence map image as the AlphaData for the solid
% green image.
set(h, 'AlphaData', 1-(~im2bw(ProbImage)));
%%

%h = imagesc(flo(NewInterpretation));



