function SelectShift(data, positions, reviewMode)

if nargin==2
    reviewMode = false;
end

% extract selected region
localRegion = positions{1};
row1 = round(localRegion(:,2));
col1 = round(localRegion(:,1));

selectedRegion = roipoly(data.I.tempSeg,col1,row1);
[row_sel col_sel]=find(selectedRegion);

row_actual=[];
col_actual=[];

for g=1:length(row_sel)
    if data.I.tempSeg(row_sel(g), col_sel(g))==data.I.regionOutlined
        row_actual=[row_actual row_sel(g)];
        col_actual=[col_actual col_sel(g)];
    end
end

row_temp=row_actual;
col_temp=col_actual;
while true
    if isempty(row_temp)
        break;
    end
    
    getBoundaries(data, -1, data.I.regionOutlined,false)
    
    if exist('h','var')
        delete(h);
    end
    
       
    hold(data.handles.axes(1), 'on');
    h = scatter(data.handles.axes(1), col_temp, row_temp, 'xm', 'SizeData', 3^2);
    waitforbuttonpress
    input = uint8(get(data.handles.figure,'CurrentCharacter'));
    
    leftArrow = 28;
    rightArrow = 29;
    upArrow = 30;
    downArrow = 31;
    exitKey = 113;
    
    switch input
        case exitKey
            break;
        case upArrow
            row_temp=row_temp-1;
            
        case downArrow
            row_temp=row_temp+1;
            
        case rightArrow
            col_temp=col_temp+1;
            
        case leftArrow
            col_temp=col_temp-1;
    end
end

if exist('h','var')
    delete(h);
end

for p=1:length(row_actual)
    data.I.tempSeg(row_actual(p),col_actual(p)) = 1;
end

data.I.tempSeg(find(data.I.tempSeg==1))=chooseMaterial('');

row2=row_temp;
col2=col_temp;

for q=1:length(row2)
    data.I.tempSeg(row2(q),col2(q))=data.I.regionOutlined;
end

% find new boundaries
if reviewMode
    getBoundaries(data,[],data.I.regionOutlined);
else
    getBoundaries(data,data.I.regionOutlined,-2);
end

fprintf('\tSelectShift Done!\n');
end