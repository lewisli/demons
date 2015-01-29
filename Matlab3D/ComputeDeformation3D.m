function [ Tx Ty Tz ] = ComputeDeformation3D( I1, I2, MaxIter, ...
    NumPyramids, filterSize, Tolerance, alpha,plotFreq)
% ComputeDeformation: Compute deformation between images using Thirion's
% Demon Algorithm
%   Implementation of Thirion's Demon Algorithm in 3D. Computes the
%   deformation between I2 and I1.
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
% Jan 29th 2015

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% How much MSE can increase between iterations before terminating
MSETolerance = 1 + Tolerance;
MSEConvergenceCriterion = Tolerance;

% Alpha (noise) constant for Extended Demon Force
alphaInit=alpha;

filterInit = filterSize;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Pyramid step size
pyStepSize = 1.0/NumPyramids;

% Initial transformation field is smallest possible size
initialScale = 1*pyStepSize;
prevScale=initialScale;
TxPrev = zeros(ceil(size(I1)*initialScale));
TyPrev = zeros(ceil(size(I1)*initialScale));
TzPrev = zeros(ceil(size(I1)*initialScale));

% Iterate over each pyramid
for pyNum = 1:NumPyramids
    
    scaleFactor = pyNum*pyStepSize;
    filterSize = filterInit*scaleFactor;
    
    CurrentPyramidSize = size(I2)*scaleFactor;
    S = mat2gray(imresize3(I2,CurrentPyramidSize));
    M = mat2gray(imresize3(I1,CurrentPyramidSize));
    
    % Compute MSE
    prevMSE = abs(M-S).^2;
    StartingImage = M;
    
    % Only needed if using extended demon force
    alpha=alphaInit/pyNum;
    
    % The transformation fields for current pyramid is the transformation
    % field at the previous pyramid bilinearly interpolated to current size
    % The magnitudes of the deformations needs to be scaled by the change
    % in scale too.
    Tx=imresize3(TxPrev, size(S))*scaleFactor/prevScale;
    Ty=imresize3(TyPrev, size(S))*scaleFactor/prevScale;
    Tz=imresize3(TzPrev, size(S))*scaleFactor/prevScale;
    
    M=DeformImage3D(StartingImage,Tx,Ty,Tz);
    prevScale = scaleFactor;
    
    [Sx, Sy, Sz] = gradient(S);
    
    for itt=1:MaxIter
        
        % Difference image between moving and static image
        Idiff=M-S;
        
        if (alpha == 0)
            Ux = -(Idiff.*Sx)./((Sx.^2+Sy.^2+Sz.^2)+Idiff.^2);
            Uy = -(Idiff.*Sy)./((Sx.^2+Sy.^2+Sz.^2)+Idiff.^2);
            Uz = -(Idiff.*Sz)./((Sx.^2+Sy.^2+Sz.^2)+Idiff.^2);
        else
            % Extended demon force
            [Mx My Mz] = gradient(M);
            Ux = -Idiff.*  ((Sx./((Sx.^2+Sy.^2+Sz.^2)+alpha^2*Idiff.^2))+ ...
                (Mx./((Mx.^2+My.^2+Mz.^2)+alpha^2*Idiff.^2)));
            Uy = -Idiff.*  ((Sy./((Sx.^2+Sy.^2+Sz.^2)+alpha^2*Idiff.^2))+ ...
                (My./((Mx.^2+My.^2+Mz.^2)+alpha^2*Idiff.^2)));
            Uz = -Idiff.*  ((Sz./((Sx.^2+Sy.^2+Sz.^2)+alpha^2*Idiff.^2))+ ...
                (Mz./((Mx.^2+My.^2+Mz.^2)+alpha^2*Idiff.^2)));
        end
        
        % When divided by zero
        Ux(isnan(Ux))=0;
        Uy(isnan(Uy))=0;
        Uz(isnan(Uz))=0;
        
        % Smooth the transformation field
        Uxs=3*imgaussian(Ux,filterSize);
        Uys=3*imgaussian(Uy,filterSize);
        Uzs=3*imgaussian(Uz,filterSize);
        
        
        % Add the new transformation field to the total transformation field.
        Tx=Tx+Uxs;
        Ty=Ty+Uys;
        Tz=Tz+Uzs;

        M=DeformImage3D(StartingImage,Tx,Ty,Tz);
        D = abs(M-S).^2;
        MSE = sum(D(:))/numel(S);
        
        % Break if MSE is increasing
        if (MSE > prevMSE*MSETolerance)
            display(['Pyramid Level: ' num2str(pyNum) ' Converged after ' ...
                num2str(itt) ' iterations.']);
            break;
        end
        
        % Break if MSE isn't really decreasing much
        if (abs(prevMSE-MSE)/MSE < MSEConvergenceCriterion)
            display(['Pyramid Level: ' num2str(pyNum) ' Converged after ' ...
                num2str(itt) ' iterations.']);
            break;
        end
        
        % Update MSE
        prevMSE = MSE;
        
        if (mod(itt,plotFreq) == 0)
            N = size(StartingImage,1);
            rL = size(StartingImage,1);
            
            x = linspace(-rL/2,rL/2,N); y = linspace(-rL/2,rL/2,N);
            
            subplot(2,1,1);
            axis([0 50 0 50 20 40]);
            surf(x,y,Mat2Surface(S));
            subplot(2,1,2);
            axis([0 50 0 50 20 40]);
            surf(x,y,Mat2Surface(M));
            title(['Pyramid: ' num2str(scaleFactor) '. After ' ...
                num2str(itt) ' iterations. MSE = ' num2str(MSE)]);
            pause(0.1);
        end
    end
    
    % Propogate transformation to next pyramid
    TxPrev = Tx;
    TyPrev = Ty;
    TzPrev = Tz;
end


end