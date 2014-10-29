function initApprovedMenu(hFig)
%function initApprovedMenu(hFig)
% initializes Approved menu which contains
% algorithms that have been approved for use
% by everyone.

topMenu = uimenu(hFig,'label','&Approved');
menuItem1 = uimenu(topMenu,'label','Test Function',...
    'CallBack','disp(''test function'')');

end