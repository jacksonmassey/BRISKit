function showOutline(data,I_seg)
%Outlines in green the boundaries of I_seg
%
%   SHOWOUTLINE(data,I_seg) shows the a green
%   outline of the regions in I_seg on top of
%   the images in the briskit data struct.
%   showOutline also updates data stored in 
%   the figure's userdata.

handles = data.handles;
delete(findobj(handles.figure,'type','line'));
nFrames = handles.nFrames;

% figure;
% imshow(mat2gray(I_seg));
for k=1:nFrames
    hold(handles.axes(k),'on');
end
if islogical(I_seg)
    uint16(I_seg)
end
for p=1:max(max(I_seg))
    if sum(sum(I_seg==p)) ~= 0
        boundary = bwboundaries(I_seg==p,4,'holes');
        for k=1:nFrames
            for layer=1:length(boundary)
                if size(boundary{layer},1) > 3
                    plot(handles.axes(k),boundary{layer}(:,2),boundary{layer}(:,1),'g');
                else
                    plot(handles.axes(k),boundary{layer}(:,2),boundary{layer}(:,1),'xg');
                end
            end
        end
    end
end
for k=nFrames:-1:1
    if sum(sum(I_seg==255)) ~= 0
        boundary = bwboundaries(I_seg==255,4,'noholes');
        plot(handles.axes(k),boundary{1}(:,2),boundary{1}(:,1),'r');
    end
    hold(handles.axes(k),'off');
end

data.handles = handles;
set(data.buttons(2),'String','Remove Outline');
set(data.handles.figure,'userdata',data);
end