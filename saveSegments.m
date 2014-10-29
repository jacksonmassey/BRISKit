function saveSegments(data)

if data.I.userID > 6
    
    
%     I_tempSeg = ;
%     I_seg = uint16(data.I.seg);
%     
%     I_conflicts =  ~(I_tempSeg==I_seg | I_seg>=255 );
%     I_resolvedConflicts = zeros(size(I_conflicts),'uint16');
%     if sum(sum(I_conflicts==1)) > 0
%         I_resolvedConflicts = fixConflicts(data,I_conflicts);
%     end
%     % conflicts show as white in a BW if they exist
%     
%     % resolve.  idMaterials for regions.  make black in bw?
%     
%     I_combined = I_seg;
%     I_combined(I_seg >= 255) = I_tempSeg(I_seg >= 255);
%     ind = find(I_resolvedConflicts);
%     I_combined(ind) = I_resolvedConflicts(ind);
%     
    % save
    segments = data.I.tempSeg;
    save([ sprintf('../Segments%s/Seg_',data.I.gPath) data.I.fileName(1:end-3) 'mat'],'segments');
    data.I.seg = segments;
    set(data.handles.figure,'userdata',data);
%     if strcmp(questdlg('Do you want to save to 6 user files?','Save to 6','No'),'Yes')
%         I_userMasks = imread(sprintf('../UserMasks/%susermasks.png',data.I.fileName(1:end-4)));
%         for k=1:6
%             segments = data.I.seg .* uint16(I_userMasks==k);
%             save(sprintf('../Segments/SaveTo6/Seg_%su%d.mat',data.I.fileName(1:end-4),k),'segments');
%         end
%     end
else
    I_tempSeg = data.I.tempSeg .* uint16(data.I.userMask==data.I.userID);
%     I_seg = uint16(data.I.seg .* uint16(data.I.userMask==data.I.userID));
%     
%     I_conflicts =  ~(I_tempSeg==I_seg | I_seg>=255 );
%     I_resolvedConflicts = zeros(size(I_conflicts),'uint16');
%     if sum(sum(I_conflicts==1)) > 0
%         I_resolvedConflicts = fixConflicts(data,I_conflicts);
%     end
%     % conflicts show as white in a BW if they exist
%     
%     % resolve.  idMaterials for regions.  make black in bw?
%     
%     I_combined = I_seg;
%     I_combined(I_seg >= 255) = I_tempSeg(I_seg >= 255);
%     ind = find(I_resolvedConflicts);
%     I_combined(ind) = I_resolvedConflicts(ind);
    I_combined = I_tempSeg;
    
    % save
    segments = I_combined;
    save(sprintf('../Segments%s/SaveTo6/Seg_%su%d.mat',data.I.gPath,data.I.fileName(1:end-4),data.I.userID),'segments');
    data.I.seg = uint16(data.I.userMask ~= data.I.userID).*data.I.seg + uint16(data.I.userMask == data.I.userID).*I_combined;
    set(data.handles.figure,'userdata',data);
    
end
%csg modification
saveColorPNG(data);
end