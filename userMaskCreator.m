function handle = userMaskCreator(command_str)

if nargin==0
    command_str = 'initialize';
end

switch command_str
    case 'initialize'
        handle = initialize();
    case 'prevUser'
        prevUser();
    case 'outlineUser'
        outlineUser();
    case 'nextUser'
        nextUser();
    case 'polygon'
        polygon();
    case 'freehand'
        freehand();
    case 'exclusive'
        exclusiveMode();
    case 'save'
        saveUserMask();
    otherwise
        return;
end
end

function hFig = initialize(imgNum,userMaskNum)
if nargin <= 0
    imgNum = inputdlg('Image slice number (4-digits):','Image Number Prompt');
    imgNum = imgNum{1};
end
if nargin <= 1
    userMaskNum = inputdlg('Image user mask number (4-digits):','User Mask Number Prompt');
    userMaskNum = userMaskNum{1};
end

I_rgb = imread(sprintf('../../body%s/%s%s.png',data.I.gPath,data.I.gFile,imgNum));
I_mask = imread(sprintf('../../body%s/Masks/%s%smask.png',data.I.gPath,data.I.gFile,imgNum)) > 0;
for k=1:3
    I_rgb(:,:,k) = I_rgb(:,:,k) .* uint8(I_mask);
end
if isempty(userMaskNum)
    I_userMask = zeros(size(I_rgb),'uint8');
else
    I_userMask = imread(sprintf('../UserMasks%s/%s%susermasks.png',data.I.gPath,data.I.gFile,userMaskNum));
end

hFig = figure('Toolbar','none',...
    'Menubar','none',...
    'Name',sprintf('User Masks Creator -- avf%susermasks.png -- avf%s.png',userMaskNum,imgNum),...
    'NumberTitle','off',...
    'Tag','userMaskCreator',...
    'IntegerHandle','off',...
    'Renderer','painters',...
    'RendererMode','manual');

imgHeight = 0.95;
imgWidth = 1;
imgY = 1-imgHeight;

% Display image
hIm1 = imshow(I_rgb);
hAx1 = gca;

% Create a scroll panel for image 1
hSp1 = imscrollpanel(hFig,hIm1);
set(hSp1,'Units','normalized',...
    'Position',[0 imgY imgWidth imgHeight])

% Add an Overview tool and Maginfication Box
imoverview(hIm1)
hMagBox = immagbox(hFig,hIm1);
pos = get(hMagBox,'Position');
set(hMagBox,'Position',[0 0 pos(3) pos(4)]);

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
    'String','Previous',...
    'CallBack','userMaskCreator(''prevUser'')');
btnX = btnX+btnWidth+btnGap;

% create the "Show Outline" button
btn2 = uicontrol(hFig,'Style','pushbutton',...
    'Units','normalized',...
    'Position',[btnX btnY btnWidth btnHeight],...
    'String','All Users',...
    'CallBack','userMaskCreator(''outlineUser'')');
btnX = btnX+btnWidth+btnGap;

% create the "ID Review" button
btn3 = uicontrol(hFig,'Style','pushbutton',...
    'Units','normalized',...
    'Position',[btnX btnY btnWidth btnHeight],...
    'String','Next User',...
    'CallBack','userMaskCreator(''nextUser'')');
btnX = btnX+btnWidth+btnGap;

% create the "Adjust Size" button
btn4 = uicontrol(hFig,'Style','pushbutton',...
    'Units','normalized',...
    'Position',[btnX btnY btnWidth btnHeight],...
    'String','Polygon',...
    'CallBack','userMaskCreator(''polygon'')');
btnX = btnX+btnWidth+btnGap;

% create the "Manual" button
btn5 = uicontrol(hFig,'Style','pushbutton',...
    'Units','normalized',...
    'Position',[btnX btnY btnWidth btnHeight],...
    'String','Freehand',...
    'CallBack','userMaskCreator(''freehand'')');
btnX = btnX+btnWidth+btnGap;

% create the "Other" button
btn6 = uicontrol(hFig,'Style','pushbutton',...
    'Units','normalized',...
    'Position',[btnX btnY btnWidth btnHeight],...
    'String','Exclusive - On',...
    'CallBack','userMaskCreator(''exclusive'')');
btnX = btnX+btnWidth+btnGap;

