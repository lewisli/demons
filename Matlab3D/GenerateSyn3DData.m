function [ OutputImage x y] = GenerateSyn3DData( ImageSize, RMSHeight, Corrlen )
% GenerateSyn3DData Generate a synthetic surface with Gaussian noise and
% put into a cube.
%   Detailed explanation goes here

OutputImage = zeros(ImageSize);
[f x y] = rsgene2D(ImageSize(1),ImageSize(1),RMSHeight,Corrlen);

% Clamp height
MaxHeight = round(ImageSize(3)/2)-1;
f(f<-MaxHeight) = -MaxHeight;
f(f>MaxHeight) = MaxHeight;

for i = 1:ImageSize(1)
    for j = 1:ImageSize(2)
        OutputImage(i,j, round(f(i,j) + ImageSize(3)/2)) = 1;
    end
end

end

