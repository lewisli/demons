function [ OutputImage ] = DeformImage( StartingImage, Tx, Ty)
%DeformImage Computed deformed image, using the transformation matrices
%   Default implementatio uses bi-cubic interpolation.\
%   Lewis Li (lewisli@stanford.edu)
%   January 26th 2015

% Create interpolation grid
[X Y] = meshgrid(0:size(StartingImage,1)-1, 0:size(StartingImage,2)-1);

% Transformed coordinates
TXNew = X'+Tx;
TYNew = Y'+Ty;

% Clamp Ends
TXNew(TXNew<0)=0; 
TYNew(TYNew<0)=0; 
TXNew(TXNew>(size(StartingImage,1)-1))=size(StartingImage,1)-1;
TYNew(TYNew>(size(StartingImage,2)-1))=size(StartingImage,2)-1;

% Interpolate
OutputImage=interp2(X,Y,StartingImage',TXNew,TYNew,'cubic');

end

