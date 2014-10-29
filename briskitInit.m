function handle = briskitInit(filename)
% handle = briskitInit()
% BRISKit - Boundary and Region Identification Software Kit
% BRISKit Initialize methods
if nargin == 0%-----------------------------------------------------------------------------------------
    
    % dialog to select male/female
    genderPath = questdlg('Female or Male?','Select Gender','Female','Male','Female');
    switch genderPath
        case 'Male'
            genderFile = 'a_vm';
        case 'Female'
            genderFile = 'avf';
        otherwise
            return;
    end
    
    %     userID = listdlg('ListString',{'User1','User2','User3','User4','User5','User6','MasterUser'},...
    %         'SelectionMode','single','Name','User Login','PromptString','Select User:',...
    %         'CancelString','Quit');
    
    userID = 7; % hard coded to master user
    if isempty(userID)
        return;
    end
    matNum = inputdlg('Segments slice number (4-digits):','Segments Number Prompt');
    %     matNum = cell(1);
    %     matNum =
    if isempty(matNum)
        errordlg('Feature no longer valid.')
        return;
        %         [fname pname] = uigetfile([folderPath '/Segments/*.mat'],'Select Segmented Image Matrix');
    elseif isempty(matNum{1})
        errordlg('Feature no longer valid.')
        return;
        %         [fname pname] = uigetfile([folderPath '/Segments/*.mat'],'Select Segmented Image Matrix');
    else
        fname = sprintf('Seg_%s%s.mat',genderFile,matNum{1});
        if userID <= 6
            pname = sprintf('../Segments%s/SaveTo6/',genderPath);
        else
            pname = sprintf('../Segments%s/',genderPath);
        end
    end
    arg2 = struct('pname',pname,'fname',fname);
    reply = questdlg('Use the image file corresponding to the selected slice?');
    switch reply
        case 'Yes'
            imgNum = matNum;
        case 'No'
            imgNum = inputdlg('Image slice number (4-digits):','Image Number Prompt');
            fname=sprintf('%s%s.png',genderFile,imgNum{1});
        otherwise
            return;
    end
    fname = sprintf('%s%s.png',genderFile,imgNum{1});
else
    fname=filename;
end
%-------------------------------------------------------------------------
pname = sprintf('../../body%s/',genderPath);
if ~exist([pname fname],'file')
    errordlg(sprintf('%s%s does not exist.\nPlease check slice number and location.',pname,fname),'File Does Not Exist');
    return;
end
pname = sprintf('../../body%s/',genderPath);
arg1 = struct('pname',pname,'fname',fname);
pname = arg1.pname;
fname = arg1.fname;

fname(end-2:end)='mat';
pname = sprintf('../Segments%s/',genderPath);
arg2 = struct('pname',pname,'fname',fname);

titleStr = ['BRISKit -- ',arg2.pname,arg2.fname,' -- ',arg1.fname];
pname = '../';
fname = arg1.fname;
[arg1 I_mask] = readInImage(arg1.pname,arg1.fname);
% uMaskName = sprintf('../UserMasks%s/%s%smask.png',genderPath,genderFile,fname(end-8:end-4));
% I_userMask = imread(uMaskName);
I_userMask = I_mask;

I_userBound = false(size(I_userMask));
for k=1:6
    I_userBound = I_userBound | bwperim(I_userMask==k,4);
end
if isempty(arg2.fname)
    arg2 = zeros(size(I_mask),'uint16');
else
    fileName = sprintf('%sSeg_%s%s.mat',arg2.pname,genderFile,matNum{1});
    matFile = load(fileName);
    segments = matFile.segments;
    arg2 = segments;
end

I_left = arg1;
tempH = findobj('Tag','briskit');
if ~isempty(tempH)
    if nargin > 0
        data = get(tempH,'userData');
        titleStr = data.handles.title;
        clear data
    end
    delete(tempH);
end
if size(I_left,3)==3
    cform = makecform('srgb2lab');
    I_lab = applycform(I_left,cform);
else
    I_lab = [];
end

hFig = figure('Toolbar','none',...
    'Menubar','none',...
    'Name',titleStr,...
    'NumberTitle','off',...
    'Tag','briskit',...
    'IntegerHandle','off',...
    'Renderer','painters',...
    'RendererMode','manual');

imgHeight = 0.95;
imgWidth = 1;
imgY = 1-imgHeight;

