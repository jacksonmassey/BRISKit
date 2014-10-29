function segments = selectROI(data)

if strcmp('Yes',questdlg('Mask with existing?','Mask','Yes','No','Yes'))
    data.I.tempSeg = data.I.tempSeg.*uint16(data.I.seg==255);
end


leftOrRight = questdlg('Select regions from which image?','Pick a Side','Left','Right','Left');
if strcmp(leftOrRight,'Left')
    % select left side axes to freehand in for colorSegment
    desiredSide = data.handles.axes(1);
elseif strcmp(leftOrRight,'Right')
    % select right side axes to freehand in for colorSegment
    desiredSide = data.handles.axes(2);
else
    segments = data.I.tempSeg;
    return;
end

segMask = ones(size(data.I.tempSeg),'uint16');
button = 'Yes';
while strcmp('Yes',button)
    hFreehands = imfreehand(desiredSide);
    position = wait(hFreehands);
    delete(hFreehands);
    selectedRegion = uint8(roipoly(segMask,position(:,1),position(:,2)));
    switch questdlg('What is this selection?','Select ROI Action',...
            'Additive','Remove','Additive');
        case 'Remove'
            % remove the selected region from the mask (make black)
            segMask = uint16(segMask & ~selectedRegion);
        case 'Additive'
            % add the selected region to the mask
            segMask = uint16(segMask | selectedRegion);
        otherwise
            % closed, do nothing
    end
    
    showOutline(data,data.I.tempSeg.*segMask);
    
    button = questdlg('Select another region?','Continue','Yes','No','Yes');
end

segments = data.I.tempSeg.*segMask;
end