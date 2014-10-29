function reviewRegions(command_str)


data = get(findobj('Tag','briskit'),'UserData');
switch command_str
    
    case 'Init'
        
        set(data.menus.editMenu.modeMenu.home,'Checked','off');
        set(data.menus.editMenu.modeMenu.connect,'Checked','off');
        set(data.menus.editMenu.modeMenu.id,'Checked','off');
        set(data.menus.editMenu.modeMenu.review,'Checked','on');
        set(data.buttons(1),'String','Prev','Visible','on',...
            'CallBack','reviewRegions(''Prev'')');
        set(data.buttons(2),'Visible','on',...
            'CallBack','reviewRegions(''Select'')');
        set(data.buttons(3),'String','Next','Visible','on',...
            'CallBack','reviewRegions(''Next'')');
        set(data.buttons(4),'String','Local Compete','Visible','on',...
            'CallBack','Methods(''localCompete'')');
%         set(data.buttons(4),'String','Local Compete Smooth','Visible','on',...
%             'CallBack','Methods(''localCompeteSmooth'')');
        set(data.buttons(5),'String','Manual','Visible','on',...
            'CallBack','reviewRegions(''Manual'')','Interruptible','off');
        set(data.buttons(6),'String','Exclusive - On','Visible','on',...
            'CallBack','reviewRegions(''Exclusive'')');
        set(data.buttons(7),'String','Undo','Visible','on',...
            'CallBack','briskit(''Undo'')');
        data.materials.exclusive = true;
        if data.I.userID < 7
            uniqueReg = unique(data.I.tempSeg.*uint16(data.I.userMask==data.I.userID))';
        else
            uniqueReg = unique(data.I.tempSeg)';
        end
        data.materials.currReg = uniqueReg(uniqueReg < 255);
        data.materials.currReg = data.materials.currReg(2:end); % removes zero
        if any(any(data.I.tempSeg>=255))
            data.materials.currReg(end+1) = 255;
        end
        data.materials.ptr = 1;
        data = reviewInc(data,0);
        
    case 'Prev'
        
        data = reviewInc(data,-1);
        
    case 'Next'
        
        data = reviewInc(data,1);
        
    case 'Select'
        
        data = reviewSelected(data);
        
    case 'Split'
        
        tempStr = get(data.buttons(2),'String');
        data.I.regionOutlined = data.materials.currReg(data.materials.ptr);
        data.I.tempSeg = splitRegion(data);
        getBoundaries(data,[],data.materials.currReg(data.materials.ptr));
        data = get(data.handles.figure,'UserData');
        set(data.buttons(2),'String',tempStr);
        
    case 'Manual'
        
        data.I.tempSeg2 = data.I.tempSeg;
        data = reviewManual(data);
        data = reviewInc(data,0);
        
    case 'Exclusive'
        
        if data.materials.exclusive
            data.materials.exclusive = false;
            set(data.buttons(6),'String','Exclusive - Off',...
                'CallBack','reviewRegions(''Exclusive'')');
        else
            data.materials.exclusive = true;
            set(data.buttons(6),'String','Exclusive - On',...
                'CallBack','reviewRegions(''Exclusive'')');
        end
        
    case 'Exit'
        
        button = questdlg('Save new segments?','Save?','Yes','No','Yes');
        if strcmp(button,'Yes')
            %%%%%%%%%%%%%%%%%%%%%%%  csg 11/28
            data.I.tempSeg2 = data.I.tempSeg;
            data.I.tempSeg = morphRegions(data,'fill');
            set(data.handles.figure,'userdata',data);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%
            saveSegments(data);
        end
        button = questdlg('Load new image?','Load?','Yes','No','Yes');
        if strcmp(button,'Yes')
            briskit;
            return;
        else
            restoreButtons(data);
        end
        
    otherwise
        
        errordlg('Invalid command_str for reviewRegions.','Something ain''t right')
        
end
% save data
set(data.handles.figure,'userData',data);
end

function data = reviewSelected(data)
[sel strMat] = chooseMaterial('Select material review:');
ind = find(data.materials.currReg==sel);
if isempty(ind)
    errordlg(sprintf('%s is not in this slice. Please try again.',strMat),'Oops...');
    return
end
data.materials.ptr = ind;
set(data.buttons(2),'String',strMat);
data.I.regionOutlined = data.materials.currReg(data.materials.ptr);
getBoundaries(data,-1,data.materials.currReg(data.materials.ptr));
data = get(data.handles.figure,'UserData');
end

function data = reviewInc(data,inc)
data.materials.ptr = data.materials.ptr + inc;
if length(data.materials.currReg) < data.materials.ptr
    data.materials.ptr = length(data.materials.currReg);
    set(data.buttons(2),'String','End')
elseif data.materials.ptr == 0
    data.materials.ptr = 1;
    set(data.buttons(2),'String','Beginning');
else
    if data.materials.currReg(data.materials.ptr) == 255
        %change buttons(2)
        set(data.buttons(2),'String','Blob');
        %show outline
        uniReg = unique(data.I.tempSeg)';
        uniReg = uniReg(uniReg>=255);
        getBoundaries(data,-1,[0 uniReg]);
    else
        %figure out material
        ind = find(data.materials.Values == data.materials.currReg(data.materials.ptr),1,'first');
        %change buttons(2)
        set(data.buttons(2),'String',data.materials.Materials(ind));
        %show outline
        data.I.regionOutlined = data.materials.currReg(data.materials.ptr);
        getBoundaries(data,-1,data.materials.currReg(data.materials.ptr));
    end
end
data = get(data.handles.figure,'UserData');
end


function data = reviewManual(data)
set(data.buttons(5),'Enable','off');
set(data.buttons(4),'Enable','off');
desiredSide = data.handles.axes(1);
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
    selectedRegion = selectedRegion & ~data.I.locked;
    
    tempSeg = data.I.tempSeg;
    tempSeg2 = data.I.tempSeg2;
    % get most recent version of data to check exclusive (allows for
    % interruptibility)
    h = findobj('Tag','briskit');
    data = get(h,'userdata');
    data.I.tempSeg = tempSeg;
    data.I.tempSeg2 = tempSeg2;
    
    material = chooseMaterial('Select material for user-defined region:');
    if ~isempty(material)
        if material ~= -2
            if data.materials.exclusive && material ~= data.materials.currReg(data.materials.ptr)
                if data.materials.currReg(data.materials.ptr) == 255
                    selectedRegion = selectedRegion & (data.I.tempSeg>=255|(data.I.tempSeg==0 & data.I.mask~=0));
                else
                    selectedRegion = selectedRegion & (data.I.tempSeg == data.materials.currReg(data.materials.ptr));
                end
            end
            data.I.tempSeg(selectedRegion) = material;
        end
    end
    for kk=1:k
        delete(hFreehands(kk));
    end
    
    
%    showOutline(data,data.I.tempSeg);
    %%%%%%%%%%%%%%   csg
   button = 'No';
    % button = questdlg('Select another region?','Continue','Yes','No','Yes');
   
end
set(data.buttons(5),'Enable','on');
set(data.buttons(4),'Enable','on');
data.I.tempSeg = data.I.tempSeg.*uint16(data.I.mask);
getBoundaries(data,[],-1);
data = get(data.handles.figure,'UserData');
end