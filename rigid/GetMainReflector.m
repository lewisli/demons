function [ MainReflector ] = GetMainReflector( L, Level )
%GetMainReflector Summary of this function goes here
%   Detailed explanation goes here

LevelMembers = zeros(size(L));
LevelMembers(L==Level) = 1 ;
c = bwconncomp(LevelMembers);

numOfPixels = cellfun(@numel,c.PixelIdxList);
[unused,indexOfMax] = max(numOfPixels);
Highlighted = LevelMembers;
Highlighted( c.PixelIdxList{indexOfMax} ) = Level-1;

MainReflector = Highlighted;
MainReflector(MainReflector<(Level-1)) = 0;

end

