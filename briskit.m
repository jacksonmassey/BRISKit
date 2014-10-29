function handle = briskit(command_str, arg1, arg2)
% BRISKit - Boundary and Region Identification Software Kit
% command_str - instructions for the function
% arg1 - image, or struct with pname fname
% arg2 - segmented image, or struct with pname fname

if nargin == 0
    handle = briskitInit();
    return;
end

data = get(findobj('Tag','briskit'),'UserData');

if strcmp(command_str,'Outline')
    % Outline button has been pushed.
    if strcmp(get(data.buttons(2),'String'),'Show Outline')
        getBoundaries(data,-1,-2);
    end
    
elseif strcmp(command_str,'Manual')
    data.I.tempSeg2 = data.I.tempSeg;
    data.I.tempSeg = manualEdit(data);
    data.I.regionOutlined = -1;
    set(data.handles.figure,'userdata',data);
    
elseif strcmp(command_str,'Undo')
    undoAns = questdlg('Are you sure you want to undo?','Undo?','Yes','No','Yes');
    if strcmp(undoAns,'Yes')
        temp = data.I.tempSeg;
        data.I.tempSeg = data.I.tempSeg2;
        data.I.tempSeg2 = temp;
        getBoundaries(data,[],-2);
    end
    
elseif strcmp(command_str,'Other')
    % Select ROI button has been pushed.  Use the selectROI to crop
    % the temporary segmented image to only contain valid information.
    % otherOpts = {'Fill in Holes'};
%         'Work with void regions','Change Display','Set Material X to Y',...
%         'Save Color PNG'};
%      
%      if isempty(opt)
%          return;
%      end
     
     opt = 1; % 1 for Fill in Holes
     switch opt
         case 1
             data.I.tempSeg2 = data.I.tempSeg;
             data.I.tempSeg = morphRegions(data,'fill');
             set(data.handles.figure,'userdata',data);
             msgbox('Filled in Holes');
%         case 2
%             data.I.tempSeg2 = data.I.tempSeg;
%             data.I.tempSeg = manualZeros(data);
%             set(data.handles.figure,'userdata',data);
%         case 3
%             briskit('ChangeDisplay');
%         case 4
%             x = chooseMaterial('Material X:');
%             if isempty(x)
%                 return
%             end
%             y = chooseMaterial('Material Y:');
%             % check for cancel and create new region if unknown (=255?) is
%             % selected.
%             if isempty(y)
%                 return
%             end
%             if y == 255
%                 tempMax = max(max(data.I.tempSeg));
%                 if tempMax <= 256
%                     tempMax = 257;
%                 else
%                     tempMax = tempMax + 1;
%                 end
%                 data.I.tempSeg2 = data.I.tempSeg;
%                 data.I.tempSeg(data.I.tempSeg == x) = tempMax;
%             else
%                 data.I.tempSeg2 = data.I.tempSeg;
%                 data.I.tempSeg(data.I.tempSeg==x) = y;
%             end
%             set(data.handles.figure,'userData',data);
%         case 5
%             saveColorPNG(data);
%         otherwise
%             return;
     end
    
elseif strcmp(command_str,'Save')
    saveAns = questdlg('Do you want to save the recent segments to the existing segments?',...
        'Save Segments','Yes','No','Yes');
    if strcmp(saveAns,'Yes')
        %%%%%%%%%%%%%%%%%%% csg 11/28
        data.I.tempSeg2 = data.I.tempSeg;
        data.I.tempSeg = morphRegions(data,'fill');
        set(data.handles.figure,'UserData',data);
        %%%%%%%%%%%%%%%%%%
        saveSegments(data);
    end
    %%%%%%%%%%%csg temp 3/12
    saveAns = questdlg('Do you want to load a new image?','Load New','Yes','No','No');
    if strcmp(saveAns,'Yes')
        briskit();
    end
    %         saveAns = questdlg('Please choose one:','Brisket Menu', 'Go Up','Go Down','Load New','Load New');
    %     switch saveAns
    %         case 'Go Up'
    %             pname = data.I.pathName;
    %             fname = data.I.fileName;
    %             slicenum=str2double(fname(end-length('xxxx.png')+1:end-length('.png')));
    %             fname(end-length('xxxx.png')+1:end-length('.png'))=sprintf('%04d',slicenum-1);
    %             arg1 = struct('pname',pname,'fname',fname);
    %             fname=['Seg_' fname];
    %             fname(end-length('png')+1:end)='mat';
    %             pname=[pname 'Segments\'];
    %             arg2 = struct('pname',pname,'fname',fname);
    %             briskit();
    %         case 'Go Down'
    %             pname = data.I.pathName;
    %             fname = data.I.fileName;
    %             slicenum=str2double(fname(end-length('xxxx.png')+1:end-length('.png')));
    %             fname(end-length('xxxx.png')+1:end-length('.png'))=sprintf('%04d',slicenum+1);
    %             arg1 = struct('pname',pname,'fname',fname);
    %             fname=['Seg_' fname];
    %             fname(end-length('png')+1:end)='mat';
    %             pname=[pname 'Segments/'];
    %             arg2 = struct('pname',pname,'fname',fname);
    %             briskit();
    %         case 'Load New'
    %             briskit();
    %     end
    %%%%%%%%%%%%%%%%%
elseif strcmp(command_str,'SaveColorPNG')
    saveColorPNG(data);
    
elseif strcmp(command_str,'homeMode')
    restoreButtons(data);
    
elseif strcmp(command_str,'connectMode')
    data.I.tempSeg2 = data.I.tempSeg;
    connectRegions('Init');
    data.I.regionOutlined = -1;
    set(data.handles.figure,'userdata',data);
    
else
    errordlg('Invalid command_str for briskit.','Something is not right')
end
end