%% Swiggle Line Demo
clear all;
I1 = imread('data/lace1.png');
I2 = imread('data/lace2.png');
[Tx Ty] = ComputeDeformation(I1,I2);

%% Seismic Image Demo
clear all;
load('data/I1.mat');
load('data/I2.mat');
[Tx Ty] = ComputeDeformation(I1,I2);


