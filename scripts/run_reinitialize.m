clear

% Needs to be update for Female folders!!

for matNum = 1426:2:1504
    folderPath='../body';
    
    fname = sprintf('Seg_a_vm%d.mat',matNum);
    pname = '../body/Segments/';
    
    arg2 = struct('pname',pname,'fname',fname);
    
    fname = sprintf('Seg_a_vm%d.mat',matNum+1);
    fname(end-length('mat')+1:end)='png';
    fname=fname(length('seg_')+1:end);
    pname=pname(1:end-length('segments/'));
    
    arg1 = struct('pname',pname,'fname',fname);
    pname = arg1.pname;
    fname = arg1.fname;
    command_str = 'open';
    briskit(command_str,arg1,arg2);
    
    Methods('prepScript');
    
    
    %     briskit('Save')
    data = get(findobj('Tag','briskit'),'userdata');
    
    data.I.tempSeg = morphRegions(data,'fill');
    set(data.handles.figure,'userdata',data);
    %%%%%%%%%%%%%%%%%%
    
    segments = data.I.tempSeg;
    save([ data.I.pathName 'Segments/Seg_' data.I.fileName(1:end-3) 'mat'],'segments');
    
    data.I.seg = segments;
    set(data.handles.figure,'userdata',data);
    saveColorPNG(data);
end