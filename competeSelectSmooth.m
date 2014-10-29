function data = competeSelectSmooth(data, compMargin, nIter, regions,bDisplay,bUpdateBoundaries)
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

weights=[1 2 3 2 1; 2 4 6 4 2; 3 6 9 6 3; 2 4 6 4 2; 1 2 3 2 1];
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
            %tRegion = bwRegion;
            %for pk=2:length(data.I.tempSeg(:,1))-1
            %    for pb=2:length(data.I.tempSeg(1,:))-1
            %        if any(any(bwRegion(pk-1:pk+1,pb-1:pb+1)))
            %            tRegion(pk,pb)=1;
            %        end
            %    end
            %end            
            
            %bwRegion=tRegion;
            
            bwBorders = bwperim(~bwRegion,8);
            bwBorders(1,:)=0;
            bwBorders(:,1)=0;
            bwBorders(end,:)=0;
            bwBorders(:,end)=0;
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
                window = data.I.lab(row(p)-2:row(p)+2,col(p)-2:col(p)+2,:);
                % convert to doubles for calculations
                tl = double(window(:,:,1));
                ta = double(window(:,:,2));
                tb = double(window(:,:,3));
                meanl=mean2(weights.*tl)/mean2(weights);
                meana=mean2(weights.*ta)/mean2(weights);
                meanb=mean2(weights.*tb)/mean2(weights);
                
                if currSeg(row(p),col(p))==0        %   grow into void spaces
                    if data.I.mask(row(p),col(p)) == 1
                        currSeg(row(p),col(p)) = regions(r);
                    end
                elseif ~data.I.locked(row(p),col(p))
                    [n ncol] = find(neighbors==currSeg(row(p),col(p)));
                    if ~isempty(n)
                        %pLab = [a(row(p),col(p)) b(row(p),col(p)) l(row(p),col(p))];
                        diffR = sqrt((marker(1)-meana).^2) + ...
                            sqrt((marker(2)-meanb).^2) + sqrt((marker(3)-meanl).^2);
                        diffN = sqrt((markerN(n,1)-meana).^2) + ...
                            sqrt((markerN(n,2)-meanb).^2) + sqrt((markerN(n,3)-meanl).^2);
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