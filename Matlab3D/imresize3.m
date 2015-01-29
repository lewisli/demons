function [ Output ] = imresize3( I, OutputSize )
%imresize3 Resize a 3D matrix
%   3D version of Matlab's imresize. Defaults to trilinear interpolation
%
% Lewis Li (lewisli@stanford.edu)
% Jan 29th 2015

% Original Size
[InputX, InputY, InputZ] = size(I);

% Output Size
OutputX = OutputSize(1);
OutputY = OutputSize(2);
OutputZ = OutputSize(3);

% Input mesh
[x_in, y_in, z_in] = ndgrid((0:InputX-1)/(InputX-1), ...
    (0:InputY-1)/(InputY-1), (0:InputZ-1)/(InputZ-1));

% Output mesh
[x_out, y_out, z_out] = ndgrid((0:OutputX-1)/(OutputX-1), ...
    (0:OutputY-1)/(OutputY-1), (0:OutputZ-1)/(OutputZ-1));

% Do Interpolation
Output = interp3(y_in, x_in, z_in, I, y_out, x_out, z_out, 'linear');

end

