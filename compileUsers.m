function compileUsers(sliceNumber)

% needs to include letter.... now only runs for AustinWoman b slices
% should be called inside a for loop over the slices you want to compile

totalSegments = zeros(1120,2048,'uint16');
for k=1:6
    fileName = sprintf('../Segments%s/SaveTo6/Seg_%s%dbu%d.mat',data.I.gPath,data.I.gFile,sliceNumber,k);
    if exist(fileName,'file')
        load(fileName);
        totalSegments = totalSegments + segments;
    end
end

segments = totalSegments;
save(sprintf('../Segments%s/Seg_%s%db.mat',data.I.gPath,data.I.gFile,sliceNumber),'segments');
fprintf('Slice %d compiled.\n',sliceNumber);

end