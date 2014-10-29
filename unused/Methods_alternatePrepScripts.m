function Methods( command_str, data )
% methods for the items in the Interpolate menu
%   previous
%   next
%   move
%   contract
%   expand
%   localCompete
%   adjustSize

if nargin==1
    data = get(findobj('Tag','briskit'),'userdata');
end

switch command_str
    
    case 'previous'
        reviewRegions('Prev');
        
    case 'next'
        reviewRegions('Next');
        
    case 'move'
        msgbox('not implemented yet');
        
    case 'contract'
        msgbox('not implemented yet');
        
    case 'expand'
        msgbox('not implemented yet');
        
    case 'localCompete'
        set(data.buttons(4),'Enable','off');
        set(data.buttons(5),'Enable','off');
        data.I.tempSeg2 = data.I.tempSeg;
        fprintf('Select local region for competition...\n');
        k=1; % draw boundary for competition
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        fprintf('Select first region''s mean...\n');
        k=k+1; % select first region for competition
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        fprintf('Select second region''s mean...\n');
        button = 'Yes';
        while strcmp('Yes',button)
            k=k+1; % select additional regions for competition
            hFreehands(k) = imfreehand(data.handles.axes(1));
            position{k} = wait(hFreehands(k));
            button = questdlg('Select mean for another region?','Continue','Yes','No','Yes');
        end
        for kk=1:k
            delete(hFreehands(kk));
        end
        set(data.buttons(4),'Enable','on');
        set(data.buttons(5),'Enable','on');
        localCompete(data, position, true);
        
    case 'localCompeteSmooth'
        set(data.buttons(4),'Enable','off');
        set(data.buttons(5),'Enable','off');
        data.I.tempSeg2 = data.I.tempSeg;
        fprintf('Select local region for competition...\n');
        k=1; % draw boundary for competition
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        fprintf('Select first region''s mean...\n');
        k=k+1; % select first region for competition
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        fprintf('Select second region''s mean...\n');
        button = 'Yes';
        while strcmp('Yes',button)
            k=k+1; % select additional regions for competition
            hFreehands(k) = imfreehand(data.handles.axes(1));
            position{k} = wait(hFreehands(k));
            button = questdlg('Select mean for another region?','Continue','Yes','No','Yes');
        end
        for kk=1:k
            delete(hFreehands(kk));
        end
        set(data.buttons(4),'Enable','on');
        set(data.buttons(5),'Enable','on');
        localCompeteSmooth(data, position, true);
        
    case 'localCompeteSmoothVer'
        set(data.buttons(4),'Enable','off');
        set(data.buttons(5),'Enable','off');
        data.I.tempSeg2 = data.I.tempSeg;
        fprintf('Select local region for competition...\n');
        k=1; % draw boundary for competition
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        fprintf('Select first region''s mean...\n');
        k=k+1; % select first region for competition
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        fprintf('Select second region''s mean...\n');
        button = 'Yes';
        while strcmp('Yes',button)
            k=k+1; % select additional regions for competition
            hFreehands(k) = imfreehand(data.handles.axes(1));
            position{k} = wait(hFreehands(k));
            button = questdlg('Select mean for another region?','Continue','Yes','No','Yes');
        end
        for kk=1:k
            delete(hFreehands(kk));
        end
        set(data.buttons(4),'Enable','on');
        set(data.buttons(5),'Enable','on');
        localCompeteSmoothVer(data, position, true);
        
    case 'localCompeteSmoothHor'
        set(data.buttons(4),'Enable','off');
        set(data.buttons(5),'Enable','off');
        data.I.tempSeg2 = data.I.tempSeg;
        fprintf('Select local region for competition...\n');
        k=1; % draw boundary for competition
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        fprintf('Select first region''s mean...\n');
        k=k+1; % select first region for competition
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        fprintf('Select second region''s mean...\n');
        button = 'Yes';
        while strcmp('Yes',button)
            k=k+1; % select additional regions for competition
            hFreehands(k) = imfreehand(data.handles.axes(1));
            position{k} = wait(hFreehands(k));
            button = questdlg('Select mean for another region?','Continue','Yes','No','Yes');
        end
        for kk=1:k
            delete(hFreehands(kk));
        end
        set(data.buttons(4),'Enable','on');
        set(data.buttons(5),'Enable','on');
        localCompeteSmoothHor(data, position, true);
        
    case 'localCompeteSmoothBoundary'
        set(data.buttons(4),'Enable','off');
        set(data.buttons(5),'Enable','off');
        data.I.tempSeg2 = data.I.tempSeg;
        fprintf('Select local region for competition...\n');
        k=1; % draw boundary for competition
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        fprintf('Select first region''s mean...\n');
        k=k+1; % select first region for competition
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        fprintf('Select second region''s mean...\n');
        button = 'Yes';
        while strcmp('Yes',button)
            k=k+1; % select additional regions for competition
            hFreehands(k) = imfreehand(data.handles.axes(1));
            position{k} = wait(hFreehands(k));
            button = questdlg('Select mean for another region?','Continue','Yes','No','Yes');
        end
        for kk=1:k
            delete(hFreehands(kk));
        end
        set(data.buttons(4),'Enable','on');
        set(data.buttons(5),'Enable','on');
        localCompeteSmoothBoundary(data, position, true);
        
    case 'localCompeteSmoothOriginal'
        set(data.buttons(4),'Enable','off');
        set(data.buttons(5),'Enable','off');
        data.I.tempSeg2 = data.I.tempSeg;
        fprintf('Select local region for competition...\n');
        k=1; % draw boundary for competition
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        fprintf('Select first region''s mean...\n');
        k=k+1; % select first region for competition
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        fprintf('Select second region''s mean...\n');
        button = 'Yes';
        while strcmp('Yes',button)
            k=k+1; % select additional regions for competition
            hFreehands(k) = imfreehand(data.handles.axes(1));
            position{k} = wait(hFreehands(k));
            button = questdlg('Select mean for another region?','Continue','Yes','No','Yes');
        end
        for kk=1:k
            delete(hFreehands(kk));
        end
        set(data.buttons(4),'Enable','on');
        set(data.buttons(5),'Enable','on');
        localCompeteSmoothOriginal(data, position, true);
        
    case 'boundaryMove'
        set(data.buttons(4),'Enable','off');
        set(data.buttons(5),'Enable','off');
        %         set(data.buttons(6),'Enable','off');
        data.I.tempSeg2 = data.I.tempSeg;
        fprintf('Select local region for competition...\n');
        k=1;
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        %         fprintf('Select first region''s mean...\n');
        %         k=k+1;
        %         hFreehands(k) = imfreehand(data.handles.axes(1));
        %         position{k} = wait(hFreehands(k));
        %         fprintf('Select second region''s mean...\n');
        %         button = 'Yes';
        %         while strcmp('Yes',button)
        %             k=k+1;
        %             hFreehands(k) = imfreehand(data.handles.axes(1));
        %             position{k} = wait(hFreehands(k));
        %             button = questdlg('Select mean for another region?','Continue','Yes','No','Yes');
        %         end
        for kk=1:k
            delete(hFreehands(kk));
        end
        set(data.buttons(4),'Enable','on');
        set(data.buttons(5),'Enable','on');
        %         set(data.buttons(6),'Enable','on');
        % boundaryCompete(data, position, true, 2);
        boundaryMove(data, position, true);
        
        
        case 'BoneGrower'
        set(data.buttons(4),'Enable','off');
        set(data.buttons(5),'Enable','off');
        %         set(data.buttons(6),'Enable','off');
        data.I.tempSeg2 = data.I.tempSeg;
        fprintf('Select local region for competition...\n');
        k=1;
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        %         fprintf('Select first region''s mean...\n');
        %         k=k+1;
        %         hFreehands(k) = imfreehand(data.handles.axes(1));
        %         position{k} = wait(hFreehands(k));
        %         fprintf('Select second region''s mean...\n');
        %         button = 'Yes';
        %         while strcmp('Yes',button)
        %             k=k+1;
        %             hFreehands(k) = imfreehand(data.handles.axes(1));
        %             position{k} = wait(hFreehands(k));
        %             button = questdlg('Select mean for another region?','Continue','Yes','No','Yes');
        %         end
        for kk=1:k
            delete(hFreehands(kk));
        end
        set(data.buttons(4),'Enable','on');
        set(data.buttons(5),'Enable','on');
        %         set(data.buttons(6),'Enable','on');
        % boundaryCompete(data, position, true, 2);
        BoneGrower(data, position, true);
        
    case 'globalCompete'
        msgbox('not implemented yet');
        
    case 'adjustSize'
