function scrollWheelTester
hFig = figure;
hImg = imshow('PixelGrid.png');
hSP = imscrollpanel(hFig,hImg);
hAx = gca;
api = iptgetapi(hSP);
ctrlKey = false;
shiftKey = false;
set(hFig,'WindowScrollWheelFcn',@figScroll,...
    'KeyReleaseFcn',@keyRel,...
    'KeyPressFcn',@keyPress,...
    'WindowButtonDownFcn',@mouseDown);

    function figScroll(src,evnt)
        scrollInc = 30;
        if ctrlKey
            zooms = [ 0.1 0.25 0.33 0.5 0.667 0.75 1 1.5 2 3 4 6 8 12 16 24 32 ];
            %api.setVisibleLocation(xmin, ymin)
            %             ptr = get(hFig,'CurrentPoint')
            ptr = get(hFig,'CurrentPoint')
            mag = api.getMagnification();
            r = api.getVisibleImageRect();
            xmin = r(1);
            ymin = r(2);
            width = r(3);
            height = r(4);
            if evnt.VerticalScrollCount > 0 % scrolled down
                k = 2;
                while mag > zooms(k)
                    k=k+1;
                end
                %                 api.setMagnification(zooms(k-1));
                api.setMagnificationAndCenter(zooms(k-1),ptr(1),ptr(2));
            elseif evnt.VerticalScrollCount < 0 % scrolled up
                k = length(zooms)-1;
                while mag < zooms(k)
                    k=k-1;
                end
                %                 api.setMagnification(zooms(k+1));
                api.setMagnificationAndCenter(zooms(k+1),ptr(1),ptr(2));
            end
        elseif shiftKey
            loc = api.getVisibleLocation();
            if evnt.VerticalScrollCount > 0 % scrolled down
                api.setVisibleLocation(loc(1)-scrollInc,loc(2));
            elseif evnt.VerticalScrollCount < 0 % scrolled up
                api.setVisibleLocation(loc(1)+scrollInc,loc(2));
            end
        else
            loc = api.getVisibleLocation();
            if evnt.VerticalScrollCount > 0 % scrolled down
                api.setVisibleLocation(loc(1),loc(2)+scrollInc);
            elseif evnt.VerticalScrollCount < 0 % scrolled up
                api.setVisibleLocation(loc(1),loc(2)-scrollInc);
            end
        end
    end

    function keyPress(src,evnt)
        if strcmp(evnt.Key,'control')
            ctrlKey = true;
        elseif strcmp(evnt.Key,'shift');
            shiftKey = true;
        end
    end

    function keyRel(src,evnt)
        if strcmp(evnt.Key,'control')
            ctrlKey = false;
        elseif strcmp(evnt.Key,'shift');
            shiftKey = false;
        end
    end

    function mouseDown(src,evnt)
        if strcmp(get(src,'SelectionType'),'alt')
            initPtr = get(hFig,'CurrentPoint');
            initMin = api.getVisibleLocation();
            set(src,'WindowButtonMotionFcn',@mouseMotion);
            set(src,'WindowButtonUpFcn',@mouseUp);
            set(hFig,'Pointer','fleur');
            fprintf('mouseDown\n');
        end
        function mouseMotion(src,evnt)
            ptr = get(hFig,'CurrentPoint');
            mag = api.getMagnification();
            newMin = initMin - (ptr-initPtr).*[1 -1]/mag;
            fprintf('ptr: %d %d\tloc: %f %f\tmag: %f\tnewMin:%f %f\n',ptr(1),ptr(2),initMin(1),initMin(2),mag,newMin(1),newMin(2));
            api.setVisibleLocation(newMin);
        end
        function mouseUp(src,evnt)
            if strcmp(get(src,'SelectionType'),'alt')
                set(src,'WindowButtonMotionFcn','');
                fprintf('mouseUp\n');
                set(hFig,'Pointer','arrow')
            end
        end
    end
end