function [ Tx Ty Tz ] = ComputeDeformation3D( I1, I2,x,y )

scaleFactor = 1;

S = mat2gray(imresize(I2,scaleFactor));
M = mat2gray(imresize(I1,scaleFactor));
StartingImage = M;
[Sx, Sy, Sz] = gradient(S);

alpha = 0.25;

Tx = zeros(size(I1));
Ty = zeros(size(I1));
Tz = zeros(size(I1));

figure;
for itt = 1:1500
    
    Idiff = M - S;
    
    % Default demon force, (Thirion 1998)
%     Ux = -(Idiff.*Sx)./((Sx.^2+Sy.^2+Sz.^2)+Idiff.^2);
%     Uy = -(Idiff.*Sy)./((Sx.^2+Sy.^2+Sz.^2)+Idiff.^2);
%     Uz = -(Idiff.*Sz)./((Sx.^2+Sy.^2+Sz.^2)+Idiff.^2);
    
    % Extended demon force
    [Mx My Mz] = gradient(M);
    Ux = -Idiff.*  ((Sx./((Sx.^2+Sy.^2+Sz.^2)+alpha^2*Idiff.^2))+ ...
        (Mx./((Mx.^2+My.^2+Mz.^2)+alpha^2*Idiff.^2)));
    
    Uy = -Idiff.*  ((Sy./((Sx.^2+Sy.^2+Sz.^2)+alpha^2*Idiff.^2))+ ...
        (My./((Mx.^2+My.^2+Mz.^2)+alpha^2*Idiff.^2)));
    
    Uz = -Idiff.*  ((Sz./((Sx.^2+Sy.^2+Sz.^2)+alpha^2*Idiff.^2))+ ...
        (Mz./((Mx.^2+My.^2+Mz.^2)+alpha^2*Idiff.^2)));
    
    % When divided by zero
    Ux(isnan(Ux))=0;
    Uy(isnan(Uy))=0;
    Uz(isnan(Uz))=0;
    
    % Smooth the transformation field
    Uxs=3*imgaussian(Ux,10);
    Uys=3*imgaussian(Uy,10);
    Uzs=3*imgaussian(Uz,10);
    
    % Add the new transformation field to the total transformation field.
    Tx=Tx+Uxs;
    Ty=Ty+Uys;
    Tz=Tz+Uzs;
    
    M=DeformImage3D(StartingImage,Tx,Ty,Tz);
    D = abs(M-S).^2;
    MSE = sum(D(:))/numel(S);
    
    if (mod(itt,2) == 0)
        subplot(2,1,1);
        axis([0 50 0 50 20 40]);
        surf(x,y,Mat2Surface(I2));
        subplot(2,1,2);
        axis([0 50 0 50 20 40]);
        surf(x,y,Mat2Surface(M));
        title(['After ' num2str(itt) ' iterations. MSE = ' num2str(MSE)]);
        pause(0.1);
    end
    
    
    
end





end