%         data.I.tempSeg2 = data.I.tempSeg;
%         oldMask = data.I.mask;
%         I_userMask = data.I.userMask==data.I.userID;
%         data.I.mask = I_userMask.*oldMask;
%         oldTempSeg = data.I.tempSeg;
%         data.I.tempSeg = data.I.tempSeg .* uint16(I_userMask);
%         a=str2num(data.I.fileName(4:7));
%                     data.I.fileName(8)='b';
%                     segName = sprintf('../Segments%s/Seg_%s%da.mat',data.I.gPath,data.I.gFile,a);
%                     maskName = sprintf('../../body%s/Masks/%s%dbmask.png',data.I.gPath,data.I.gFile,a);
%         cform = makecform('srgb2lab');
%             data.I.rgb=imread([sprintf('../../body%s/',data.I.gPath) data.I.fileName]);
%             data.I.lab = applycform(data.I.rgb,cform);
%             Imask = imread(maskName);
%             data.I.mask = Imask(:,:,1)>0;          
%             load(segName); %loads segments matrix from previous slice
%             data.I.tempSeg = segments;
        
        BoundaryAdjust(data,false);
        data = get(data.handles.figure,'UserData');
        data.I.tempSeg = uint16(data.I.mask).*data.I.tempSeg;
        set(data.handles.figure,'UserData',data);
        
        saveSegments(data);
    case 'competeSelect'
        button = 'Yes';
        k = 0;
        regions = uint16(0);
        while strcmp('Yes',button)
            k=k+1;
            hPoint(k) = impoint(data.handles.axes(1));
            position{k} = uint16(round(wait(hPoint(k))));
            button = questdlg('Select another region?','Continue','Yes','No','Yes');
        end
        for kk=1:k
            regions(kk) = data.I.tempSeg(position{kk}(2),position{kk}(1));
            delete(hPoint(kk));
        end
        data.I.tempSeg2 = data.I.tempSeg;
        competeSelect(data, 0, 10, regions);
        
    case 'prepScript Female'
        for k=1:3
            switch k
                case 1 %slice-c, 2 before slice-b
                    a=str2num(data.I.fileName(4:7))-1;
                    data.I.fileName(4:7)=num2str(a);
                    data.I.fileName(8)='c';
                    segName = sprintf('../Segments%s/Seg_%s%db.mat',data.I.gPath,data.I.gFile,a);
                    maskName = sprintf('../../body%s/Masks/%s%dcmask.png',data.I.gPath,data.I.gFile,a);
                case 2 %slice-a, just before slice-b
                    a=str2num(data.I.fileName(4:7))+1;
                    data.I.fileName(4:7)=num2str(a);
                    data.I.fileName(8)='a';
                    segName = sprintf('../Segments%s/Seg_%s%dc.mat',data.I.gPath,data.I.gFile,a-1);
                    maskName = sprintf('../../body%s/Masks/%s%damask.png',data.I.gPath,data.I.gFile,a);
                    
                case 3 %actual slice-b
                    a=str2num(data.I.fileName(4:7));
                    data.I.fileName(8)='b';
                    segName = sprintf('../Segments%s/Seg_%s%da.mat',data.I.gPath,data.I.gFile,a);
                    maskName = sprintf('../../body%s/Masks/%s%dbmask.png',data.I.gPath,data.I.gFile,a);
            end
            cform = makecform('srgb2lab');
            data.I.rgb=imread([sprintf('../../body%s/',data.I.gPath) data.I.fileName]);
            data.I.lab = applycform(data.I.rgb,cform);
            Imask = imread(maskName);
            data.I.mask = Imask(:,:,1)>0;
            
            load(segName); %loads segments matrix from previous slice
            data.I.tempSeg = segments;
            
            %             I_userMask = data.I.userMask==data.I.userID;
            %             data.I.mask = I_userMask.*oldMask;
            %             oldTempSeg = data.I.tempSeg;
            %             data.I.tempSeg = data.I.tempSeg .* uint16(I_userMask);
            
            BoundaryAdjust(data,false);
            data = get(data.handles.figure,'UserData');
            
            %             data.I.tempSeg = data.I.tempSeg + uint16(~I_userMask).*oldTempSeg;
            %             data.I.mask = oldMask;
            
            set(data.handles.figure,'UserData',data);
            
            abc = 1; % 1 for smooth, 2 for regular            
            
             if (abc == 1)
                 data = competeSelectSmooth(data, 0, 3, [28 136],false,false);     % blood vessel, Fat
                 data = competeSelectSmooth(data, 0, 3, [28 220],false,false);     % blood vessel, Tendon
                 data = competeSelectSmooth(data, 0, 3, [180 136],false,false);    % Muscle, Fat
                 data = competeSelectSmooth(data, 0, 3, [180 220],false,false);    % Muscle, Tendon
                 %data = competeSelectSmooth(data, 0, 3, [168 220],false,false);    % lymph, Tendon
                 data = competeSelectSmooth(data, 0, 3, [128 220],false,false);    % lungInflated, Tendon
                 data = competeSelectSmooth(data, 0, 3, [128 60],false,false);    % lungInflated, Heart
                 data = competeSelectSmooth(data, 0, 3, [128 181],false,false);    % lungInflated, Diaphragm
                 data = competeSelectSmooth(data, 0, 3, [108 181],false,false);    % liver, Diaphragm
                 data = competeSelectSmooth(data, 0, 3, [27 60],false,false);    % VentricleAtrium, Heart
                 data = competeSelectSmooth(data, 0, 3, [84 180],false,false);     % boneCortical, Muscle
                 %data = competeSelectSmooth(data, 0, 3, [92 180],false,false);     % boneMarrow, Muscle
                 %data = competeSelectSmooth(data, 0, 3, [84 92],false,false);      % boneCortical, boneMarrow
                 %data = competeSelectSmooth(data, 0, 3, [168 136],false,false);    % lymph, Fat              
                 data = competeSelectSmooth(data, 0, 3, [84 80],false,false);      % boneCortical, CSF
                 data = competeSelectSmooth(data, 0, 3, [184 80],false,false);     % Spinal Cord, CSF
                 %data = competeSelectSmooth(data, 0, 3, [112 92],false,false);     % Cartilage, boneMarrow
             end
            
            if (abc == 2)
                data = competeSelect(data, 0, 2, [28 136],false,false);     % blood vessel, Fat
                data = competeSelect(data, 0, 4, [180 136],false,false);    % Muscle, Fat
                data = competeSelect(data, 0, 3, [84 180],false,false);      % boneCortical, Muscle
                data = competeSelect(data, 0, 3, [84 52],false,false);      % boneCortical, Cerebellum            
            end
            
            saveSegments(data);
        end
        
        msgbox('PrepScript Female done');
        
    case 'prepScript Female Reverse'
        for k=1:3
            switch k
                case 1 %slice-a
                    a=str2num(data.I.fileName(4:7))+1;
                    data.I.fileName(4:7)=num2str(a);
                    data.I.fileName(8)='a';
                    segName = sprintf('../Segments%s/Seg_%s%db.mat',data.I.gPath,data.I.gFile,a);
                    maskName = sprintf('../../body%s/Masks/%s%damask.png',data.I.gPath,data.I.gFile,a);
                case 2 %slice-c
                    a=str2num(data.I.fileName(4:7))-1;
                    data.I.fileName(4:7)=num2str(a);
                    data.I.fileName(8)='c';
                    segName = sprintf('../Segments%s/Seg_%s%da.mat',data.I.gPath,data.I.gFile,a+1);
                    maskName = sprintf('../../body%s/Masks/%s%dcmask.png',data.I.gPath,data.I.gFile,a);
                    
                case 3 %slice-b
                    a=str2num(data.I.fileName(4:7));
                    data.I.fileName(8)='b';
                    segName = sprintf('../Segments%s/Seg_%s%dc.mat',data.I.gPath,data.I.gFile,a);
                    maskName = sprintf('../../body%s/Masks/%s%dbmask.png',data.I.gPath,data.I.gFile,a);
                    
            end
            cform = makecform('srgb2lab');
            data.I.rgb=imread([sprintf('../../body%s/',data.I.gPath) data.I.fileName]);
            data.I.lab = applycform(data.I.rgb,cform);
            Imask = imread(maskName);
            data.I.mask = Imask(:,:,1)>0;
            
            load(segName); %loads segments matrix from previous slice
            data.I.tempSeg = segments;
            
            %             I_userMask = data.I.userMask==data.I.userID;
            %             data.I.mask = I_userMask.*oldMask;
            %             oldTempSeg = data.I.tempSeg;
            %             data.I.tempSeg = data.I.tempSeg .* uint16(I_userMask);
            
            BoundaryAdjust(data,false);
            data = get(data.handles.figure,'UserData');
            
            %             data.I.tempSeg = data.I.tempSeg + uint16(~I_userMask).*oldTempSeg;
            %             data.I.mask = oldMask;
            
            set(data.handles.figure,'UserData',data);
            data = competeSelect(data, 0, 2, [28 136],false,false);     % blood vessel, fat
            %             data = competeSelect(data, 0, 5, [84 28],false,false);     % boneCortical, blood vessel
            data = competeSelect(data, 0, 5, [180 136],false,false);     % muscle, fat
            saveSegments(data);
        end
        
        msgbox('Prep Script Female Reverse done');
        
    case 'SelectShift'
        set(data.buttons(4),'Enable','off');
        set(data.buttons(5),'Enable','off');
        data.I.tempSeg2 = data.I.tempSeg;
        
        k=1;
        hFreehands(k) = imfreehand(data.handles.axes(1));
        position{k} = wait(hFreehands(k));
        for kk=1:k
            delete(hFreehands(kk));
        end
        set(data.buttons(4),'Enable','on');
        set(data.buttons(5),'Enable','on');
        SelectShift(data, position, true);
        
    case 'prepScript Male'
        for k=1:3
            switch k
                case 1 %slice-c, 2 before slice-b
                    a=str2num(data.I.fileName(4:7))-1;
                    data.I.fileName(4:7)=num2str(a);
                    data.I.fileName(8)='c';
                    segName = sprintf('../Segments%s/Seg_%s%db.mat',data.I.gPath,data.I.gFile,a);
                    maskName = sprintf('../../body%s/Masks/%s%dcmask.png',data.I.gPath,data.I.gFile,a);
                case 2 %slice-a, just before slice-b
                    a=str2num(data.I.fileName(4:7))+1;
                    data.I.fileName(4:7)=num2str(a);
                    data.I.fileName(8)='a';
                    segName = sprintf('../Segments%s/Seg_%s%dc.mat',data.I.gPath,data.I.gFile,a-1);
                    maskName = sprintf('../../body%s/Masks/%s%damask.png',data.I.gPath,data.I.gFile,a);
                    
                case 3 %actual slice-b
                    a=str2num(data.I.fileName(4:7));
                    data.I.fileName(8)='b';
                    segName = sprintf('../Segments%s/Seg_%s%da.mat',data.I.gPath,data.I.gFile,a);
                    maskName = sprintf('../../body%s/Masks/%s%dbmask.png',data.I.gPath,data.I.gFile,a);
            end
            cform = makecform('srgb2lab');
            data.I.rgb=imread([sprintf('../../body%s/',data.I.gPath) data.I.fileName]);
            data.I.lab = applycform(data.I.rgb,cform);
            Imask = imread(maskName);
            data.I.mask = Imask(:,:,1)>0;
            
            load(segName); %loads segments matrix from previous slice
            data.I.tempSeg = segments;
            
            %             I_userMask = data.I.userMask==data.I.userID;
            %             data.I.mask = I_userMask.*oldMask;
            %             oldTempSeg = data.I.tempSeg;
            %             data.I.tempSeg = data.I.tempSeg .* uint16(I_userMask);
            
            BoundaryAdjust(data,false);
            data = get(data.handles.figure,'UserData');
            
            %             data.I.tempSeg = data.I.tempSeg + uint16(~I_userMask).*oldTempSeg;
            %             data.I.mask = oldMask;
            
            set(data.handles.figure,'UserData',data);
            
            abc = 1; % 1 for smooth, 2 for regular            
            
             if (abc == 1)
