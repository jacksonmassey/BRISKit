function restoreRegions(data)

        set(data.buttons(1),'String','ID Materials',...
            'CallBack','briskit(''idMaterials'')');
        set(data.buttons(2),'String','Show Outline','Visible','on',...
            'CallBack','briskit(''Outline'')');
        set(data.buttons(3),'String','Review','Visible','on',...
            'CallBack','reviewRegions(''Init'')');
        set(data.buttons(4),'String','Undo','Visible','on',...
            'CallBack','briskit(''Undo'')');
        set(data.buttons(5),'String','Manual',...
            'CallBack','briskit(''Manual'')');
        set(data.buttons(6),'String','Other',...
            'CallBack','briskit(''Other'')');
        set(data.buttons(7),'String','Save',...
            'CallBack','briskit(''Save'')');
        
end