function boundaryMove( data, positions, reviewMode)
%localCompete Summary of this function goes here
%   Detailed explanation goes here

if nargin==2
    reviewMode = false;
end

% if nargin < 4
%     nIter = -1;
% end

fprintf('Local Compete:\n\tInitializing...\n');
% compMargin = 0;

% extract important localized region
localRegion = positions{1};
regMin = floor(min(localRegion));   % returned as [x y] or [c r]
regMax = ceil(max(localRegion));    % returned as [x y] or [c r]
localTempSeg = data.I.tempSeg(regMin(2):regMax(2),regMin(1):regMax(1));
% localLAB = data.I.lab(regMin(2):regMax(2),regMin(1):regMax(1),:);
%localLocked = data.I.locked(regMin(2):regMax(2),regMin(1):regMax(1));
localMask = data.I.mask(regMin(2):regMax(2),regMin(1):regMax(1));

% shift positions's vectors (to account for localization)
% for k=1:length(positions)


%     tempPosition = positions{k};
%     tempPosition(:,1) = tempPosition(:,1)-regMin(1)+1;
%     tempPosition(:,2) = tempPosition(:,2)-regMin(2)+1;
%     positions{k} = tempPosition;
% end
localRegion(:,1) = localRegion(:,1)-regMin(1)+1;
localRegion(:,2) = localRegion(:,2)-regMin(2)+1;
localLocked = ~roipoly(localTempSeg,localRegion(:,1),localRegion(:,2)); % | localLocked;  % INCORRECT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% figure, imshow(localLocked)

% convert to doubles for calculations
% l = double(localLAB(:,:,1));
% a = double(localLAB(:,:,2));
% b = double(localLAB(:,:,3));

[row, col, regValues] = find(unique(localTempSeg));
regValues = regValues'

% if region wasn't selected, then it is considered locked.
% tempUnlocked = false(size(localLocked));
% for r=regValues
%     tempUnlocked = tempUnlocked | localTempSeg==r;
% end
% localLocked = localLocked | ~tempUnlocked;
localLocked = (localTempSeg==0) | localLocked;
localLocked = localLocked | ~localMask; % & localMask;

% figure, imshow(localLocked);  % IS localLocked OPPOSITE OF EXPECTED?????????????? -- yes, b/c of 34
% localLocked = ~localLocked;   % TEMPORARY!!!!!!!!!!!!!!!!!!!!

% competition time
% finished = false;
% k = 0;
% finRegion = false(length(regValues),1);
% while ~finished && nIter~=k
%    k = k+1;
%    fprintf('\tIteration %d...\n',k);
%    prevSeg = localTempSeg;
% for r=1:length(regValues)
if reviewMode
    r = find(regValues == data.I.regionOutlined);
else
    r = 1  % DON'T USE THIS
end
    %if ~finRegion(r)
      
    % find boundaries
%     for n = r:length(regValues)
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
                
                %                     numR = 0;
                %                     numN = 0;
                %
                %                     for p=1:length(row)
                %                         if localTempSeg(row(p),col(p))==0 && localMask(row(p),col(p))
                %                             localTempSeg(row(p),col(p)) = regValues(r);
                %                         else
                %                             pLab = [l(row(p),col(p)) a(row(p),col(p)) b(row(p),col(p))];
                %                             diffR = (regMeans(r,1)-pLab(1)).^2 + (regMeans(r,2)-pLab(2)).^2 ...
                %                                 + (regMeans(r,3)-pLab(3)).^2;
                %                             diffN = (regMeans(n,1)-pLab(1)).^2 + (regMeans(n,2)-pLab(2)).^2 ...
                %                                 + (regMeans(n,3)-pLab(3)).^2;
                %                             if diffR < diffN - compMargin
                %                                 numR = numR + 1;
                %                             else
                %                                 numN = numN + 1;
                %                             end
                %                         end
                %                     end
                
                %                     if numN > numR
                %                         for p=1:length(row)
                %                             localTempSeg(row(p),col(p)) = regValues(n);
                %                         end
                %                     else
                %                         for p=1:length(row)
                %                             localTempSeg(row(p),col(p)) = regValues(r);
                %                         end
                %                     end
            end
        end
    end
% end

if exist('h')
    delete(h);
end
        
%         if all(all(localTempSeg==prevSeg))
%             finRegion(r) = true;
%         end
%     end
% end
% if all(finRegion)
%     finished = true;
% end
% end

data.I.tempSeg(regMin(2):regMax(2),regMin(1):regMax(1)) = localTempSeg;

fprintf('\tUpdating boundaries...\n');

% find new boundaries
if reviewMode
   getBoundaries(data,regValues,data.I.regionOutlined);
else
    getBoundaries(data,regValues,-2);
end
fprintf('\tDone!\n');
end

