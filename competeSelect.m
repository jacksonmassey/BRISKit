function data = competeSelect(data, compMargin, nIter, regions,bDisplay,bUpdateBoundaries)
% data = competeRegions(data, compMargin, nIter, regions, display)

if nargin==4
    bDisplay = false;
    bUpdateBoundaries = true;
end

if nargin==5
    bUpdateBoundaries = true;
end

fprintf('Global Compete (%s):\n\tInitializing...\n',datestr(now));
% convert to doubles for calculations
l = double(data.I.lab(:,:,1));
a = double(data.I.lab(:,:,2));
b = double(data.I.lab(:,:,3));

nRegions = length(regions);
finRegion = false(1,nRegions);
currSeg = data.I.tempSeg;
marker = zeros(3,1);
k = 1;
while k~=nIter && ~all(finRegion)
    k=k+1;
    fprintf('\tIteration %d...\n',k);
    
    prevSeg = currSeg;
    % start, per region
    for r=1:nRegions
        % get region statistics
        if ~finRegion(r)
            bwRegion = currSeg==regions(r);
            marker(1) = mean2(a(bwRegion));
            marker(2) = mean2(b(bwRegion));
            marker(3) = mean2(l(bwRegion));
            
            % find boundaries
            bwBorders = bwperim(~bwRegion);
            [row, col] = find(bwBorders);
            
            % get statistics for pixels in boundaries
            neighbors = regions(regions ~= regions(r));
            if neighbors(1) == 0
                neighbors = neighbors(2:end);
            end
            markerN = zeros(nRegions,3);
            for n=1:length(neighbors)
                markerN(n,1) = mean2(a(currSeg==neighbors(n)));
                markerN(n,2) = mean2(b(currSeg==neighbors(n)));
                markerN(n,3) = mean2(l(currSeg==neighbors(n)));
            end
            
            for p=1:length(row) % p for pixel
                if currSeg(row(p),col(p))==0        %   grow into void spaces
                    if data.I.mask(row(p),col(p)) == 1
                        currSeg(row(p),col(p)) = regions(r);
                    end
                elseif ~data.I.locked(row(p),col(p))
                    [n ncol] = find(neighbors==currSeg(row(p),col(p)));
                    if ~isempty(n)
                        pLab = [a(row(p),col(p)) b(row(p),col(p)) l(row(p),col(p))];
                        diffR = (marker(1)-pLab(1)).^2 + ...
                            (marker(2)-pLab(2)).^2 + (marker(3)-pLab(3)).^2;
                        diffN = (markerN(n,1)-pLab(1)).^2 + ...
                            (markerN(n,2)-pLab(2)).^2 + (markerN(n,3)-pLab(3)).^2;
                        if diffR < diffN - compMargin
                            currSeg(row(p),col(p)) = regions(r);
                        end
                    end
                end
            end
            clear markerN neighbors;
            
            if all(all(currSeg==prevSeg))
                % this region has converged 
                % set finRegion(r) so that the region does not iterate again.
                finRegion(r) = true;
            end
        end
    end
    % end per region
    
% go back to start.
end

data.I.tempSeg = currSeg;

% find new boundaries
if bUpdateBoundaries
    fprintf('\tFinding boundaries...\n');
    if bDisplay
        getBoundaries(data,[],-2);
    else
        getBoundaries(data,[],-1);
    end
end

fprintf('\tDone! (%s)\n',datestr(now));
end