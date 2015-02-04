%% Load Data

close all; clear all;
load('data/SampleData.mat');

[I2Trans row col] = TransformRigid(I1,I2,3);
imagesc(I2Trans);
