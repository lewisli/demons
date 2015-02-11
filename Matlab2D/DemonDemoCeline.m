% Demon Demo for Celine
clear all;
close all;
addpath('../FuzzySegmentation');
load('data/ContinuousTIsForDemon.mat');

TI_IMG1 = mat2gray(Image1_color);
TI_IMG2 = mat2gray(Image2_color);
NumLevels = 5;
L1 = FuzzySegmentation(TI_IMG1,NumLevels,0);
L2 = FuzzySegmentation(TI_IMG2,NumLevels,0);


%%
% Parameters
MaxIter = 300;
NumPyramids = 4;
filterSize = [200 200];
Tolerance = 0;
alpha = 0.45;
plotFreq = 5;
filterSigma = 30;

[Tx Ty] = ComputeDeformation(L1,L2,MaxIter,NumPyramids,filterSize,...
    filterSigma,Tolerance,alpha,plotFreq);
