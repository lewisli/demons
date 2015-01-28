function [ Surface ] = Mat2Surface( InputMatrix )
% Mat2Surface Takes a 3D matrix representation of surface and converts into
% surface
%   
%   Lewis Li (lewisli@stanford.edu)
%   Jan 28th 2015

Surface = zeros(size(InputMatrix,1),size(InputMatrix,2));
[r,c,v] = ind2sub(size(InputMatrix),find(InputMatrix > 0));
linearInd = sub2ind(size(Surface), r,c);
Surface(linearInd) = v;

end

