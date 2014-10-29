function BoneGrower( data, positions, reviewMode)
%localCompete Summary of this function goes here
%   Detailed explanation goes here

if nargin==2
    reviewMode = false;
end

fprintf('Local Compete:\n\tInitializing...\n');
% compMargin = 0;

% extract important localized region
localRegion = positions{1};
regMin = floor(min(localRegion));   % returned as [x y] or [c r]
regMax = ceil(max(localRegion));    % returned as [x y] or [c r]
localTempSeg = data.I.tempSeg(regMin(2):regMax(2),regMin(1):regMax(1));
localMask = data.I.mask(regMin(2):regMax(2),regMin(1):regMax(1));

localRegion(:,1) = localRegion(:,1)-regMin(1)+1;
localRegion(:,2) = localRegion(:,2)-regMin(2)+1;
localLocked = ~roipoly(localTempSeg,localRegion(:,1),localRegion(:,2)); % | localLocked;  % INCORRECT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

[row, col, regValues] = find(unique(localTempSeg));
regValues = regValues'

[rrow, ccol] = find(localTempSeg == 92); % find the coordinates of bone marrow pixels
ltempseg = localTempSeg;

localLocked = (localTempSeg==0) | localLocked;
localLocked = localLocked | ~localMask; % & localMask;

if reviewMode
    r = find(regValues == data.I.regionOutlined);
else
    r = 1  % DON'T USE THIS
end

    for n = 1:length(regValues)
        if (r ~= n)
            while true
                bwRegion = localTempSeg==regValues(r);
                bwBorders = bwperim(~bwRegion,8) & (localTempSeg == regValues(n)) & ~localLocked & roipoly(localTempSeg, [1 size(localTempSeg, 2) size(localTempSeg, 2) 1], [1 1 size(localTempSeg, 1) size(localTempSeg, 1)]);
                
                % REMOVE POINTS ALONG EDGES!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -- fixed when 34 correct???
                [row, col] = find(bwBorders)     % ALWAYS EMPTY!!!!!!!!!!!!!!!!!! -- temporarily fixed by 54
                if isempty(row)
                    break;
                end
                
                getBoundaries(data, -1, regValues(r),false) 
                % [r c] = find(tempBoundaries == 0);
                
                if exist('h')
                    delete(h);
                end
                
                hold(data.handles.axes(1), 'on');
                h = scatter(data.handles.axes(1), col + regMin(1) - 1,row + regMin(2) - 1, 'xr', 'SizeData', 3^2);%'MarkerSize', 3);
                                               
                waitforbuttonpress
                input = uint8(get(data.handles.figure,'CurrentCharacter'));
                input
                
                %                     28 => leftArrow
                %                     29 => rightArrow
                %                     30 => upArrow
                %                     31 => downArrow
                
                exitKey = 29; % rightArrow
                upArrow = 30;
                downArrow = 31;
                
                if input == exitKey
                    break;
                end
                
                if input == upArrow % - 30 < 0.001
                    for p=1:length(row)
                        localTempSeg(row(p),col(p)) = regValues(r); 
                    end
                elseif  input == downArrow % < 0.001
                    bwRegion = localTempSeg==regValues(n);
                    bwBorders = bwperim(~bwRegion,8) & (localTempSeg == regValues(r)) & ~localLocked & roipoly(localTempSeg, [1 size(localTempSeg, 2) size(localTempSeg, 2) 1], [1 1 size(localTempSeg, 1) size(localTempSeg, 1)]);
                    [row, col] = find(bwBorders);
                    for p=1:length(row)
                        localTempSeg(row(p),col(p)) = regValues(n);
                    end
                end               
                
            end
        end
    end
if exist('h')
    delete(h);
end       

[rowr , colc] = find(localTempSeg == 92); % find the coordinates of updated bone marrow pixels

for yt = 1:length(rowr)
    if ltempseg(rowr(yt),colc(yt)) ~= 92
        localTempSeg(rowr(yt),colc(yt)) = 84;
    end
end

data.I.tempSeg(regMin(2):regMax(2),regMin(1):regMax(1)) = localTempSeg;

fprintf('\tUpdating boundaries...\n');

% find new boundaries
if reviewMode
   getBoundaries(data,[regValues 84],data.I.regionOutlined); % added 84 to include bone cortical
else
    getBoundaries(data,[regValues 84],-2); % added 84 to include bone cortical
end
fprintf('\tDone!\n');
end