% Display image
hIm1 = imshow(I_left);
hAx1 = gca;


% Create a scroll panel for image 1
hSp1 = imscrollpanel(hFig,hIm1);
set(hSp1,'Units','normalized',...
    'Position',[0 imgY imgWidth imgHeight])

% Add an Overview tool and Magnification Box
% imoverview(hIm1)
hMagBox = immagbox(hFig,hIm1);
pos = get(hMagBox,'Position');
set(hMagBox,'Position',[0 0 pos(3) pos(4)]);

% create menus
menu_File = uimenu(hFig,'label','&File');
menu_Edit = uimenu(hFig,'label','Edit');
menu_Outline = uimenu(hFig,'label','Outline');
menu_Inter = uimenu(hFig,'label','&Interpolate');
menu_Help = uimenu(hFig,'label','Help');

% create menu items
menu_File_Open = uimenu(menu_File,'label','Open',...
    'CallBack','briskit()');
menu_File_Save = uimenu(menu_File,'label','&Save',...
    'CallBack','briskit(''Save'')');
% menu_File_SaveAs = uimenu(menu_File,'label','Save As...',...
%     'CallBack','');
menu_File_SavePNG = uimenu(menu_File,'label','Save Copy to PNG',...
    'CallBack','briskit(''SaveColorPNG'')');
menu_File_Certify = uimenu(menu_File,'label','&Certify',...
    'CallBack','certifySlice()');
% menu_File_Exit = uimenu(menu_File,'label','Exit',...
%     'CallBack','');
menu_Edit_Undo = uimenu(menu_Edit,'label','Undo',...
    'CallBack','briskit(''Undo'')');
menu_Edit_Mode = uimenu(menu_Edit,'label','Mode');
menu_Edit_Mode_Home = uimenu(menu_Edit_Mode,'label','Home','Checked','on',...
    'CallBack','briskit(''homeMode'')');
menu_Edit_Mode_Connect = uimenu(menu_Edit_Mode,'label','Connect',...
    'CallBack','briskit(''connectMode'')');
menu_Edit_Mode_ID = uimenu(menu_Edit_Mode,'label','ID Materials',...
    'CallBack','idMethods(''Init'')');
menu_Edit_Mode_Review = uimenu(menu_Edit_Mode,'label','Review',...
    'CallBack','reviewRegions(''Init'')');
menu_Outline_Remove = uimenu(menu_Outline,'label','Remove Outline',...
    'CallBack','outlineMethods(''removeOutline'')');
menu_Outline_All = uimenu(menu_Outline,'label','Outline All Regions',...
    'CallBack','outlineMethods(''outlineAll'')','Separator','on');
menu_Outline_Single = uimenu(menu_Outline,'label','Outline Single Region...',...
    'CallBack','outlineMethods(''outlineSingle'')');
menu_Outline_Unidentified = uimenu(menu_Outline,'label','Outline Unidentified Regions',...
    'CallBack','outlineMethods(''outlineUnidentified'')');
menu_Outline_Locked = uimenu(menu_Outline,'label','Outline Locked Regions',...
    'CallBack','outlineMethods(''outlineLocked'')');
menu_Outline_UserBound = uimenu(menu_Outline,'label','Outline User Boundaries',...
    'CallBack','outlineMethods(''userBoundaries'')');
menu_Outline_Size = uimenu(menu_Outline,'label','Outline Marker Size',...
    'Separator','on');
menu_Outline_Size_1 = uimenu(menu_Outline_Size,'label','1',...
    'CallBack','outlineMethods(''outlineMarkerSize1'')');
menu_Outline_Size_2 = uimenu(menu_Outline_Size,'label','2',...
    'CallBack','outlineMethods(''outlineMarkerSize2'')','Checked','on');
menu_Outline_Size_3 = uimenu(menu_Outline_Size,'label','3',...
    'CallBack','outlineMethods(''outlineMarkerSize3'')');
menu_Outline_Size_5 = uimenu(menu_Outline_Size,'label','5',...
    'CallBack','outlineMethods(''outlineMarkerSize5'')');
menu_UpdateBoundaries = uimenu(menu_Outline,'label','Update Boundaries',...
    'Separator','on','CallBack','outlineMethods(''updateBoundaries'')');
