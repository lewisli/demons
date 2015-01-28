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

