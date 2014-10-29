function segments = fixConflicts(data,conflicts)
hTemp = figure;
imshow(conflicts);
resolvedConflicts = zeros(size(conflicts),'uint16');
resolveAction = questdlg('Conflicts exist.  What would you like to do?','Action Required',...
    'Use Existing','Use New','Resolve Individually','Resolve Individually');
switch resolveAction
    case 'Use Existing'
        resolvedConflicts = uint16(conflicts).*data.I.seg;
        close(hTemp);
    case 'Use New'
        resolvedConflicts = uint16(conflicts).*data.I.tempSeg;
        close(hTemp);
    case 'Resolve Individually'
        leftOrRight = questdlg('Which side would you like to manually correct?',...
            'Pick a Side','Left','Right','Left');
        if strcmp(leftOrRight,'Right')
            % select left side axes to freehand in for colorSegment
            desiredSide = data.handles.axes(2);
        else
            % select right side axes to freehand in for colorSegment
            desiredSide = data.handles.axes(1);
        end
        
        close(hTemp);
        button = 'Continue';
        while strcmp(button,'Continue')
            hFreehands = imfreehand(desiredSide);
            position = wait(hFreehands);
            selectedRegion = roipoly(conflicts,position(:,1),position(:,2));
            material = chooseMaterial('Select material for user-defined region:');
            if ~isempty(material)
                resolvedConflicts(selectedRegion) = material;
            end
            delete(hFreehands);
            resolvedConflicts = resolvedConflicts.*uint16(conflicts);
            remainingConflicts = resolvedConflicts==0 & conflicts~=0;
            showOutline(data,remainingConflicts);
            
            if sum(sum(remainingConflicts))~=0
                button = questdlg('Conflicts remain.  Select another region?',...
                    'Resolve Conflicts','Continue','Cancel Save','Continue');
            else
                button = questdlg('Conflicts resolved.','Finished!','OK','OK');
            end
        end
end
segments = resolvedConflicts;
end