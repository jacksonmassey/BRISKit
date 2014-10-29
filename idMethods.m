function idMethods(command_str)
h = findobj('Tag','briskit');
data = get(h,'userdata');
switch command_str
    
    case 'Init'
        
        [iMat, sMat] = chooseMaterial('Select material 1:');
        if iMat==-2
            set(data.buttons(2),'Visible','off');
        end
        data.materials.iMat1 = iMat;
        data.materials.sMat1 = sMat;
        [iMat, sMat] = chooseMaterial('Select material 2:');
        if iMat==-2
            set(data.buttons(3),'Visible','off');
        end
        data.materials.iMat2 = iMat;
        data.materials.sMat2 = sMat;
        [iMat, sMat] = chooseMaterial('Select material 3:');
        if iMat==-2
            set(data.buttons(4),'Visible','off');
        end
        data.materials.iMat3 = iMat;
        data.materials.sMat3 = sMat;
        
        set(data.menus.editMenu.modeMenu.home,'Checked','off');
        set(data.menus.editMenu.modeMenu.connect,'Checked','off');
        set(data.menus.editMenu.modeMenu.id,'Checked','on');
        set(data.menus.editMenu.modeMenu.review,'Checked','off');
        set(data.buttons(1),'String','Skip',...
            'CallBack','idMethods(''Skip'')');
        % choose material 1
        set(data.buttons(2),'String',data.materials.sMat1,...
            'CallBack','idMethods(''Mat1'')');
        % choose material 2
        set(data.buttons(3),'String',data.materials.sMat2,...
            'CallBack','idMethods(''Mat2'')');
        % choose material 3
        set(data.buttons(4),'String',data.materials.sMat3,...
            'CallBack','idMethods(''Mat3'')');
        set(data.buttons(5),'String','Split',...
            'CallBack','idMethods(''Split'')');
        set(data.buttons(6),'String','Save',...
            'CallBack','idMethods(''Save'')');
        set(data.buttons(7),'String','Stop',...
            'CallBack','idMethods(''Stop'')');
        uniqueReg = unique(data.I.tempSeg)';
        data.materials.currReg = [0 uniqueReg(uniqueReg >= 256)];   % find lowest region over 255 to start from.  also, check that all regions are above 255.
        data = idNext(data);
        
    case 'Skip'
        
        data = idNext(data);
        
    case 'Mat1'
        
        data.I.tempSeg2 = data.I.tempSeg;
        data.I.tempSeg(data.I.tempSeg==data.materials.currReg(1)) = data.materials.iMat1;
        data = idNext(data);
        
    case 'Mat2'
        
        data.I.tempSeg2 = data.I.tempSeg;
        data.I.tempSeg(data.I.tempSeg==data.materials.currReg(1)) = data.materials.iMat2;
        data = idNext(data);
        
    case 'Mat3'
        
        data.I.tempSeg2 = data.I.tempSeg;
        data.I.tempSeg(data.I.tempSeg==data.materials.currReg(1)) = data.materials.iMat3;
        data = idNext(data);
        
    case 'Split'
        
        data.I.regionOutlined = data.materials.currReg(1);
        data.I.tempSeg = splitRegion(data);
        data.materials.currReg(end+1) = max(max(data.I.tempSeg));
        getBoundaries(data,[data.materials.currReg(1) data.materials.currReg(end)],data.materials.currReg(1));
        
        set(data.buttons(2),'String',data.materials.sMat1);
        
    case 'Save'
        
        saveSegments(data);
        
    case 'Stop'
        
        restoreButtons(data);
        
    case 'Next'
        
    otherwise
        
        errordlg('Invalid command_str for idMethods.','Something ain''t right')
        
end
% save data
getBoundaries(data,[],-1);
end

function data = idNext(data)
if length(data.materials.currReg)==1
    idMethods('Stop');
else
    data.materials.currReg = data.materials.currReg(2:end);
    %show outline
    getBoundaries(data,-1,data.materials.currReg(1));
    data = get(data.handles.figure,'UserData');
end
end