function [materialID, strMaterial] = chooseMaterial(prompt)
% [materialID, strMaterial] = chooseMaterial(prompt)
%
% prompt is the string that is displayed for the user to read
% materialID returns the material ID for the user selected material
% strMaterial returns the string for the user selected material
% does not support multiple selections

fidMat = fopen('Materials.txt','rt');
k = 1;
% grayValues(k) = -1;
% strMaterials{k} = 'SPLIT REGION';
% k=k+1;
tline = fgetl(fidMat);
while ischar(tline)
    commaIndex = strfind(tline,',');
    grayValues(k) = str2double(tline(1:commaIndex-1));
    strMaterials{k} = tline(commaIndex+1:end);
    k=k+1;
    tline = fgetl(fidMat);
end
fclose(fidMat);
index = listdlg('PromptString',prompt,...
    'SelectionMode','single',...
    'ListString',strMaterials,...
    'ListSize',[200 600]);
if isempty(index)
    materialID = -2;
    if nargout == 2
        strMaterial = ' ';
    end
    return
end
materialID = grayValues(index);
if nargout == 2
    strMaterial = strMaterials{index};
end
end