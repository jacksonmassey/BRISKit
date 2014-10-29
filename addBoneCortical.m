function addBoneCortical( data, positions, reviewMode )
%addBoneCortical - Adds an outer layer of bone cortical to the bones within
%   the selected region.
%   
%   1) Find region that can change.
%   2) Make all bone cortical into bone marrow.
%   3) Find boundary of bone marrow (bwperim w/ conn=4)
%   4) Set the boundary pixels to bone cortical.
%   5) Repeat steps 3-4 for the desired amount (each repeat adds an
%   additional layer of bone cortical = 1/3mm).
%   6) Apply mask from step 1 and save to data.I.tempSeg

if nargin==2
    reviewMode = false;
end

fprintf('Add Bone Cortical:\n');
fprintf('\tInitializing...\n');
% compMargin = 0;

% 1) get mask
localTempMask = roipoly(data.I.tempSeg,positions{1}(:,1),positions{1}(:,2));

% 2) set bc -> bm
localTempSeg = data.I.tempSeg;
localTempSeg(localTempSeg==84)=92; % bc=84; bm=92;

% 5) repeat steps 3-4
for k=1:3
    % 3) find perim
    tempBoundary = bwperim(localTempSeg==92,4);
    % 4) set those pixels to bc
    localTempSeg(tempBoundary) = 84;
end

localTempSeg = uint16(localTempMask).*localTempSeg + uint16(~localTempMask).*data.I.tempSeg;

data.I.tempSeg = localTempSeg;

fprintf('\tUpdating boundaries...\n');

% find new boundaries
if reviewMode
    getBoundaries(data,[84 92],data.I.regionOutlined);
else
    getBoundaries(data,[84 92],-2);
end
fprintf('\tDone!\n');
end