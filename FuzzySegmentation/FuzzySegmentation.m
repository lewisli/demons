function [ L ] = FuzzySegmentation( Input, NumClusters, PlotLevel)
%FUZZYSEGMENTATION Perform Fuzzy Segmentation
%   Segment a sample 2D image into 3 classes using fuzzy c-means algorithm.
%   Note that similar syntax would be used for c-means based segmentation.
%   Originally by: Anton Semechko (a.semechko@gmail.com)
%   Input: Image to segment
%   NumClusters: Number of clusters to segment into
%   PlotLevel: Level of plotting (0:Nothing, 1: Total membership, 2:
%   Individual membership)
%   Modified by: Lewis Li (lewisli@stanford.edu)

im = uint8(round(mat2gray(Input)*256));
im = imadjust(im);
[L,C,U,LUT,H]=FastFCMeans(im,NumClusters); % perform segmentation

size(U)

% Visualize the segmentation
if (PlotLevel>0)
    figure('color','w')
    subplot(1,2,1), imagesc(im)
    set(get(gca,'Title'),'String','ORIGINAL');
    
    Lrgb=zeros([numel(L) 3],'uint8');
    
    for i=1:3
        Lrgb(L(:)==i,i)=255;
    end
    Lrgb=reshape(Lrgb,[size(im) 3]);
    
    subplot(1,2,2), imagesc(Lrgb)
    set(get(gca,'Title'),'String',['FUZZY C-MEANS C= ' num2str(NumClusters)]);
end


% If necessary, you can also unpack the membership functions to produce
% membership maps
if (PlotLevel>1)
    Umap=FM2map(im,U,H);
    figure('color','w')
    for i=1:NumClusters
        subplot(1,3,i), imagesc(Umap(:,:,i))
        ttl=sprintf('Class %d membership map',i);
        set(get(gca,'Title'),'String',ttl)
    end
end

end