% Script to generate a fake 3D set of data cubes
close all;
ImageSize = [100 100 50];

ImageA = zeros(ImageSize);
ImageB = zeros(ImageSize);

[f x y] = rsgene2D(ImageSize(1),ImageSize(1),5,20);
[f2 x y] = rsgene2D(ImageSize(1),ImageSize(1),5,20);
f2 = f2+f;
surf(x,y,round(f));
figure;
surf(x,y,round(f2));
axis([0 50 0 50 20 40]);
for i = 1:ImageSize(1)
    for j = 1:ImageSize(2)
        
        f(f<-24) = -24;
        f(f>24) = 24;
        f2(f2<-24) = -24;
        f2(f2>24) = 24;
        
        ImageA(i,j,round(f(i,j))+25) = 1;
    end
end

ImageB(:,:,25) = 1;

save('TestData.mat','ImageA','ImageB');
%% 3D Deformation Calculation
[Tx Ty Tz] = ComputeDeformation3D(ImageB, ImageA,x,y);



%%
% Convert back to surface
f3 = Mat2Surface(ImageA);

XTrans = zeros(ImageSize);
YTrans = ones(ImageSize)*10;
ZTrans = zeros(ImageSize)*5;

OutputImage = DeformImage3D(ImageA,XTrans,YTrans,ZTrans);

f4 = Mat2Surface(OutputImage);

figure;
subplot(2,1,1);
surf(x,y,f3);
subplot(2,1,2);
surf(x,y,f4);