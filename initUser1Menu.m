function initUser1Menu(hFig)
%function initUser1Menu(hFig)
% initializes User1's menu which is a test
% bed for Helen's code in development.

topMenu = uimenu(hFig,'label','&User1');
menuItem1 = uimenu(topMenu,'label','Test Function',...
    'CallBack','disp(''test function'')');

end