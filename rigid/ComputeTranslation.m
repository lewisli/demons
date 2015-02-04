function [ row col ] = ComputeTranslation( I1, I2 )
%COMPUTETRANSLATION Summary of this function goes here
%   Detailed explanation goes here

%Fourier transform both images
fi = fft2(double(I1));
fr = fft2(double(I2));

%Perform phase correlation (amplitude is normalized)
fc = fi .* conj(fr);
fcn = fc ./abs(fc);

%Inverse fourier of peak correlation matrix and max location
peak_correlation_matrix = abs(ifft2(fcn));
[peak, idx] = max(peak_correlation_matrix(:));

%Calculate actual translation
[row, col] = ind2sub(size(peak_correlation_matrix),idx);
if row < size(peak_correlation_matrix,1)/2
    row = -(row - 1);
else
    row = size(peak_correlation_matrix,1) - (row - 1);
end;
if col < size(peak_correlation_matrix,2)/2
    col = -(col - 1);
else
    col = size(peak_correlation_matrix,2) - (col - 1);
end

end

