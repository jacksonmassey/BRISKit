% outputs parallel vti format with only material IDs

% x -> columns
% y -> rows
% z -> files

gPath = questdlg('Female or Male?','Select Gender','Female','Male','Female');
switch gPath
    case 'Male'
        gFile = 'a_vm';
        gSuff = '';
        % AustinMan data
        left =   152;
        right =  1857;
        top =    105;
        bottom = 1079;
        startZ = 2;
        nZ = 1878;
    case 'Female'
        gFile = 'avf';
        gSuff = 'b';
        % AustinWoman data
        left =   1;
        right =  2048;
        top =    1;
        bottom = 1730;
        startZ = 1;
        nZ = 1730;
    otherwise
        return;
end

segFolder = uigetdir(sprintf('..\\Segments%s\\',gPath),'Segments Folder');
meshFolder = uigetdir('C:\Research - Jackson\Meshes','Mesh Folder Base');
folderName = inputdlg('Input new folder name:  (Warning! Meshes will be overwritten if name is the same.)','Mesh Folder Name');
folderName = folderName{1};
if folderName(end)~='\'  && folderName(end)~='/'
    folderName(end+1) = '\';
end
segFolder = [segFolder '\'];
meshFolder = [ meshFolder '\' folderName ];
mkdir(meshFolder);
disp(meshFolder)
load([segFolder 'inc.mat']);

%-------------------- modified!!!!!!!! ------------------------------------
dXY = 1/3/1000;
dZ = 1/1000;
% skipXY = str2double(inputdlg('XY Resolution (mm):'))/1000;
skipXY = 1/1000; % using 1mm
skipXY = round(skipXY/dXY);
% skipZ = str2double(inputdlg('Z Resolution (mm):'))/1000;
skipZ = 1/1000; % using 1mm
skipZ = round(skipZ/dZ);
% startZ and nZ set above in male/female
% startZ = str2double(inputdlg('startZ (+1000 is in code):'));
% nZ = str2double(inputdlg('nZ (+1000 is in code):'));
%---------------------

blockSize = 48; % number of original slices per block

disp(datestr(now));

% load materials.txt for grayscale values and material names
fidMaterials = fopen('..\BRISKit\MaterialsInp.txt','rt');
k = 1;
tline = fgetl(fidMaterials);
while ischar(tline)
    commaIndex = strfind(tline,',');
    grayValues(k) = str2double(tline(1:commaIndex-1));
    strMaterials{k} = tline(commaIndex+1:end);
    k=k+1;
    tline = fgetl(fidMaterials);
end
fclose(fidMaterials);

% load materialDielectricValues.txt for dielectric values and material names
newData1 = importdata('materialDielectricValues.txt');
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
end
textdata = textdata(4:end);

dielTable = ones(1,256);
condTable = zeros(1,256);
goodGrayValues = false(1,256);
for m=1:length(grayValues)
    ind = -1;
    for k=1:length(textdata)
        if isequal(strMaterials{m},textdata{k})
            ind = k;
            break;
        end
    end
    if ind > 0
        goodGrayValues(grayValues(m)+1) = true;
        dielTable(grayValues(m)+1) = data(ind,2);
        condTable(grayValues(m)+1) = data(ind,1);
    end
end

load([segFolder sprintf('Seg_%s1002%s.mat',gFile,gSuff)]);
segments = imcrop(segments,[left top (right-left+1) (bottom-top+1)]);
[yMax, xMax] = size(segments);
yMult = ceil(yMax/skipXY)*skipXY;
xMult = ceil(xMax/skipXY)*skipXY;
expandSegments = (yMax ~= yMult) || (xMax ~= xMult);

wExtentX0 = 0;
wExtentX1 = length(1:skipXY:xMult);
wExtentY0 = 0;
wExtentY1 = length(1:skipXY:yMult);
wExtentZ0 = 0;
wExtentZ1 = length(startZ:skipZ:nZ);

fidVTIpar = fopen([meshFolder 'vtiPar.pvti'],'w+');
fprintf(fidVTIpar,'<?xml version="1.0"?>\n');
fprintf(fidVTIpar,'<VTKFile type="PImageData" version="0.1" byte_order="LittleEndian">\n');
fprintf(fidVTIpar,'<PImageData WholeExtent="%d %d %d %d %d %d" GhostLevel="0" Origin="0 0 0" Spacing="%f %f %f">\n',...
    wExtentX0,wExtentX1,wExtentY0,wExtentY1,wExtentZ0,wExtentZ1,...
    dXY*skipXY,dXY*skipXY,dZ*skipZ);

fprintf(fidVTIpar,'<PCellData Scalars="MaterialID">\n');
fprintf(fidVTIpar,'<PDataArray type="UInt8" Name="MaterialID" />\n');
fprintf(fidVTIpar,'</PCellData>\n');

extentX0 = 0;
extentX1 = wExtentX1;
extentY0 = 0;
extentY1 = wExtentY1;

% all slices
% for blockZ=1:ceil((nZ-startZ+1)/blockSize)
% just a few blocks
% blockZ=10:14
for blockZ=1:ceil((nZ-startZ+1)/blockSize)
    startBlockZ = (blockZ-1)*blockSize + startZ
    endBlockZ = min(startBlockZ+blockSize-1,nZ)
    extentZ0=(startBlockZ-startZ)/skipZ;
    extentZ1=(startBlockZ-startZ)/skipZ+length(startBlockZ:skipZ:endBlockZ);
    
    fprintf(fidVTIpar,'<Piece Extent="%d %d %d %d %d %d" Source="%s" />\n',...
        extentX0,extentX1,...
        extentY0,extentY1,...
        extentZ0,extentZ1,...
        sprintf('vtiPiece.%d.vti',blockZ));
    
    fidVTIser = fopen([meshFolder sprintf('vtiPiece.%d.vti',blockZ)],'w+');
    fprintf(fidVTIser,'<?xml version="1.0"?>\n');
    fprintf(fidVTIser,'<VTKFile type="ImageData" version="0.1" byte_order="LittleEndian">\n');
    fprintf(fidVTIser,'<ImageData WholeExtent="%d %d %d %d %d %d" Origin="0 0 0" Spacing="%f %f %f">\n',...
        wExtentX0,wExtentX1,wExtentY0,wExtentY1,wExtentZ0,wExtentZ1,...
        dXY*skipXY,dXY*skipXY,dZ*skipZ);
    fprintf(fidVTIser,'<Piece Extent="%d %d %d %d %d %d">\n',...
        extentX0,extentX1,extentY0,extentY1,extentZ0,extentZ1);
    fprintf(fidVTIser,'<CellData Scalars="MaterialID">\n');
    fprintf(fidVTIser,'<DataArray type="UInt8" Name="MaterialID" format="ascii">\n');
    
    for z=startBlockZ:skipZ:endBlockZ
        
        segMatrix = zeros(skipZ,yMult,xMult,'uint16');
        for zi=0:(skipZ-1)
            % checks to see if the remaining slices make full set
            if (z+zi) <= nZ
                filePath = [segFolder sprintf('Seg_%s%04d%s.mat',gFile,z+zi+1000,gSuff)];
                load(filePath);
                segments = imcrop(segments,[left top (right-left+1) (bottom-top+1)]);
                segMatrix(zi+1,1:yMax,1:xMax) = segments;
                %             endZ = z+zi; % for shrinking bottom
                endZ = z+skipZ-1; % for keeping bottom the same height
                
                % check material ids for each slice
                materialIDs = unique(segments)';
                for m=materialIDs
                    if m >= 255
                        fprintf('WARNING: Blob material found in slice %d.  Grayscale ID:  %d\n',z+zi+1000,m);
                    else
                        if ~goodGrayValues(m+1)
                            fprintf('WARNING: Unknown material found in slice %d.  Grayscale ID:  %d\n',z+zi+1000,m);
                            fprintf('\tDielectric used: %f\n\tConductivity used: %f\n',dielTable(m+1),condTable(m+1));
                        end
                    end
                end
            else % not a full set, reduce size of segMatrix
                %            segMatrix = segMatrix(1:zi,:,:); % for shrinking bottom
                break;
            end
        end
        
        % sprintf('Slice at z = %f',(nZ-z)*dZ)
        for y=1:skipXY:yMult
            for x=1:skipXY:xMult
                materialID = mode(double(reshape(segMatrix(:,y:(y+skipXY-1),x:(x+skipXY-1)),1,1,[])));
                fprintf(fidVTIser,'%d ',materialID);
            end
        end
        disp([meshFolder sprintf(' Slice %d done.',z)])
    end
    
    fprintf(fidVTIser,'\n');
    fprintf(fidVTIser,'</DataArray>\n');
    fprintf(fidVTIser,'</CellData>\n');
    fprintf(fidVTIser,'</Piece>\n');
    fprintf(fidVTIser,'</ImageData>\n');
    fprintf(fidVTIser,'</VTKFile>');
    fclose(fidVTIser);
    clear fidVTIser
end
disp(datestr(now));

fprintf(fidVTIpar,'</PImageData>\n');
fprintf(fidVTIpar,'</VTKFile>');

fclose(fidVTIpar);
clear fidVTIpar