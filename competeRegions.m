function competeRegions(data, compMargin, nIter)
% data = competeRegions(data, compMargin, nIter)

fprintf('Global Compete (%s):\n\tInitializing...\n',datestr(now));
% convert to doubles for calculations
l = double(data.I.lab(:,:,1));
a = double(data.I.lab(:,:,2));
b = double(data.I.lab(:,:,3));

regions = unique(data.I.tempSeg)';
regions = regions(2:end);   % remove zero
nRegions = length(regions);
finRegion = false(1,nRegions);
currSeg = data.I.tempSeg;
marker = zeros(3);
for k=1:nIter
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
            neighbors = unique(currSeg(bwBorders));
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
                if currSeg(row(p),col(p))==0
                    if data.I.mask(row(p),col(p)) == 1
                        currSeg(row(p),col(p)) = regions(r);
                    end
                elseif ~data.I.locked(row(p),col(p))
                    [n ncol] = find(neighbors==currSeg(row(p),col(p)));
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

fprintf('\tFinding boundaries...\n');

% find new boundaries
getBoundaries(data,[],-2);

fprintf('\tDone! (%s)\n',datestr(now));
end