menu_Inter_AddBoneCortical = uimenu(menu_Inter,'label','Add &Bone Cortical',...
    'CallBack','Methods(''addBoneCortical'')');
menu_Inter_Previous = uimenu(menu_Inter,'label','&Previous Material',...
    'CallBack','Methods(''previous'')');
menu_Inter_Next = uimenu(menu_Inter,'label','&Next Material',...
    'CallBack','Methods(''next'')');
menu_Inter_LocalCompete = uimenu(menu_Inter,'label','&Local Compete',...
    'Separator','on','CallBack','Methods(''localCompete'')');
menu_Inter_LocalCompeteSmooth = uimenu(menu_Inter,'label','LocalCompeteSmooth',...
    'CallBack','Methods(''localCompeteSmooth'')');
menu_Inter_LocalCompeteSmoothVer = uimenu(menu_Inter,'label','LocalCompeteSmoothVer',...
    'CallBack','Methods(''localCompeteSmoothVer'')');
menu_Inter_LocalCompeteSmoothHor = uimenu(menu_Inter,'label','LocalCompeteSmoothHor',...
    'CallBack','Methods(''localCompeteSmoothHor'')');
menu_Inter_AdjustSize = uimenu(menu_Inter,'label','&Adjust Size',...
    'CallBack','Methods(''adjustSize'')');
menu_Inter_PrepScriptMale = uimenu(menu_Inter,'label','&Prep Script Male',...
    'CallBack','Methods(''prepScript Male'')');
menu_Inter_PrepScriptFemale = uimenu(menu_Inter,'label','&Prep Script Female',...
    'CallBack','Methods(''prepScript Female'')');
menu_Inter_PrepScriptFemaleReverse = uimenu(menu_Inter,'label','&Prep Script Female Reverse',...
    'CallBack','Methods(''prepScript Female Reverse'')');
menu_Inter_SelectShift = uimenu(menu_Inter,'label','&SelectShift',...
    'CallBack','Methods(''SelectShift'')');
menu_Inter_BoundaryMove = uimenu(menu_Inter,'label','Expand/Contract',...
    'CallBack','Methods(''boundaryMove'')');
menu_Inter_BoundaryMove = uimenu(menu_Inter,'label','BoneGrower',...
    'CallBack','Methods(''BoneGrower'')');
menu_Help_About = uimenu(menu_Help,'label','About');

% create default state for menu_Outline_UserBound
set(menu_Outline_UserBound,'Checked','on');

% create menu structs for referencing
mFile = struct('open',menu_File_Open,'save',menu_File_Save,...
    'savePNG',menu_File_SavePNG,...
    'certify',menu_File_Certify);
mEditMode = struct('home',menu_Edit_Mode_Home,...
    'connect',menu_Edit_Mode_Connect,'id',menu_Edit_Mode_ID,...
    'review',menu_Edit_Mode_Review);
mEdit = struct('undo',menu_Edit_Undo,'mode',menu_Edit_Mode,'modeMenu',mEditMode);
mSize = struct('s1',menu_Outline_Size_1,'s2',menu_Outline_Size_2,...
    's3',menu_Outline_Size_3,'s5',menu_Outline_Size_5);
mOutline = struct('remove',menu_Outline_Remove,'all',menu_Outline_All,...
    'single',menu_Outline_Single,'unidentified',menu_Outline_Unidentified,...
    'markerSize',menu_Outline_Size,'markerSizeMenu',mSize,'userBound',menu_Outline_UserBound,...
    'updateBoundaries',menu_UpdateBoundaries);
mHelp = struct('about',menu_Help_About);
menus = struct('file',menu_File,'fileMenu',mFile,'edit',menu_Edit,...
    'editMenu',mEdit,'outline',menu_Outline,'outlineMenu',mOutline,...
    'help',menu_Help,'helpMenu',mHelp);

% button parameters
tabHeight = 1-imgHeight;
btnN = 7;
btnHeight = 0.03;
btnY = (tabHeight-btnHeight)/2;
btnWidth = 0.1;
btnGap = (1-btnN*btnWidth)/(btnN+1);
btnX = btnGap;

% create the "ID Materials" button
btn1 = uicontrol(hFig,'Style','pushbutton',...
    'Units','normalized',...
    'Position',[btnX btnY btnWidth btnHeight],...
    'String','PrepScript Female Reverse',...
    'CallBack','Methods(''prepScript Female Reverse'')');
