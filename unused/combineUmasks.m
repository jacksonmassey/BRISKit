for k=2496:2540
    fName = sprintf('../UserMasksFemale/avf%dusermasks.png',k);
    disp(fName)
    I = imread(fName);
    I(I==4) = 6;
    imwrite(I,fName);
end