function [ OutputImage ] = DeformImage3D(StartingImage, Tx, Ty, Tz)
%DeformImage3D Computed deformed image, using the transformation matrices
%   Detailed explanation goes here

% Create interpolation grid
[X Y Z] = meshgrid(0:size(StartingImage,1)-1, 0:size(StartingImage,2)-1, ...
    0:size(StartingImage,3) - 1);

TXNew = X+Tx;
TYNew = Y+Ty;
TZNew = Z+Tz;

% Clamp Ends
TXNew(TXNew<0)=0; 
TYNew(TYNew<0)=0; 
TZNew(TZNew<0)=0;

TXNew(TXNew>(size(StartingImage,1)-1))=size(StartingImage,1)-1;
TYNew(TYNew>(size(StartingImage,2)-1))=size(StartingImage,2)-1;
TZNew(TZNew>(size(StartingImage,3)-1))=size(StartingImage,3)-1;

OutputImage=interp3(X,Y,Z,StartingImage,...
    TXNew,TYNew, TZNew,'cubic');

end