btnX = btnX+btnWidth+btnGap;

% create the "Show Outline" button
btn2 = uicontrol(hFig,'Style','pushbutton',...
    'Units','normalized',...
    'Position',[btnX btnY btnWidth btnHeight],...
    'String','Show Outline',...
    'CallBack','briskit(''Outline'')');
btnX = btnX+btnWidth+btnGap;

% create the "ID Review" button
btn3 = uicontrol(hFig,'Style','pushbutton',...
    'Units','normalized',...
    'Position',[btnX btnY btnWidth btnHeight],...
    'String','Review',...
    'CallBack','reviewRegions(''Init'')');
btnX = btnX+btnWidth+btnGap;

% create the "prepScript Male" button
btn4 = uicontrol(hFig,'Style','pushbutton',...
    'Units','normalized',...
    'Position',[btnX btnY btnWidth btnHeight],...
    'String','Prep Script Male',...
    'CallBack','Methods(''prepScript Male'')');
btnX = btnX+btnWidth+btnGap;

% create the "prepScript Female" button
btn5 = uicontrol(hFig,'Style','pushbutton',...
    'Units','normalized',...
    'Position',[btnX btnY btnWidth btnHeight],...
    'String','Prep Script Female',...
    'CallBack','Methods(''prepScript Female'')');
btnX = btnX+btnWidth+btnGap;

% create the "Fill in Holes" button
btn6 = uicontrol(hFig,'Style','pushbutton',...
    'Units','normalized',...
    'Position',[btnX btnY btnWidth btnHeight],...
    'String','Fill in Holes',...
    'CallBack','briskit(''Other'')');
btnX = btnX+btnWidth+btnGap;

% create the "Save" button
btn7 = uicontrol(hFig,'Style','pushbutton',...
    'Units','normalized',...
    'Position',[btnX btnY btnWidth btnHeight],...
    'String','Save',...
    'CallBack','briskit(''Save'')');


imageHandles = hIm1;
axesHandles = hAx1;
spHandles = hSp1;
handles = struct('figure',hFig,'images',imageHandles, ...
    'axes',axesHandles,'scroll_panels',spHandles,'nFrames',1,'title',titleStr);
if ~exist('I_mask','var')
    I_mask = [];
    I_seg = [];
    fname = '';
    pname = '';
else
    if ~exist([pname sprintf('Segments%s',genderPath)],'dir')
        mkdir([pname sprintf('Segments%s',genderPath)]);
    end
    
    I_seg = uint16(zeros(size(I_mask)));
    for k=1:6
        fileName = sprintf('../Segments%s/Seg_%su%d.mat',genderPath,fname(1:end-4),k);
        if exist(fileName,'file')
            load(fileName);
            I_seg = I_seg + segments;
        end
    end
    
end
if ~exist('boundaries','var')
    I_bound = ones(size(I_seg),'int16')*-1;
else
    I_bound = boundaries;
end
if ~exist('locked','var')
    I_locked = zeros(size(I_seg),'uint8');
else
    I_locked = locked;
end
if ~exist('materials','var')
    matTable = [];
else
    matTable = materials;
end
I_tempSeg = arg2;
%be careful with the line below
userID=7;
I = struct('rgb',I_left,'lab',I_lab,'mask',I_mask,'seg',I_seg,...
    'tempSeg',I_tempSeg,'tempSeg2',I_tempSeg,'boundaries',I_bound,...
    'locked',I_locked,'ext',[],'fileName',fname,...
    'pathName',pname,'regionOutlined',-1,'userMask',I_userMask,...
    'userID',userID,'userBound',I_userBound,'gPath',genderPath,'gFile',genderFile);

buttons = [ btn1 btn2 btn3 btn4 btn5 btn6 btn7 ];

% load materials.txt into data.materials
fidMat = fopen('Materials.txt','rt');
k = 1;
grayValues(k) = -1;
strMaterials{k} = 'SPLIT REGION';
k=k+1;
tline = fgetl(fidMat);
while ischar(tline)
    commaIndex = strfind(tline,',');
    grayValues(k) = str2double(tline(1:commaIndex-1));
    strMaterials{k} = tline(commaIndex+1:end);
    k=k+1;
    tline = fgetl(fidMat);
end
fclose(fidMat);

