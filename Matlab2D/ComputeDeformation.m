function [ Tx Ty ] = ComputeDeformation( I1, I2, MaxIter, NumPyramids, ...
    filterSize, filterSigma, Tolerance, alpha,plotFreq)
% ComputeDeformation: Compute deformation between images using Thirion's
% Demon Algorithm
%   Implementation of Thirion's Demon Algorithm in 2D. Computes the
%   deformation between I2 and I1. There are actually two
%
%
% Parameters:
%   I1: Image 1
%   I2: Image 2
%   MaxIter: Maximum of iterations
%   NumPyramids: Number of pyramids for downsizing
%   filterSize: Size of Gaussian filter used for smoothing deformation grid
%   Tolerance: MSE convergence tolerance
%   alpha: Constant for Extended Demon Force (Cachier 1999). If alpha is 0,
%   run regular Demon force.
%   plotFreq: Number of iterations per plot update. Set to 0 to turn off
%   plotting.
%
% By Lewis Li (lewisli@stanford.edu)
% Jan 26th 2015
%%
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% How much MSE can increase between iterations before terminating
MSETolerance = 1 + Tolerance;
MSEConvergenceCriterion = Tolerance;

% Alpha (noise) constant for Extended Demon Force
alphaInit=alpha;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plotting tools
addpath('freezeColors');

% Pyramid step size
pyStepSize = 1.0/NumPyramids;

% Initial transformation field is smallest possible size
initialScale = 1*pyStepSize;
prevScale=initialScale;
TxPrev = zeros(ceil(size(I1)*initialScale));
TyPrev = zeros(ceil(size(I1)*initialScale));

% Iterate over each pyramid
for pyNum = 1:NumPyramids
    
    scaleFactor = pyNum*pyStepSize;
    
    % Increase size of smoothing filter
    Hsmooth=fspecial('gaussian',filterSize*scaleFactor,filterSigma*scaleFactor);
    
    % Only needed if using extended demon force
    alpha=alphaInit/pyNum;
    
    % Resize images according to pyramid steps
    S = mat2gray(imresize(I2,scaleFactor));
    M = mat2gray(imresize(I1,scaleFactor));
    
    % Compute MSE
    prevMSE = abs(M-S).^2;
    StartingImage = M;
    
    % Histogram match (only available on MATLAB2013b+)
    %M = imhistmatch(M,S);
    
    % The transformation fields for current pyramid is the transformation
    % field at the previous pyramid bilinearly interpolated to current size
    % The magnitudes of the deformations needs to be scaled by the change
    % in scale too.
    Tx=imresize(TxPrev, size(S))*scaleFactor/prevScale;
    Ty=imresize(TyPrev, size(S))*scaleFactor/prevScale;
    
    M=DeformImage(StartingImage,Tx,Ty);
    prevScale = scaleFactor;
    
    [Sy,Sx] = gradient(S);
    
    for itt=1:MaxIter
        
        % Difference image between moving and static image
        Idiff=M-S;
        
        if (alpha == 0)
            % Default demon force, (Thirion 1998)
            Ux = -(Idiff.*Sx)./((Sx.^2+Sy.^2)+Idiff.^2);
            Uy = -(Idiff.*Sy)./((Sx.^2+Sy.^2)+Idiff.^2);
        else
            % Extended demon force. Faster convergence but more unstable.
            % (Cachier 1999, He Wang 2005)
            [My,Mx] = gradient(M);
            Ux = -Idiff.*  ((Sx./((Sx.^2+Sy.^2)+alpha^2*Idiff.^2))+ ...
                (Mx./((Mx.^2+My.^2)+alpha^2*Idiff.^2)));
            Uy = -Idiff.*  ((Sy./((Sx.^2+Sy.^2)+alpha^2*Idiff.^2))+ ...
                (My./((Mx.^2+My.^2)+alpha^2*Idiff.^2)));
        end
        
        % When divided by zero
        Ux(isnan(Ux))=0;
        Uy(isnan(Uy))=0;
        
        % Smooth the transformation field
        Uxs=3*imfilter(Ux,Hsmooth);
        Uys=3*imfilter(Uy,Hsmooth);
        
        % Add the new transformation field to the total transformation field.
        Tx=Tx+Uxs;
        Ty=Ty+Uys;
        
        M=DeformImage(StartingImage,Tx,Ty);
        
        D = abs(M-S).^2;
        MSE = sum(D(:))/numel(S);
        
        
%         % Break if MSE is increasing
%         if (MSE > prevMSE*MSETolerance)
%             display(['Pyramid Level: ' num2str(pyNum) ' Converged after ' ...
%                 num2str(itt) ' iterations.']);
%             break;
%         end
%         
%         % Break if MSE isn't really decreasing much
%         if (abs(prevMSE-MSE)/MSE < MSEConvergenceCriterion)
%             display(['Pyramid Level: ' num2str(pyNum) ' Converged after ' ...
%                 num2str(itt) ' iterations.']);
%             break;
%         end
        
        % Update MSE
        prevMSE = MSE;
        
        if (plotFreq>0)
            if (mod(itt,plotFreq) == 0)
                subplot(2,3,1), imagesc(StartingImage,[0 1]);
                title('image 1');
                colormap gray; colorbar;
                freezeColors;
                subplot(2,3,2), imagesc(S,[0 1]); title('image 2');
                colormap gray; colorbar;
                freezeColors;
                subplot(2,3,3), imagesc(M,[0 1]);
                title(['Registered image 1 After Iteration: ' ...
                    num2str(itt)]);
                colormap gray;  colorbar;
                freezeColors;
                subplot(2,3,4), imagesc(Tx);
                colorbar; colormap jet; title('Tx');
                subplot(2,3,5), imagesc(Ty);
                colorbar; colormap jet; title('Ty');
                subplot(2,3,6), imagesc(D,[0 0.1]);
                colorbar; colormap jet; title(['Diff MSE: = ' ...
                    num2str(MSE)]);
                pause(0.1);
            end
            
        end
        
        
    end
    
    % Propogate transformation to next pyramid
    TxPrev = Tx;
    TyPrev = Ty;
end

end