%                  data = competeSelectSmooth(data, 0, 3, [28 136],false,false);     % blood vessel, Fat
%                  data = competeSelectSmooth(data, 0, 3, [28 220],false,false);     % blood vessel, Tendon
%                  data = competeSelectSmooth(data, 0, 3, [180 136],false,false);    % Muscle, Fat
%                  data = competeSelectSmooth(data, 0, 3, [180 220],false,false);    % Muscle, Tendon
%                  %data = competeSelectSmooth(data, 0, 3, [168 220],false,false);    % lymph, Tendon
%                  data = competeSelectSmooth(data, 0, 3, [128 220],false,false);    % lungInflated, Tendon
%                  data = competeSelectSmooth(data, 0, 3, [128 60],false,false);    % lungInflated, Heart
%                  data = competeSelectSmooth(data, 0, 3, [27 60],false,false);    % VentricleAtrium, Heart
%                  data = competeSelectSmooth(data, 0, 3, [84 180],false,false);     % boneCortical, Muscle
%                  %data = competeSelectSmooth(data, 0, 3, [92 180],false,false);     % boneMarrow, Muscle
%                  %data = competeSelectSmooth(data, 0, 3, [84 92],false,false);      % boneCortical, boneMarrow
%                  %data = competeSelectSmooth(data, 0, 3, [168 136],false,false);    % lymph, Fat              
%                  data = competeSelectSmooth(data, 0, 3, [84 80],false,false);      % boneCortical, CSF
%                  data = competeSelectSmooth(data, 0, 3, [184 80],false,false);     % Spinal Cord, CSF
%                  %data = competeSelectSmooth(data, 0, 3, [112 92],false,false);     % Cartilage, boneMarrow
                        
                data = competeSelect(data, 0, 2, [28 136],false,false);     % blood vessel, Fat
                data = competeSelect(data, 0, 2, [28 220],false,false);     % blood vessel, Tendon
                data = competeSelect(data, 0, 2, [180 136],false,false);    % Muscle, Fat
