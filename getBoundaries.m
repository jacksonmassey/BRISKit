function getBoundaries(data,updateRegions,createPlot,locked)
%getBoundaries(data,updateRegions,createPlot,locked)
%
%   getBoundaries can find or update the
%   boundaries of the regions in tempSeg to help
%   with fast outlining.  getBoundaries can
%   also plot the outline of the regions in 
%   tempSeg on top of the images in the BRISKit
%   user interface.
%   
%   updateRegions = [] -> update all
%   updateRegions = -1 -> don't update
%   *createPlot = region -> only outlines region
%   createPlot = -1 -> don't outline
%   createPlot = -2 -> outline all
%   locked = true -> locked boundaries = blue
%
%   * not implemented yet.

if nargin == 3
    locked = false;
end

% find boundaries portion of code
if isempty(updateRegions)
    data.I.boundaries = ones(size(data.I.boundaries),'int16')*-1;
    
    regions = unique(data.I.tempSeg)';
    for r=regions
        data.I.boundaries(bwperim(data.I.tempSeg==r,4)) = r;
    end
elseif updateRegions == -1
    %don't update
else
    for r=updateRegions
        data.I.boundaries(data.I.boundaries==r) = -1;
        data.I.boundaries(bwperim(data.I.tempSeg==r,4)) = r;
    end
end

% plot boundaries portion of code
if createPlot==-1   % don't plot! 
else
    delete(findobj(data.handles.figure,'type','line'));
    set(data.menus.outlineMenu.markerSizeMenu.s1,'Checked','off');
    set(data.menus.outlineMenu.markerSizeMenu.s2,'Checked','on');
    set(data.menus.outlineMenu.markerSizeMenu.s3,'Checked','off');
    set(data.menus.outlineMenu.markerSizeMenu.s5,'Checked','off');
end
if createPlot==-2   % plot all boundaries!
    hold(data.handles.axes(1),'on');
    [r c] = find(data.I.boundaries > 0);
    plot(data.handles.axes(1),c,r,'sg','MarkerSize',2);
    [r c] = find(data.I.boundaries == 0);
    plot(data.handles.axes(1),c,r,'or','MarkerSize',2);
    hold(data.handles.axes(1),'off');
elseif (size(createPlot,1)>1) && (size(createPlot,2)>1) % createPlot is a matrix -> plot it
    tempBoundaries = ones(size(data.I.boundaries),'int16')*-1;
    regions = unique(createPlot)';
    for r=regions
        tempBoundaries(bwperim(createPlot==r,4)) = r;
    end
    hold(data.handles.axes(1),'on');
    [r c] = find(tempBoundaries > 0);
    plot(data.handles.axes(1),c,r,'sg','MarkerSize',2);
    [r c] = find(tempBoundaries == 0);
    plot(data.handles.axes(1),c,r,'or','MarkerSize',2);
    hold(data.handles.axes(1),'off');
elseif createPlot >= 0  % plot individual regions in createPlot vector
    hold(data.handles.axes(1),'on');
    for k = 1:length(createPlot)
        [r c] = find(data.I.boundaries == createPlot(k));
        if createPlot(k) == 0
            plot(data.handles.axes(1),c,r,'or','MarkerSize',2);
        else
            plot(data.handles.axes(1),c,r,'sg','MarkerSize',2);
        end
    end
    hold(data.handles.axes(1),'off');
end

if locked
    hold(data.handles.axes(1),'on');
    [r c] = find(data.I.locked);
    plot(data.handles.axes(1),c,r,'xb','MarkerSize',2);
    hold(data.handles.axes(1),'off');
end

if strcmp(get(data.menus.outlineMenu.userBound,'Checked'),'on')
    hold(data.handles.axes(1),'on');
    [r c] = find(data.I.userBound);
    plot(data.handles.axes(1),c,r,'xb','MarkerSize',2);
    hold(data.handles.axes(1),'off');
end

set(data.handles.figure,'UserData',data);

end