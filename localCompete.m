function localCompete( data, positions, reviewMode )
%localCompete Summary of this function goes here
%   Detailed explanation goes here

if nargin==2
    reviewMode = false;
end

fprintf('Local Compete:/n/tInitializing.../n');
compMargin = 0;

% extract important localized region
localRegion = positions{1};
regMin = floor(min(localRegion));   % returned as [x y] or [c r]
regMax = ceil(max(localRegion));    % returned as [x y] or [c r]
localTempSeg = data.I.tempSeg(regMin(2):regMax(2),regMin(1):regMax(1));
localLAB = data.I.lab(regMin(2):regMax(2),regMin(1):regMax(1),:);
localLocked = data.I.locked(regMin(2):regMax(2),regMin(1):regMax(1));
localMask = data.I.mask(regMin(2):regMax(2),regMin(1):regMax(1));

% shift positions's vectors (to account for localization)
for k=1:length(positions)
    tempPosition = positions{k};
    tempPosition(:,1) = tempPosition(:,1)-regMin(1)+1;
    tempPosition(:,2) = tempPosition(:,2)-regMin(2)+1;
    positions{k} = tempPosition;
end
localLocked = localLocked | ~roipoly(localLAB,positions{1}(:,1),positions{1}(:,2));

% convert to doubles for calculations
l = double(localLAB(:,:,1));
a = double(localLAB(:,:,2));
b = double(localLAB(:,:,3));

% find means for each region and the region's value (assumed to be uniform)
%   Note: means do not shift (like they do in global compete)
regMeans = zeros(length(positions)-1,3);
regValues = zeros(1,length(positions)-1,'uint16');
for k=2:length(positions)
    reg = roipoly(localLAB,positions{k}(:,1),positions{k}(:,2));
    regMeans(k-1,1) = mean2(l(reg));
    regMeans(k-1,2) = mean2(a(reg));
    regMeans(k-1,3) = mean2(b(reg));
    regValues(k-1) = localTempSeg(round(positions{k}(1,2)),round(positions{k}(1,1)));
    if regValues(k-1) == 0
        errordlg('Cannot local compete with undefined regions.','Local Compete Error');
        return;
    end
end

% if region wasn't selected, then it is considered locked.
tempUnlocked = false(size(localLocked));
for r=regValues
    tempUnlocked = tempUnlocked | localTempSeg==r;
end
localLocked = localLocked | ~tempUnlocked;
localLocked = localLocked | (localTempSeg==0);
localLocked = localLocked & localMask;

% competition time
finished = false;
k = 0;
uniqueRegValues = unique(regValues);
finRegion = false(length(uniqueRegValues),1);
while ~finished
    k = k+1;
    fprintf('\tIteration %d...\n',k);
    prevSeg = localTempSeg;
    for r=1:length(uniqueRegValues)
        if ~finRegion(r)
            bwRegion = localTempSeg==uniqueRegValues(r);
            
            % find boundaries
            bwBorders = bwperim(~bwRegion,8) & ~localLocked;
            [row, col] = find(bwBorders);
            
            for p=1:length(row)
                if localTempSeg(row(p),col(p))==0 && localMask(row(p),col(p))
                    % grow into undefined regions
                    localTempSeg(row(p),col(p)) = uniqueRegValues(r);
                else
                    % compete pixel
                    [~, rr] = find(regValues==uniqueRegValues(r)); % find material ID for pixel outside boundary
                    [~, n] = find(regValues==localTempSeg(row(p),col(p))); % find material ID for pixel outside boundary
                    pLab = [l(row(p),col(p)) a(row(p),col(p)) b(row(p),col(p))]; % l a b for pixel outside boundary
                    % R - region you are competing in
                    % N - neighbor
                    diffR = zeros(size(rr));
                    for kk=1:length(rr)
                        diffR = (regMeans(rr(kk),1)-pLab(1)).^2 + (regMeans(rr(kk),2)-pLab(2)).^2 ...
                            + (regMeans(rr(kk),3)-pLab(3)).^2;
                    end
                    diffR = min(diffR);
                    diffN = zeros(size(n));
                    for kk=1:length(n) % multiple regions selected for the same material
                        diffN(kk) = (regMeans(n(kk),1)-pLab(1)).^2 + (regMeans(n(kk),2)-pLab(2)).^2 ...
                            + (regMeans(n(kk),3)-pLab(3)).^2;
                    end
                    diffN = min(diffN);
                    if diffR < diffN - compMargin
                        localTempSeg(row(p),col(p)) = uniqueRegValues(r);
                    end
                end
            end
            if all(all(localTempSeg==prevSeg))
                finRegion(r) = true;
            end
        end
    end
    if all(finRegion)
        finished = true;
    end
end

data.I.tempSeg(regMin(2):regMax(2),regMin(1):regMax(1)) = localTempSeg;

fprintf('\tUpdating boundaries...\n');

% find new boundaries
if reviewMode
    getBoundaries(data,uniqueRegValues,data.I.regionOutlined);
else
    getBoundaries(data,uniqueRegValues,-2);
end
fprintf('\tDone!\n');
end

