function segments = manualZeros(data)
%Manually edit zero region.
%
%   segments = MANUALZEROS(data) 
%   

if data.handles.nFrames==2
    leftOrRight = questdlg('Manually edit which image?','Pick a Side','Left','Right','Left');
    if strcmp(leftOrRight,'Left')
        % select left side axes to freehand in for colorSegment
        desiredSide = data.handles.axes(1);
    else
        % select right side axes to freehand in for colorSegment
        desiredSide = data.handles.axes(2);
    end
else
    desiredSide = data.handles.axes(1);
end

newSeg = data.I.tempSeg;
button = 'Yes';
while strcmp('Yes',button)
    selectMore = 'Yes';
    k = 1;
    selectedRegion = false(size(data.I.tempSeg));
    while strcmp('Yes',selectMore)
        hFreehands(k) = imfreehand(desiredSide);
        position = wait(hFreehands(k));
        selectedRegion = selectedRegion | roipoly(data.I.tempSeg,position(:,1),position(:,2));
        selectMore = questdlg('Select more of the same material?','Same Material','Yes','No','Yes');
    end
    
    material = chooseMaterial('Select material for user-defined region:');
    if ~isempty(material)
        selectedRegion = selectedRegion & (data.I.seg==255 & data.I.tempSeg == 0);
        newSeg(selectedRegion) = material;
    end
    for kk=1:k
        delete(hFreehands(kk));
    end
    
    button = questdlg('Select another region?','Continue','Yes','No','Yes');
end

segments = newSeg;

end