function interpolated = interpolate(freehandPos)
%interpolated = interpolate(freehandPos)
%
%  interpolated = [colX colY]

x = 0;
y = 0;
for r=1:length(freehandPos)-1
    interpolated2 = inter2(freehandPos(r,:),freehandPos(r+1,:));
    x = [x interpolated2(:,1)'];
    y = [y interpolated2(:,2)'];
end
interpolated = [x(2:end); y(2:end)]';
end

function interpolated2 = inter2(p1, p2)
% p1 = [x1,y1]; p2 = [x2,y2];
nPoints = ceil(sqrt((p1(1)-p2(1)).^2+(p1(2)-p2(2)).^2));
dx = (p2(1)-p1(1))/nPoints;
dy = (p2(2)-p1(2))/nPoints;
if dx==0
    x = p1(1)*ones(1,nPoints);
else
    x = round(p1(1):dx:p2(1)-dx);
end
if dy==0
    y = p1(2)*ones(1,nPoints);
else
    y = round(p1(2):dy:p2(2)-dy);
end
interpolated2 = [ x ; y ]';
end