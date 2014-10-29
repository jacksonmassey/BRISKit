function saveColorPNG(data)
I_seg = uint16(data.I.seg);
regions = unique(I_seg);
regions = regions(regions<255);
if regions(1) == 0
    regions = regions(2:end);
end

% start with mask in rgb
I_PNG = uint8(repmat(data.I.mask,[1 1 3]));  % change this

% go through regions that have been identified
C = makecform('lab2srgb');
l = data.I.lab(:,:,1);
a = data.I.lab(:,:,2);
b = data.I.lab(:,:,3);
for k=1:length(regions)
    region = I_seg==regions(k);
    meanL = mean2(l(region));
    meanA = mean2(a(region));
    meanB = mean2(b(region));
    % convert meanLAB to rgb.
    rgbArray = applycform(uint8([meanL, meanA, meanB]),C);
    I_PNG(repmat(region,[1,1,3])) = reshape(repmat(rgbArray,[sum(sum(region)),1]),[],1);  % change this if not possible
end
imwrite(I_PNG,[ sprintf('../Segments%s/',data.I.gPath) data.I.fileName(1:end-4) 'segc.png'],'bitdepth',8);
end