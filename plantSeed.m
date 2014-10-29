function plantSeed( data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

l = double(data.I.lab(:,:,1));
a = double(data.I.lab(:,:,2));
b = double(data.I.lab(:,:,3));

data.I.tempSeg2 = data.I.tempSeg;

hPoint = impoint(data.handles.axes(1));
pos = round(wait(hPoint));      % [ col row ]
delete(hPoint);

newReg = max(max(data.I.tempSeg))+1;
if newReg <= 256
    newReg = 257;
end
currSeg = data.I.tempSeg;
currSeg(pos(2),pos(1)) = newReg;
blankSeg = false(size(data.I.tempSeg));
thresh = 1000;

for k=1:5
    
    bwRegion = currSeg == newReg;
    marker(1) = mean2(l(bwRegion));
    marker(2) = mean2(a(bwRegion));
    marker(3) = mean2(b(bwRegion));
    
    % find black boundaries
    bwBorders = bwperim(~bwRegion,8)&data.I.mask;
    
    % calculate differences and check boundary differences against
    % a threshold
    diffs = blankSeg;
    diffs(bwBorders) = ( (marker(1)-l(bwBorders)).^2 + ...
        (marker(2)-a(bwBorders)).^2 + ...
        (marker(3)-b(bwBorders)).^2 ) < thresh;
    
    fprintf('%d iterations completed./n',k);
    
    if any(any(diffs))
        % some pixels were below threshold, thus update currSeg
        currSeg(diffs) = newReg;
    else
        % no pixels were below threshold. thus, this region has converged
        % set finished so that the region does not iterate again.
        % finished = true;
    end
end

data.I.tempSeg = currSeg;
getBoundaries(data,[],-2);
end

