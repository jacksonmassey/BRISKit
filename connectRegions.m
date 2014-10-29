function connectRegions(command_str)
%connectRegions(command_str)

h = findobj('Tag','briskit');
data = get(h,'userdata');

switch command_str
    
    case 'Init'
        
        setButtons(data);
        getBoundaries(data,-1,-2);
        
    case 'Connect'
        
        data.I.tempSeg2 = data.I.tempSeg;
        button = 'Yes';
        k=0;
        while strcmp('Yes',button)
            k=k+1;
            hFreehands(k) = imfreehand(data.handles.axes(1),'Closed',false);
            position = wait(hFreehands(k));
            position = interpolate(position);
            regions = zeros(1,length(position(:,1)),'uint16');
            for p=1:length(regions)
                regions(p) = data.I.tempSeg(uint16(position(p,2)),uint16(position(p,1)));
            end
            regions = unique(regions);
            for r=2:length(regions)
                data.I.tempSeg(data.I.tempSeg==regions(r)) = regions(1);
            end
            getBoundaries(data,regions,-1);
            button = questdlg('Connect another region?','Continue','Yes','No','Yes');
        end
        for kk=1:k
            delete(hFreehands(kk));
        end
        getBoundaries(data,-1,-2);
        
    case 'GlobalCompete'
        
        data.I.tempSeg2 = data.I.tempSeg;
        competeRegions(data,0,5);
        
    case 'LocalCompete'
        
        data.I.tempSeg2 = data.I.tempSeg;
        fprintf('Select local region for competition.../n');
        k=1;
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        fprintf('Select first region''s mean.../n');
        k=k+1;
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        fprintf('Select second region''s mean.../n');
        button = 'Yes';
        while strcmp('Yes',button)
            k=k+1;
            hFreehands(k) = imfreehand(data.handles.axes(1));
            position{k} = wait(hFreehands(k));
            button = questdlg('Select mean for another region?','Continue','Yes','No','Yes');
        end
        for kk=1:k
            delete(hFreehands(kk));
        end
        localCompete(data, position);
        
    case 'PlantSeed'
        
        data.I.tempSeg2 = data.I.tempSeg;
        fprintf('Plant seed..../n');
        plantSeed(data);
        
    case 'BoundaryAdjust'
        
        data.I.tempSeg2 = data.I.tempSeg;
        BoundaryAdjust(data);
        
    case 'setVoid'
        
        button = 'Yes';
        while strcmp(button,'Yes')
            hpoint = impoint(data.handles.axes);
            position = round(wait(hpoint));   % [column row]
            if data.I.tempSeg(position(2),position(1)) == 0
                newRegion = bwselect(data.I.tempSeg==0,position(1),position(2),4);
                newID = max(max(data.I.tempSeg))+1;
                if newID <= 256
                    newID = 257;
                end
                data.I.tempSeg(newRegion) = newID;
            end
            delete(hpoint);
            button = questdlg('Select another void region?','Set Void','Yes','No','No');
        end
        getBoundaries(data,[],-2);
        
    case 'Lock'
        
        button = 'Yes';
        while strcmp(button,'Yes')
            getBoundaries(data,-1,-2,true);
            hpoint = impoint(data.handles.axes);
            position = round(wait(hpoint));   % [column row]
            data.I.locked(bwselect(data.I.tempSeg==data.I.tempSeg(position(2),position(1)),position(1),position(2),4)) = ~data.I.locked(position(2),position(1));
            delete(hpoint);
            button = questdlg('Select another region to lock?','Set Lock','Yes','No','Yes');
        end
        getBoundaries(data,[],-2);
        
    otherwise
        
        errordlg('Invalid command_str for connectMode.','Something ain''t right')
end
end

function setButtons(data)
% need to figure out button names....
%     connect
%     outline void
%     plant seed
%     claim?
%     global compete
%     local compete
%     save
set(data.menus.editMenu.modeMenu.home,'Checked','off');
set(data.menus.editMenu.modeMenu.connect,'Checked','on');
set(data.menus.editMenu.modeMenu.id,'Checked','off');
set(data.menus.editMenu.modeMenu.review,'Checked','off');
set(data.buttons(1),'String','Connect','Visible','on',...
    'Enable','on','CallBack','connectRegions(''Connect'')','Interruptible','off');
set(data.buttons(2),'String','Lock','Visible','on',...
    'Enable','on','CallBack','connectRegions(''Lock'')','Interruptible','on');
set(data.buttons(3),'String','Set Void','Visible','on',...
    'Enable','on','CallBack','connectRegions(''setVoid'')','Interruptible','off');
set(data.buttons(4),'String','Plant Seed','Visible','on',...
    'Enable','on','CallBack','connectRegions(''PlantSeed'')','Interruptible','off');
set(data.buttons(5),'String','Global Compete','Visible','on',...
    'Enable','on','CallBack','connectRegions(''GlobalCompete'')','Interruptible','off');
set(data.buttons(6),'String','Local Compete','Visible','on',...
    'Enable','on','CallBack','connectRegions(''LocalCompete'')','Interruptible','off');
set(data.buttons(7),'String','Adjust Size','Visible','on',...
    'Enable','on','CallBack','connectRegions(''BoundaryAdjust'')','Interruptible','off');

end