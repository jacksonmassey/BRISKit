function localCompeteSmoothHor( data, positions, reviewMode )

if nargin==2
    reviewMode = false;
end

fprintf('Local Compete:\n\tInitializing...\n');
% extract important localized region
localRegion = positions{1};
row1 = round(localRegion(:,2));
col1 = round(localRegion(:,1));
selectedRegion = roipoly(data.I.tempSeg,col1,row1);
[row_sel col_sel] = find(selectedRegion);

%   find means for each region and the region's value (assumed to be uniform)
%   Note: means do not shift (like they do in global compete)
regMeans = zeros(length(positions)-1,3);
regValues = zeros(1,length(positions)-1,'uint16');
for k=2:length(positions)
    trow = round(positions{k}(:,2));
    tcol = round(positions{k}(:,1));
    tSelReg=roipoly(data.I.tempSeg,tcol,trow);
    [rows cols]=find(tSelReg);
    suml=0;
    suma=0;
    sumb=0;
    for tot=1:length(rows)
        suml=suml+double(data.I.lab(rows(tot),cols(tot),1));
        suma=suma+double(data.I.lab(rows(tot),cols(tot),2));
        sumb=sumb+double(data.I.lab(rows(tot),cols(tot),3));
    end
    regMeans(k-1,1) = suml/length(rows);
    regMeans(k-1,2) = suma/length(rows);
    regMeans(k-1,3) = sumb/length(rows);
    regValues(k-1) = data.I.tempSeg(rows(1),cols(1));
    if regValues(k-1) == 0
        errordlg('Cannot local compete with undefined regions.','Local Compete Error');
        return;
    end
end

uniqueRegValues=unique(regValues);
%cut the regions we are not interested in out of selectedRegion

if length(uniqueRegValues)==3
    for ku = 1:length(row_sel)
        if (uniqueRegValues(1)==data.I.tempSeg(row_sel(ku),col_sel(ku))) || (uniqueRegValues(2)==data.I.tempSeg(row_sel(ku),col_sel(ku))) || (uniqueRegValues(3)==data.I.tempSeg(row_sel(ku),col_sel(ku)))
            continue;
        end
        selectedRegion(row_sel(ku),col_sel(ku))=0;
    end
end

if length(uniqueRegValues)==2
    for ku = 1:length(row_sel)
        if (uniqueRegValues(1)==data.I.tempSeg(row_sel(ku),col_sel(ku))) || (uniqueRegValues(2)==data.I.tempSeg(row_sel(ku),col_sel(ku)))
            continue;
        end
        selectedRegion(row_sel(ku),col_sel(ku))=0;
    end
end

[row_sel col_sel] = find(selectedRegion);

dif(1:length(uniqueRegValues))=0;
weights=[1 2 3 2 1];
for tr=1:length(row_sel)
    window = data.I.lab(row_sel(tr),col_sel(tr)-2:col_sel(tr)+2,:);
    % convert to doubles for calculations
    dif(1:length(uniqueRegValues))=0;
    tl = double(window(:,:,1));
    ta = double(window(:,:,2));
    tb = double(window(:,:,3));
    
    meanl=mean2(weights.*tl)/mean2(weights);
    meana=mean2(weights.*ta)/mean2(weights);
    meanb=mean2(weights.*tb)/mean2(weights);
    
    for tn=1:length(uniqueRegValues)
        cc=0;
        for tk=1:length(regMeans(:,1))
            if regValues(tk)==uniqueRegValues(tn)
                dif(tn)=dif(tn) + sqrt((regMeans(tk,1)-meanl).^2 + (regMeans(tk,2)-meana).^2 + (regMeans(tk,3)-meanb).^2);
                cc=cc+1;
            end
        end
        dif(tn)=dif(tn)/cc;
    end
    
    [~, ii]=min(dif);
    
    if selectedRegion(row_sel(tr),col_sel(tr)) == 1
        data.I.tempSeg(row_sel(tr),col_sel(tr)) = uniqueRegValues(ii);
    end
end

fprintf('\tUpdating boundaries...\n');

% find new boundaries
if reviewMode
    getBoundaries(data,uniqueRegValues,data.I.regionOutlined);
else
    getBoundaries(data,uniqueRegValues,-2);
end
fprintf('\tDone!\n');
end

