function segments = morphRegions(data,operation)
%Performs bwmorph to all regions of data.I.tempSeg
%
%   segments = MORPHREGIONS(data,operation)
%   uses the operation parameter as the input for the
%   bwmorph function that is applied to each region.
%   Note:  morphRegions is only additive.

segments = data.I.tempSeg;
regions = unique(data.I.tempSeg)';
if regions(1)==0
    regions = regions(2:end);
end

for r=regions
    segments(bwmorph(segments==r,operation))=r;
end

end