% create the "Save" button
btn7 = uicontrol(hFig,'Style','pushbutton',...
    'Units','normalized',...
    'Position',[btnX btnY btnWidth btnHeight],...
    'String','Save',...
    'CallBack','userMaskCreator(''save'')');

buttons = [ btn1 btn2 btn3 btn4 btn5 btn6 btn7 ];

handles = struct('figure',hFig,'image',hIm1, ...
    'axis',hAx1,'scroll_panel',hSp1,'buttons',buttons);

I = struct('rgb',I_rgb,'imageNumber',str2double(imgNum),...
    'userOutlined',-1,...,
    'userMask',I_userMask,'exclusive',true);

data = struct('handles',handles,'I',I);
set(hFig,'UserData',data);

outlineUser(data,-1);

end

function prevUser()
data = getData();
if data.I.userOutlined == -1
    outlineUser(data,-1);
else
    outlineUser(data,data.I.userOutlined-1);
end
end

function nextUser()
data = getData();
if data.I.userOutlined == 6
    outlineUser(data,6);
else
    outlineUser(data,data.I.userOutlined+1);
end
end

function outlineUser(data,userNumber)
if nargin==0
    data = getData;
    userNumber = listdlg('PromptString',...
        'Select user to outline:',...
        'SelectionMode','single',...
        'ListString',{'All Users','Unclaimed Regions',...
        '1 - User1',...
        '2 - User2',...
        '3 - User3',...
        '4 - User4',...
        '5 - User5',...
        '6 - User6'})-2;
    if isempty(userNumber)
        return;
    end
end

delete(findobj(data.handles.figure,'type','line'));
hold(data.handles.axis,'on');

if userNumber == -1
    [r c] = find(bwperim(data.I.userMask==0,4));
    plot(data.handles.axis,c,r,'or','MarkerSize',2);
    for k=1:6
        [r c] = find(bwperim(data.I.userMask==k,4));
        plot(data.handles.axis,c,r,'sg','MarkerSize',2);
    end
    set(data.handles.buttons(2),'String','All Users');
elseif userNumber == 0
    [r c] = find(bwperim(data.I.userMask==0,4));
    plot(data.handles.axis,c,r,'or','MarkerSize',2);
    set(data.handles.buttons(2),'String','Unclaimed Regions');
else
    [r c] = find(bwperim(data.I.userMask==userNumber,4));
    plot(data.handles.axis,c,r,'sg','MarkerSize',2);
    set(data.handles.buttons(2),'String',sprintf('User %d',userNumber));
end

hold(data.handles.axis,'off');
data.I.userOutlined = userNumber;
setData(data);

end

function polygon()
data = getData();
hPoly = impoly(data.handles.axis);
position = wait(hPoly);

assignRegion(data,position);

delete(hPoly);
end

function freehand()
data = getData();
hFreehand = imfreehand(data.handles.axis);
position = wait(hFreehand);

assignRegion(data,position);

delete(hFreehand);
end

function assignRegion(data,position)
selectedRegion = roipoly(data.I.userMask,position(:,1),position(:,2));

userNumber = listdlg('PromptString',...
    'Select user to outline:',...
    'SelectionMode','single',...
    'ListString',{'1 - User1',...
        '2 - User2',...
        '3 - User3',...
        '4 - User4',...
        '5 - User5',...
        '6 - User6'});
if isempty(userNumber)
    return;
end

data.I.userMask(selectedRegion) = userNumber;

outlineUser(data,data.I.userOutlined);

end

function exclusiveMode()
data = getData();
if data.I.exclusive
    data.I.exclusive = false;
    set(data.handles.buttons(6),'String','Exclusive - Off');
else
    data.I.exclusive = true;
    set(data.handles.buttons(6),'String','Exclusive - On');
end
setData(data);
end

function saveUserMask()
data = getData();
imwrite(data.I.userMask,sprintf('../UserMasks%s/%s%dbusermasks.png',data.I.gPath,data.I.gFile,data.I.imageNumber));   % only works for b!!!!
if strcmp(questdlg('Load next (+1) image?','Load Next','Yes'),'Yes')
    close(data.handles.figure);
    initialize(sprintf('%d',data.I.imageNumber+1),sprintf('%d',data.I.imageNumber))
end
end

function data = getData()
data = get(findobj('Tag','userMaskCreator'),'UserData');
end

function setData(data)
set(data.handles.figure,'UserData',data);
end