function certifySlice()

weekNumber = 2;

data = get(findobj('Tag','briskit'),'UserData');

data.I.tempSeg2 = data.I.tempSeg;
data.I.tempSeg = morphRegions(data,'fill');
set(data.handles.figure,'UserData',data);

names = {'User1','User2','User3','User4','User5','User6'};
certIDs = listdlg('ListString',names,...
    'SelectionMode','multiple','Name','Certifier','PromptString','Select Users to Certify:',...
    'CancelString','Cancel');

if isempty(certIDs)
    return;
end

I_userMasks = imread(sprintf('../UserMasks%s/%susermasks.png',data.I.gPath,data.I.fileName(1:end-4)));
fidSK = fopen(sprintf('../Segments%s/Certified/scoreKeeper.txt',data.I.gPath),'a+');
for certs=certIDs
    switch questdlg(sprintf('Select certification level for %s:',names{certs}),...
            'Certification Level','First Try','After Review','Corrected by RA','First Try')
        case 'First Try'
            ptsEarned = 1;
        case 'After Review'
            ptsEarned = 0.5;
        case 'Corrected by RA'
            ptsEarned = 0;
        otherwise
            ptsEarned = -1;
    end
    
    if ptsEarned > -1;
        segments = data.I.seg .* uint16(I_userMasks==certs);
        save(sprintf('../Segments%s/Certified/Seg_%su%d.mat',data.I.gpath,data.I.fileName(1:end-4),certs),'segments');
        
        % WeekNumber	CertifiedDate	SliceNumber	UserName	RegionNumber	PointsEarned
        fprintf(fidSK,'%d\t%s\t%s\t%s\t%d\t%f\n',...
            weekNumber,datestr(now),data.I.fileName(5:end-4),names{certs},certs,ptsEarned);
    end
end

fclose(fidSK);

if strcmp(questdlg('Do you want to load a new image?','Load New','Yes','No','Yes'),'Yes')
    briskit();
end

end