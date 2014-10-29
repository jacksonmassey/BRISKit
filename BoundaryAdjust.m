function BoundaryAdjust(data,bDisplay)
if nargin==1
    bDisplay = true;
end

finished = false;

while ~finished
    finished = true;
    [r c] = find(bwperim(data.I.tempSeg > 0));
    for k=1:length(r)
        for cc=[-1 1]
            if data.I.tempSeg(r(k),c(k)+cc)==0 && data.I.mask(r(k),c(k)+cc)~=0
                data.I.tempSeg(r(k),c(k)+cc) = data.I.tempSeg(r(k),c(k));
                finished = false;
            end
        end
        for rr=[-1 1]
            if data.I.tempSeg(r(k)+rr,c(k))==0 && data.I.mask(r(k)+rr,c(k))~=0
                data.I.tempSeg(r(k)+rr,c(k)) = data.I.tempSeg(r(k),c(k));
                finished = false;
            end
        end
    end
end

data.I.tempSeg = data.I.tempSeg.*uint16(data.I.mask);
if bDisplay
    getBoundaries(data,[],-2);
else
    getBoundaries(data,[],-1);
end
end