materials = struct('currReg',0,'ptr',1,'sMat1','','iMat1',0,...
    'sMat2','','iMat2',0,'sMat3','','iMat3',0,'matTable',matTable,...
    'Materials',{strMaterials},'Values',grayValues,'exclusive',false);

data = struct('handles',handles,'I',I,'buttons',buttons,'materials',...
    materials,'menus',menus);
set(hFig,'UserData',data);   % store handles for future access.

if max(max(data.I.boundaries)) == -1
    getBoundaries(data,[],-1);
end

api = iptgetapi(hSp1);
ctrlKey = false;
shiftKey = false;

set(hFig,'WindowScrollWheelFcn',@figScroll,...
    'KeyReleaseFcn',@keyRel,...
    'KeyPressFcn',@keyPress,...
    'WindowButtonDownFcn',@mouseDown);

function figScroll(src,evnt)
scrollInc = 30;
if ctrlKey
    zooms = [ 0.1 0.25 0.33 0.5 0.667 0.75 1 1.5 2 3 4 6 8 12 16 24 32 ];
    %api.setVisibleLocation(xmin, ymin)
    %             ptr = get(hFig,'CurrentPoint')
    ptr = get(hFig,'CurrentPoint');
    mag = api.getMagnification();
    r = api.getVisibleImageRect();
    xmin = r(1);
    ymin = r(2);
    width = r(3);
    height = r(4);
    if evnt.VerticalScrollCount > 0 % scrolled down
        kk = 2;
        while mag > zooms(kk)
            kk=kk+1;
        end
        api.setMagnificationAndCenter(zooms(kk-1),xmin+ptr(1)/mag,ymin+height-ptr(2)/mag);
    elseif evnt.VerticalScrollCount < 0 % scrolled up
        kk = length(zooms)-1;
        while mag < zooms(kk)
            kk=kk-1;
        end
        api.setMagnificationAndCenter(zooms(kk+1),xmin+ptr(1)/mag,ymin+height-ptr(2)/mag);
    end
elseif shiftKey
    loc = api.getVisibleLocation();
    if evnt.VerticalScrollCount > 0 % scrolled down
        api.setVisibleLocation(loc(1)+abs(evnt.VerticalScrollCount)*scrollInc,loc(2));
    elseif evnt.VerticalScrollCount < 0 % scrolled up
        api.setVisibleLocation(loc(1)-abs(evnt.VerticalScrollCount)*scrollInc,loc(2));
    end
else
    loc = api.getVisibleLocation();
    if evnt.VerticalScrollCount > 0 % scrolled down
        api.setVisibleLocation(loc(1),loc(2)+abs(evnt.VerticalScrollCount)*scrollInc);
    elseif evnt.VerticalScrollCount < 0 % scrolled up
        api.setVisibleLocation(loc(1),loc(2)-abs(evnt.VerticalScrollCount)*scrollInc);
    end
end
end

function keyPress(src,evnt)
if strcmp(evnt.Key,'control')
    ctrlKey = true;
elseif strcmp(evnt.Key,'shift');
    shiftKey = true;
end
end

function keyRel(src,evnt)
if strcmp(evnt.Key,'control')
    ctrlKey = false;
elseif strcmp(evnt.Key,'shift');
    shiftKey = false;
end
end

function mouseDown(src,evnt)
if strcmp(get(src,'SelectionType'),'alt')
    initPtr = get(hFig,'CurrentPoint');
    initMin = api.getVisibleLocation();
    set(src,'WindowButtonMotionFcn',@mouseMotion);
    set(src,'WindowButtonUpFcn',@mouseUp);
    set(hFig,'Pointer','fleur');
    %             fprintf('mouseDown\n');
end
    function mouseMotion(src,evnt)
        ptr = get(hFig,'CurrentPoint');
        mag = api.getMagnification();
        newMin = initMin - (ptr-initPtr).*[1 -1]/mag;
        %             fprintf('ptr: %d %d\tloc: %f %f\tmag: %f\tnewMin:%f %f\n',ptr(1),ptr(2),initMin(1),initMin(2),mag,newMin(1),newMin(2));
        api.setVisibleLocation(newMin);
    end
    function mouseUp(src,evnt)
        if strcmp(get(src,'SelectionType'),'alt')
            set(src,'WindowButtonMotionFcn','');
            %                 fprintf('mouseUp\n');
            set(hFig,'Pointer','arrow')
        end
    end
end
handle = hFig;
end