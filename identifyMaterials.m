function segments = identifyMaterials(data)
newTempSeg = zeros(size(data.I.tempSeg),'uint16');
uniReg = unique(data.I.tempSeg)';
if uniReg(1)==0
    uniReg=uniReg(2:end);
end
k = 1;
while k<length(uniReg)
    data = outlineRegion(data,data.I.tempSeg==uniReg(k));
    selMaterial = chooseMaterial('Select a material for the outlined region');
    if selMaterial == -1
        data.I.regionOutlined = uniReg(k);
        data.I.tempSeg = splitRegion(data);
        uniReg(end+1) = max(max(data.I.tempSeg))
    else
        newTempSeg(data.I.tempSeg==uniReg(k)) = selMaterial;
        k=k+1;
    end
end

button = questdlg('Change any materials by region?','Material Adjustments',...
    'Yes','No','No');
while strcmp(button,'Yes')
    showOutline(data,newTempSeg);
    data = get(data.handles.figure,'userdata');
    hPoint = impoint;
    position = wait(hPoint);
    position = round(position)
    selectedReg = bwselect(newTempSeg == newTempSeg(position(2),position(1)),...
        position(1),position(2),4);
    data = outlineRegion(data,selectedReg);
    newTempSeg(selectedReg) = chooseMaterial('Select a material');
    delete(hPoint);
    button = questdlg('Select another region?','Material Adjustments',...
        'Yes','No','No');
end
segments = newTempSeg;
end

function data = outlineRegion(data,region)
handles = data.handles;
delete(findobj(handles.figure,'type','line'));
nFrames = handles.nFrames;

boundary = bwboundaries(region,4,'holes');
for k=1:nFrames
    hold(handles.axes(k),'on');
    for layer=1:length(boundary)
        if size(boundary{layer},1) > 3
            plot(handles.axes(k),boundary{layer}(:,2),boundary{layer}(:,1),'g');
        else
            plot(handles.axes(k),boundary{layer}(:,2),boundary{layer}(:,1),'xg');
        end
    end
    hold(handles.axes(k),'off');
end

data.handles = handles;
end