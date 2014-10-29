function segments = splitRegion(data)
%UI that lets users split regoins.
%
%   segments = SPLITREGION(data) focuses on the region
%   data.I.tempSeg == data.I.regionOutlined for the
%   user to split into new regions.  The region cannot
%   be expanded beyond its original area.

segments = data.I.tempSeg;
regionMask = data.I.tempSeg==data.I.regionOutlined;
newRegion = false(size(segments));
desiredSide = data.handles.axes(1);
button = 'Yes';
while strcmp('Yes',button)
    hFreehands = imfreehand(desiredSide);
    position = wait(hFreehands);
    delete(hFreehands);
    selectedRegion = roipoly(regionMask,position(:,1),position(:,2));
    switch questdlg('What is this selection?','Select Region Type',...
            'Additive','Remove','Additive');
        case 'Remove'
            % remove the selected region from the mask (make black)
            newRegion = newRegion & ~selectedRegion;
        case 'Additive'
            % add the selected region to the mask
            newRegion = (newRegion | selectedRegion) & regionMask;
        otherwise
            % closed, do nothing
    end
    
    dispMatrix = zeros(size(segments),'uint16');
    dispMatrix(regionMask) = 1;
    dispMatrix(newRegion) = 2;
    getBoundaries(data,-1,dispMatrix);
    
    button = questdlg('Select another region?','Continue','Yes','No','Yes');
end

newRegID = max(max(segments))+1;
if newRegID <= 255
    newRegID = 257;
end
segments(newRegion) = newRegID;
getBoundaries(data,[data.I.regionOutlined newRegID],data.I.regionOutlined);
end