%% Script to generate a fake 3D set of data cubes
close all;
clear all;

ImageSize = [100 100 50];

% Gaussian surface
[ImageA x y] = GenerateSyn3DData(ImageSize,3,20);

% Flat surface
[ImageB x y] = GenerateSyn3DData(ImageSize,0,20);

% For display purposes
figure; subplot(1,2,1);
Surface1 = Mat2Surface(ImageA);
surf(Surface1);
subplot(1,2,2);
Surface2 = Mat2Surface(ImageB);
surf(Surface2);

%% 3D Deformation Calculation
MaxIter = 800;
NumPyramids = 4;
filterSize = 5;
Tolerance = 0.0000001;
alpha = 3.5;
plotFreq = 5;
[Tx Ty Tz] = ComputeDeformation3D(ImageB, ImageA, MaxIter, ...
    NumPyramids,filterSize, Tolerance, alpha, plotFreq);
%%
% Calculate final image
OutputImage = DeformImage3D(ImageB,Tx,Ty,Tz);
OutputSurface = Mat2Surface(OutputImage);
surf(OutputSurface);