%                 data = competeSelect(data, 0, 3, [84 136],false,false);      % boneCortical, Fat
                data = competeSelect(data, 0, 2, [84 180],false,false);      % boneCortical, Muscle
                data = competeSelectSmooth(data, 0, 2, [180 220],false,false);    % Muscle, Tendon
                data = competeSelectSmooth(data, 0, 3, [92 84],false,false);     % boneMarrow, boneCortical
                data = competeSelectSmooth(data, 0, 2, [4 136],false,false);     % colon, fat
                data = competeSelectSmooth(data, 0, 2, [164 136],false,false);     % small intestine, fat
             end
            
            if (abc == 2)
%                 data = competeSelect(data, 0, 2, [28 136],false,false);     % blood vessel, Fat
%                 data = competeSelect(data, 0, 3, [180 136],false,false);    % Muscle, Fat
%                 data = competeSelect(data, 0, 2, [84 180],false,false);      % boneCortical, Muscle
%                 data = competeSelect(data, 0, 3, [84 52],false,false);      % boneCortical, Cerebellum            
            end
            
            saveSegments(data);
        end
        
        msgbox('PrepScript Female2 done');
        
% % % %         data.I.tempSeg2 = data.I.tempSeg;
% % % %         oldMask = data.I.mask;
% % % %         I_userMask = data.I.userMask==data.I.userID;
% % % %         data.I.mask = I_userMask.*oldMask;
% % % %         oldTempSeg = data.I.tempSeg;
% % % %         data.I.tempSeg = data.I.tempSeg .* uint16(I_userMask);
% % % %         BoundaryAdjust(data,false);
% % % %         data = get(data.handles.figure,'UserData');
% % % %         
% % % %         switch data.I.userID
% % % %             case 1 % victor
% % % %                 data = competeSelect(data, 0, 5, [180 136],false,false);    % muscle, fat
% % % %                 data = competeSelect(data, 0, 5, [28 136],false,false);     % blood vessel, fat
% % % %                 data = competeSelect(data, 0, 5, [28 180],false,false);     % blood vessel, muscle
% % % %                 data = competeSelect(data, 0, 5, [28 218],false,false);     % blood vessel, DarkTendon
% % % %                 data = competeSelect(data, 0, 3, [180 218],false,false);    % muscle, DarkTendon
% % % %                 data = competeSelect(data, 0, 3, [180 84],false,false);     % muscle, boneCortical
% % % %             case 2 % anjali
% % % %                 data = competeSelect(data, 0, 5, [180 136],false,false);    % muscle, fat
% % % %                 data = competeSelect(data, 0, 5, [28 136],false,false);     % blood vessel, fat
% % % %                 data = competeSelect(data, 0, 5, [28 180],false,false);     % blood vessel, muscle
% % % %                 data = competeSelect(data, 0, 5, [28 218],false,false);     % blood vessel, DarkTendon
% % % %                 data = competeSelect(data, 0, 3, [180 218],false,false);    % muscle, DarkTendon
% % % %                 data = competeSelect(data, 0, 3, [180 84],false,false);     % muscle, boneCortical
% % % %             case 3 % helen
% % % %                 data = competeSelect(data, 0, 5, [180 136],false,false);    % muscle, fat
% % % %                 data = competeSelect(data, 0, 5, [28 136],false,false);     % blood vessel, fat
% % % %                 data = competeSelect(data, 0, 5, [28 180],false,false);     % blood vessel, muscle
% % % %                 data = competeSelect(data, 0, 5, [28 218],false,false);     % blood vessel, DarkTendon
% % % %                 data = competeSelect(data, 0, 3, [180 218],false,false);    % muscle, DarkTendon
% % % %             case 4 % kurt
% % % %                 data = competeSelect(data, 0, 5, [180 136],false,false);    % muscle, fat
% % % %                 data = competeSelect(data, 0, 5, [28 136],false,false);     % blood vessel, fat
% % % %                 data = competeSelect(data, 0, 5, [28 180],false,false);     % blood vessel, muscle
% % % %                 data = competeSelect(data, 0, 5, [28 218],false,false);     % blood vessel, DarkTendon
% % % %                 data = competeSelect(data, 0, 3, [180 218],false,false);    % muscle, DarkTendon
% % % %                 data = competeSelect(data, 0, 3, [180 84],false,false);     % muscle, boneCortical
% % % %             case 5 % natcha
% % % %                 data = competeSelect(data, 0, 3, [180 136],false,false);    % muscle, fat
% % % %                 data = competeSelect(data, 0, 3, [28 136],false,false);     % blood vessel, fat
% % % %                 % data = competeSelect(data, 0, 5, [28 180],false,false);     % blood vessel, muscle
% % % %                 % data = competeSelect(data, 0, 5, [28 218],false,false);     % blood vessel, DarkTendon
% % % %                 %                 data = competeSelect(data, 0, 5, [180 218],false,false);    % muscle, DarkTendon
% % % %                 %                 data = competeSelect(data, 0, 3, [180 84],false,false);     % muscle, boneCortical
% % % %             case 6 % simeon
% % % %                 data = competeSelect(data, 0, 5, [180 136],false,false);    % muscle, fat
% % % %                 data = competeSelect(data, 0, 5, [28 136],false,false);     % blood vessel, fat
% % % %                 %data = competeSelect(data, 0, 5, [28 180],false,false);     % blood vessel, muscle
% % % %                 data = competeSelect(data, 0, 5, [28 218],false,false);     % blood vessel, DarkTendon
% % % %                 data = competeSelect(data, 0, 3, [180 218],false,false);    % muscle, DarkTendon
% % % %             otherwise
% % % %                 %         % 28 - blood; 136 - fat; 180 - muscle; 220 - tendon; 104 - lung
% % % %                 data = competeSelect(data, 0, 2, [28 136],false,false);     % blood vessel, Fat
% % % %                 %data = competeSelect(data, 0, 3, [84 12],false,false);      % boneCortical, BrainGreyMatter
% % % % %                 data = competeSelect(data, 0, 3, [84 2],false,false);      % boneCortical, Air
% % % %                 data = competeSelect(data, 0, 4, [180 136],false,false);    % Muscle, Fat
% % % %                 %data = competeSelect(data, 0, 3, [84 136],false,false);      % boneCortical, Fat
% % % %                 data = competeSelect(data, 0, 3, [84 180],false,false);      % boneCortical, Muscle
% % % % %                 data = competeSelect(data, 0, 3, [12 32],false,false);      % BrainGreyMatter, BrainWhiteMatter
% % % % %                 data = competeSelect(data, 0, 2, [92 2],false,false);      % BoneMarrow, Air
% % % %                 data = competeSelectSmooth(data, 0, 3, [180 220],false,false);    % Muscle, Tendon
% % % %         end
% % % %         getBoundaries(data,[],-1);
% % % %         data = get(data.handles.figure,'UserData');
% % % %         data.I.tempSeg = data.I.tempSeg + uint16(~I_userMask).*oldTempSeg;
% % % %         data.I.mask = oldMask;
% % % %         set(data.handles.figure,'UserData',data);
% % % %         msgbox('Prep Script Male done');
        
        
       % case 'prepScriptm'
          % ==================For the slices below 1273=================
