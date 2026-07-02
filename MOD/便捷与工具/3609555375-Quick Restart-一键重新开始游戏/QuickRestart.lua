local IsButtonAddToTopPanel = false
local isBtnVisible = true

local function AddButtonToTopPanel()
    if not IsButtonAddToTopPanel then
        local ctrl:table = ContextPtr:LookUpControl("/InGame/TopPanel/RightContents");
        if ctrl ~= nil then
            Controls.QuickRestartButton:ChangeParent(ctrl);
            ctrl:AddChildAtIndex(Controls.QuickRestartButton, 3);
            Controls.QuickRestartButton:SetToolTipString(Locale.Lookup("LOC_TOP_PANEL_QUICK_RESTART"));
            ctrl:CalculateSize();
            ctrl:ReprocessAnchoring();
            IsButtonAddToTopPanel = true;
        end
    end
end

--[[function OnInputHandler( pInputStruct:table )
	local msg = pInputStruct:GetMessageType();
	if msg == KeyEvents.KeyUp then
		local key = pInputStruct:GetKey();
		if key == Keys.R and pInputStruct:IsAltDown() and not pInputStruct:IsShiftDown() and not pInputStruct:IsControlDown() then
			OnQuickRestartButtonClicked();
			return true;
		end
        if key == Keys.T and pInputStruct:IsAltDown() and not pInputStruct:IsShiftDown()  and not pInputStruct:IsControlDown() then
            ToggleButton();
			return true;
		end
    end
    return false;
end--]]

function OnInputActionTriggered( actionId )
	if actionId == Input.GetActionId("RestartGame") then
		OnQuickRestartButtonClicked();
	end
	if actionId == Input.GetActionId("ToggleButton") then
		ToggleButton();
	end
end

function ToggleButton()
    isBtnVisible = not isBtnVisible;
    Controls.QuickRestartButton:SetHide(not isBtnVisible);
    local parent = Controls.QuickRestartButton:GetParent();
    if parent then
        parent:CalculateSize();
        parent:ReprocessAnchoring();
    end
end

function OnQuickRestartButtonClicked()
    Automation.SetAutoStartEnabled(true);
    Network.RestartGame();   
end

function Initialize()
    if (Automation.IsAutoStartEnabled()) then
        Automation.SetAutoStartEnabled(false);
    end
--    ContextPtr:SetInputHandler( OnInputHandler, true );
    AddButtonToTopPanel();
    Controls.QuickRestartButton:RegisterCallback(Mouse.eLClick, OnQuickRestartButtonClicked);
--    ContextPtr:SetHide(false); 
    Events.InputActionTriggered.Add(OnInputActionTriggered);
end
Events.LoadGameViewStateDone.Add(Initialize)
