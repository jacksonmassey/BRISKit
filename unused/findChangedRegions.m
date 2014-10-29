function changedRegions = findChangedRegions( data, baseRegion, method )
%changedRegions = findChangedRegions( data, baseRegion )
%   
%   Find all regions that may have been changed by
%   looking at boundaries that the new base region
%   crosses and returning all of those regions.

switch method
    
    case 'lines'
        
        baseBoundary = bwperim(data.I.tempSeg==baseRegion,4);
        newLineRegions = data.I.boundaries(baseBoundary);
        oldLineRegions = data.I.tempSeg(data.I.boundaries==baseRegion);
        changedRegions = unique([newLineRegions oldLineRegions]);
        
    case 'comparison'
        
        diffPixels = data.I.tempSeg~=data.I.tempSeg2;
        changedRegions = unique([data.I.tempSeg(diffPixels) data.I.tempSeg2(diffPixels)]);
        
end

changedRegions = changedRegions(changedRegions>=0);
if(isempty(changedRegions))
    changedRegions = -1;
end

end

