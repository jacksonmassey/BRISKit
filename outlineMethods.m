function outlineMethods( command_str )
%outlineMethods( command_str )
%   Detailed explanation goes here

data = get(findobj('Tag','briskit'),'userdata');

switch command_str
    
    case 'removeOutline'
        data.I.regionOutlined = -1;
        delete(findobj(data.handles.figure,'type','line'));
        data.handles.plots = [];
        
    case 'outlineAll'
        getBoundaries(data,-1,-2);
        
    case 'outlineSingle'
        % pick single region to outline
        outlineRegion = 72;
        getBoundaries(data,-1,outlineRegion);
        
    case 'outlineUnidentified'
        unIDreg = unique(data.I.tempSeg)';
        unIDreg = unIDreg(unIDreg >= 255);
        getBoundaries(data,-1,[0 unIDreg]);
        
    case 'outlineLocked'
        getBoundaries(data,-1,-2,true);
        
    case 'updateBoundaries'
        getBoundaries(data,[],-2);
        
    case 'userBoundaries'
        if strcmp(get(data.menus.outlineMenu.userBound,'Checked'),'on')
            set(data.menus.outlineMenu.userBound,'Checked','off');
        else
            set(data.menus.outlineMenu.userBound,'Checked','on');
        end
        
    case 'outlineMarkerSize1'
        set(findobj(data.handles.figure,'type','line'),'MarkerSize',1);
        set(data.menus.outlineMenu.markerSizeMenu.s1,'Checked','on');
        set(data.menus.outlineMenu.markerSizeMenu.s2,'Checked','off');
        set(data.menus.outlineMenu.markerSizeMenu.s3,'Checked','off');
        set(data.menus.outlineMenu.markerSizeMenu.s5,'Checked','off');
        
    case 'outlineMarkerSize2'
        set(findobj(data.handles.figure,'type','line'),'MarkerSize',2);
        set(data.menus.outlineMenu.markerSizeMenu.s1,'Checked','off');
        set(data.menus.outlineMenu.markerSizeMenu.s2,'Checked','on');
        set(data.menus.outlineMenu.markerSizeMenu.s3,'Checked','off');
        set(data.menus.outlineMenu.markerSizeMenu.s5,'Checked','off');
        
    case 'outlineMarkerSize3'
        set(findobj(data.handles.figure,'type','line'),'MarkerSize',3);
        set(data.menus.outlineMenu.markerSizeMenu.s1,'Checked','off');
        set(data.menus.outlineMenu.markerSizeMenu.s2,'Checked','off');
        set(data.menus.outlineMenu.markerSizeMenu.s3,'Checked','on');
        set(data.menus.outlineMenu.markerSizeMenu.s5,'Checked','off');
        
    case 'outlineMarkerSize5'
        set(findobj(data.handles.figure,'type','line'),'MarkerSize',5);
        set(data.menus.outlineMenu.markerSizeMenu.s1,'Checked','off');
        set(data.menus.outlineMenu.markerSizeMenu.s2,'Checked','off');
        set(data.menus.outlineMenu.markerSizeMenu.s3,'Checked','off');
        set(data.menus.outlineMenu.markerSizeMenu.s5,'Checked','on');
        
    otherwise
        errordlg('Invalid command_str for outlineMethods.','Something is not correct: Invalid command_str for outlineMethods.')
end
end

