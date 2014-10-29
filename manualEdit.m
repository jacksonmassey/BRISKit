function segments = manualEdit(data)

if sum(sum(data.I.tempSeg==1))~=0
    data.I.tempSeg = identifyMaterials(data);
    new_data = get(data.handles.figure,'userdata');
    data.handles = new_data.handles;
end
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

button = 'Yes';
while strcmp('Yes',button)
    selectMore = 'Yes';
    k = 0;
    selectedRegion = false(size(data.I.tempSeg));
    while strcmp('Yes',selectMore)
        k = k+1;
        hFreehands(k) = imfreehand(desiredSide);
        position = wait(hFreehands(k));
        selectedRegion = selectedRegion | roipoly(data.I.tempSeg,position(:,1),position(:,2));
        selectMore = questdlg('Select more of the same material?','Same Material','Yes','No','Yes');
    end
    
    material = chooseMaterial('Select material for user-defined region:');
    if ~isempty(material)
        data.I.tempSeg(selectedRegion) = material;
    end
    for kk=1:k
        delete(hFreehands(kk));
    end
    
    
    %    showOutline(data,data.I.tempSeg);
    
    button = questdlg('Select another region?','Continue','Yes','No','Yes');
end


segments = data.I.tempSeg.*uint16(data.I.mask);
end