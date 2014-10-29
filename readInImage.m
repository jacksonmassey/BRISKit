function [I_rgb I_mask] = readInImage(baseFolder, fileName)
%Returns rgb and mask of image at parameter location.
%
%[I_rgb I_mask] = READINIMAGE(baseFolder, fileName)
%   reads in the image located at [baseFolder fileName]
%   and masks it with the mask located at
%   [baseFolder 'Masks/Mask_' fileName].  Both the rgb
%   and the mask are returned.

%     baseFolder = 'BRISKit';
    IFull = imread([baseFolder fileName]);
    
    maskName = [baseFolder 'Masks/' fileName(1:end-4) 'mask.png'];
%     if exist(maskName) == 0
%         maskName = [baseFolder 'Masks/Mask_' fileName];
%     end
    IMask = imread(maskName);
    IMask = IMask~=0;
    tempIMask = IMask(:,:,1); % in case MATLAB reads it as RGB instead of BW
    IMask = tempIMask;
    for k=1:3 
        IFull(:,:,k) = immultiply(IFull(:,:,k),IMask);
    end
    I_rgb = IFull;
    if nargout == 2
        I_mask = IMask;
    end
end