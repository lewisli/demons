function [ I2Trans, col, row ] = TransformRigid( I1,I2, NumLevels )
%TRANSFORMRIGID Summary of this function goes here
%   Detailed explanation goes here

addpath('FuzzySegmentation/');

L1 = FuzzySegmentation(I1,NumLevels,0);
MainReflector1 = GetMainReflector(L1,NumLevels);

L2 = FuzzySegmentation(I2,NumLevels,0);
MainReflector2 = GetMainReflector(L2,NumLevels);

[row col] = ComputeTranslation(MainReflector1,MainReflector2);
I2Trans = imtranslate(I2,[-col -row],'FillValue',NaN);

end