%         for k=1:3
%             switch k
%                 case 1 %slice-c, 2 before slice-b
%                     a=str2num(data.I.fileName(4:7))-1;
%                     data.I.fileName(4:7)=num2str(a);
%                     data.I.fileName(8)='c';
%                     segName = sprintf('../Segments%s/Seg_%s%db.mat',data.I.gPath,data.I.gFile,a);
%                     maskName = sprintf('../../body%s/Masks/%s%dcmask.png',data.I.gPath,data.I.gFile,a);
%                 case 2 %slice-a, just before slice-b
%                     a=str2num(data.I.fileName(4:7))+1;
%                     data.I.fileName(4:7)=num2str(a);
%                     data.I.fileName(8)='a';
%                     segName = sprintf('../Segments%s/Seg_%s%dc.mat',data.I.gPath,data.I.gFile,a-1);
%                     maskName = sprintf('../../body%s/Masks/%s%damask.png',data.I.gPath,data.I.gFile,a);
%                     
%                 case 3 %actual slice-b
%                     a=str2num(data.I.fileName(4:7));
%                     data.I.fileName(8)='b';
%                     segName = sprintf('../Segments%s/Seg_%s%da.mat',data.I.gPath,data.I.gFile,a);
%                     maskName = sprintf('../../body%s/Masks/%s%dbmask.png',data.I.gPath,data.I.gFile,a);
%             end
%             cform = makecform('srgb2lab');
%             data.I.rgb=imread([sprintf('../../body%s/',data.I.gPath) data.I.fileName]);
%             data.I.lab = applycform(data.I.rgb,cform);
%             Imask = imread(maskName);
%             data.I.mask = Imask(:,:,1)>0;
            
            
%             load(segName); %loads segments matrix from previous slice
%             data.I.tempSeg = segments;
%             
%             %             I_userMask = data.I.userMask==data.I.userID;
%             %             data.I.mask = I_userMask.*oldMask;
%             %             oldTempSeg = data.I.tempSeg;
%             %             data.I.tempSeg = data.I.tempSeg .* uint16(I_userMask);
%             
%             BoundaryAdjust(data,false);
%             data = get(data.handles.figure,'UserData');
%             
%             %             data.I.tempSeg = data.I.tempSeg + uint16(~I_userMask).*oldTempSeg;
%             %             data.I.mask = oldMask;
%             
%             set(data.handles.figure,'UserData',data);
%             
%             abc = 1; % 1 for smooth, 2 for regular
%             
%             % ==================For the slices below 1273=================
%             if (abc == 1)
%                 data = competeSelect(data, 0, 2, [28 136],false,false);     % blood vessel, Fat
%                 data = competeSelectSmooth(data, 0, 3, [168 136],false,false);    % Lymph, Fat
%                 data = competeSelectSmooth(data, 0, 3, [28 220],false,false);     % blood vessel, Tendon
%                 data = competeSelectSmooth(data, 0, 3, [180 136],false,false);    % Muscle, Fat
%                 data = competeSelectSmooth(data, 0, 3, [180 220],false,false);    % Muscle, Tendon
%                 data = competeSelectSmooth(data, 0, 3, [92 220],false,false);    % boneMarrow, Tendon
%                 data = competeSelectSmooth(data, 0, 3, [84 220],false,false);    % boneCortical, Tendon
%                 data = competeSelectSmooth(data, 0, 3, [84 180],false,false);     % boneCortical, Muscle
%                 data = competeSelectSmooth(data, 0, 3, [92 180],false,false);     % boneMarrow, Muscle
%                  data = competeSelectSmooth(data, 0, 3, [84 92],false,false);      % boneCortical, boneMarrow       
%                 data = competeSelectSmooth(data, 0, 3, [84 28],false,false);      % boneCortical, blood vessel
%                 data = competeSelectSmooth(data, 0, 3, [152 28],false,false);     % Gland, blood vessel
%                 data = competeSelectSmooth(data, 0, 3, [84 80],false,false);      % boneCortical, CSF
%                 data = competeSelectSmooth(data, 0, 3, [184 80],false,false);     % Spinal Cord, CSF
%                 data = competeSelectSmooth(data, 0, 3, [84 112],false,false);    % boneCortical, Cartilage
%                 data = competeSelectSmooth(data, 0, 3, [220 112],false,false);    % Tendon, Cartilage
%             end
%             
%             if (abc == 2)
% 
%             end
%             % ==================For the slices below 1273=================
%             saveSegments(data);
%         end
%         
%         msgbox('PrepScriptm done'); 
       
              
    otherwise
        errordlg('Invalid command_str for Methods.','Something is not right')
end
end